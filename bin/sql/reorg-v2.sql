SET client_min_messages = warning;
--
-- create table.
--
CREATE TABLE tbl_cluster (
	col1 int,
	"time" timestamp,
	","")" text,
	PRIMARY KEY (","")", col1) WITH (fillfactor = 75)
) WITH (fillfactor = 70);

CREATE INDEX ","") cluster" ON tbl_cluster ("time", length(","")"), ","")" text_pattern_ops) WITH (fillfactor = 75);
ALTER TABLE tbl_cluster CLUSTER ON ","") cluster";

CREATE TABLE tbl_only_pkey (
	col1 int PRIMARY KEY,
	","")" text
);

CREATE TABLE tbl_only_ckey (
	col1 int,
	col2 timestamp,
	","")" text
) WITH (fillfactor = 70);

CREATE INDEX cidx_only_ckey ON tbl_only_ckey (col2, ","")");
ALTER TABLE tbl_only_ckey CLUSTER ON cidx_only_ckey;

CREATE TABLE tbl_gistkey (
	id integer PRIMARY KEY,
	c circle
);

CREATE INDEX cidx_circle ON tbl_gistkey USING gist (c);
ALTER TABLE tbl_gistkey CLUSTER ON cidx_circle;

CREATE TABLE tbl_with_dropped_column (
	d1 text,
	c1 text,
	id integer PRIMARY KEY,
	d2 text,
	c2 text,
	d3 text
);
ALTER INDEX tbl_with_dropped_column_pkey SET (fillfactor = 75);
ALTER TABLE tbl_with_dropped_column CLUSTER ON tbl_with_dropped_column_pkey;
CREATE INDEX idx_c1c2 ON tbl_with_dropped_column (c1, c2) WITH (fillfactor = 75);
CREATE INDEX idx_c2c1 ON tbl_with_dropped_column (c2, c1);

CREATE TABLE tbl_with_dropped_toast (
	i integer,
	j integer,
	t text,
	PRIMARY KEY (i, j)
);
ALTER TABLE tbl_with_dropped_toast CLUSTER ON tbl_with_dropped_toast_pkey;

CREATE TABLE tbl_badindex (
	id integer PRIMARY KEY,
	n integer
);

--
-- insert data
--

INSERT INTO tbl_cluster VALUES(1, '2008-12-31 10:00:00', 'admin');
INSERT INTO tbl_cluster VALUES(2, '2008-01-01 00:00:00', 'king');
INSERT INTO tbl_cluster VALUES(3, '2008-03-04 12:00:00', 'joker');
INSERT INTO tbl_cluster VALUES(4, '2008-03-05 15:00:00', 'queen');
INSERT INTO tbl_cluster VALUES(5, '2008-01-01 00:30:00', sqrt(2::numeric(1000,999))::text || sqrt(3::numeric(1000,999))::text);

INSERT INTO tbl_only_pkey VALUES(1, 'abc');
INSERT INTO tbl_only_pkey VALUES(2, 'def');

INSERT INTO tbl_only_ckey VALUES(1, '2008-01-01 00:00:00', 'abc');
INSERT INTO tbl_only_ckey VALUES(2, '2008-02-01 00:00:00', 'def');

INSERT INTO tbl_gistkey VALUES(1, '<(1,2),3>');
INSERT INTO tbl_gistkey VALUES(2, '<(4,5),6>');

INSERT INTO tbl_with_dropped_column VALUES('d1', 'c1', 2, 'd2', 'c2', 'd3');
INSERT INTO tbl_with_dropped_column VALUES('d1', 'c1', 1, 'd2', 'c2', 'd3');
ALTER TABLE tbl_with_dropped_column DROP COLUMN d1;
ALTER TABLE tbl_with_dropped_column DROP COLUMN d2;
ALTER TABLE tbl_with_dropped_column DROP COLUMN d3;
ALTER TABLE tbl_with_dropped_column ADD COLUMN c3 text;
CREATE VIEW view_for_dropped_column AS
	SELECT * FROM tbl_with_dropped_column;

INSERT INTO tbl_with_dropped_toast VALUES(1, 10, 'abc');
INSERT INTO tbl_with_dropped_toast VALUES(2, 20, sqrt(2::numeric(1000,999))::text || sqrt(3::numeric(1000,999))::text);
ALTER TABLE tbl_with_dropped_toast DROP COLUMN t;

INSERT INTO tbl_badindex VALUES(1, 10);
INSERT INTO tbl_badindex VALUES(2, 10);

-- This will fail. Silence the message as it's different across PG versions.
SET client_min_messages = fatal;
CREATE UNIQUE INDEX CONCURRENTLY idx_badindex_n ON tbl_badindex (n);
SET client_min_messages = warning;

--
-- before
--

SELECT * FROM tbl_with_dropped_column;
SELECT * FROM view_for_dropped_column;
SELECT * FROM tbl_with_dropped_toast;

--
-- do reorg
--

\! pg_reorg --dbname=contrib_regression --no-order
\! pg_reorg --dbname=contrib_regression
\! pg_reorg --dbname=contrib_regression --table=tbl_cluster

--
-- after
--

\d tbl_cluster
\d tbl_gistkey
\d tbl_only_ckey
\d tbl_only_pkey
\d tbl_with_dropped_column
\d tbl_with_dropped_toast

SELECT col1, to_char("time", 'YYYY-MM-DD HH24:MI:SS'), ","")" FROM tbl_cluster;
SELECT * FROM tbl_only_ckey ORDER BY 1;
SELECT * FROM tbl_only_pkey ORDER BY 1;
SELECT * FROM tbl_gistkey ORDER BY 1;

SET enable_seqscan = on;
SET enable_indexscan = off;
SELECT * FROM tbl_with_dropped_column;
SELECT * FROM view_for_dropped_column;
SELECT * FROM tbl_with_dropped_toast;
SET enable_seqscan = off;
SET enable_indexscan = on;
SELECT * FROM tbl_with_dropped_column;
SELECT * FROM view_for_dropped_column;
SELECT * FROM tbl_with_dropped_toast;
RESET enable_seqscan;
RESET enable_indexscan;

--
-- check broken links or orphan toast relations
--
SELECT oid, relname
  FROM pg_class
 WHERE relkind = 't'
   AND oid NOT IN (SELECT reltoastrelid FROM pg_class WHERE relkind = 'r');

SELECT oid, relname
  FROM pg_class
 WHERE relkind = 'r'
   AND reltoastrelid <> 0
   AND reltoastrelid NOT IN (SELECT oid FROM pg_class WHERE relkind = 't');

--
-- NOT NULL UNIQUE
--
CREATE TABLE tbl_nn    (col1 int NOT NULL, col2 int NOT NULL);
CREATE TABLE tbl_uk    (col1 int NOT NULL, col2 int         , UNIQUE(col1, col2));
CREATE TABLE tbl_nn_uk (col1 int NOT NULL, col2 int NOT NULL, UNIQUE(col1, col2));
CREATE TABLE tbl_pk_uk (col1 int NOT NULL, col2 int NOT NULL, PRIMARY KEY(col1, col2), UNIQUE(col2, col1));
CREATE TABLE tbl_nn_puk (col1 int NOT NULL, col2 int NOT NULL);
CREATE UNIQUE INDEX tbl_nn_puk_pcol1_idx ON tbl_nn_puk(col1) WHERE col1 < 10;
\! pg_reorg --dbname=contrib_regression --no-order --table=tbl_nn
-- => ERROR
\! pg_reorg --dbname=contrib_regression --no-order --table=tbl_uk
-- => ERROR
\! pg_reorg --dbname=contrib_regression --no-order --table=tbl_nn_uk
-- => OK
\! pg_reorg --dbname=contrib_regression --no-order --table=tbl_pk_uk
-- => OK
\! pg_reorg --dbname=contrib_regression --no-order --table=tbl_nn_puk
-- => ERROR

--
-- pg_repack issue #3
--
CREATE TABLE issue3 (col1 int NOT NULL, col2 text NOT NULL);
CREATE UNIQUE INDEX issue3_idx1 ON issue3 (col1, col2 DESC);
CREATE UNIQUE INDEX issue3_idx2 ON issue3 (col1 DESC, col2 text_pattern_ops);
CREATE UNIQUE INDEX issue3_idx3 ON issue3 (col1 DESC, col2 DESC);
CREATE UNIQUE INDEX issue3_idx4 ON issue3 (col1 NULLS FIRST, col2 text_pattern_ops DESC NULLS LAST);
CREATE UNIQUE INDEX issue3_idx5 ON issue3 (col1 DESC NULLS FIRST, col2 COLLATE "POSIX" DESC);

SELECT reorg.get_order_by('issue3_idx1'::regclass::oid, 'issue3'::regclass::oid);
SELECT reorg.get_order_by('issue3_idx2'::regclass::oid, 'issue3'::regclass::oid);
SELECT reorg.get_order_by('issue3_idx3'::regclass::oid, 'issue3'::regclass::oid);
SELECT reorg.get_order_by('issue3_idx4'::regclass::oid, 'issue3'::regclass::oid);
SELECT reorg.get_order_by('issue3_idx5'::regclass::oid, 'issue3'::regclass::oid);

--
-- pg_reorg --all can skip databases where pg_reorg is not registered
--
\! pg_reorg --all -E FATAL | grep skipped | uniq
