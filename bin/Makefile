#
# pg_reorg: bin/Makefile
#
#  Portions Copyright (c) 2008-2012, NIPPON TELEGRAPH AND TELEPHONE CORPORATION
#  Portions Copyright (c) 2011, Itagaki Takahiro
#
SRCS = pg_reorg.c pgut/pgut.c pgut/pgut-fe.c
OBJS = $(SRCS:.c=.o)
PROGRAM = pg_reorg
REGRESS = init reorg

ifdef DEBUG_REORG
PG_CPPFLAGS = -I$(libpq_srcdir) -DDEBUG_REORG
else
PG_CPPFLAGS = -I$(libpq_srcdir)
endif
PG_LIBS = $(libpq)

ifndef USE_PGXS
top_builddir = ../../..
makefile_global = $(top_builddir)/src/Makefile.global
ifeq "$(wildcard $(makefile_global))" ""
USE_PGXS = 1	# use pgxs if not in contrib directory
endif
endif

ifdef USE_PGXS
PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
else
subdir = contrib/$(MODULE_big)
include $(makefile_global)
include $(top_srcdir)/contrib/contrib-global.mk
endif

# remove dependency to libxml2 and libxslt
LIBS := $(filter-out -lxml2, $(LIBS))
LIBS := $(filter-out -lxslt, $(LIBS))

ifndef MAJORVERSION
MAJORVERSION := $(basename $(VERSION))
endif

sql/init.sql: sql/init-$(MAJORVERSION).sql
	cp sql/init-$(MAJORVERSION).sql sql/init.sql
sql/init-8.3.sql:
	cp sql/init-legacy.sql sql/init-8.3.sql
sql/init-8.4.sql:
	cp sql/init-legacy.sql sql/init-8.4.sql
sql/init-9.0.sql:
	cp sql/init-legacy.sql sql/init-9.0.sql
sql/init-9.1.sql:
	cp sql/init-extension.sql sql/init-9.1.sql
sql/init-9.2.sql:
	cp sql/init-extension.sql sql/init-9.2.sql
sql/init-9.3.sql:
	cp sql/init-extension.sql sql/init-9.3.sql

sql/reorg.sql: sql/reorg-$(MAJORVERSION).sql
	cp sql/reorg-$(MAJORVERSION).sql sql/reorg.sql
sql/reorg-8.3.sql:
	cp sql/reorg-v1.sql sql/reorg-8.3.sql
sql/reorg-8.4.sql:
	cp sql/reorg-v1.sql sql/reorg-8.4.sql
sql/reorg-9.0.sql:
	cp sql/reorg-v1.sql sql/reorg-9.0.sql
sql/reorg-9.1.sql:
	cp sql/reorg-v2.sql sql/reorg-9.1.sql
sql/reorg-9.2.sql:
	cp sql/reorg-v2.sql sql/reorg-9.2.sql
sql/reorg-9.3.sql:
	cp sql/reorg-v2.sql sql/reorg-9.3.sql

expected/init.out: expected/init-$(MAJORVERSION).out
	cp expected/init-$(MAJORVERSION).out expected/init.out
expected/init-8.3.out:
	cp expected/init-legacy.out expected/init-8.3.out
expected/init-8.4.out:
	cp expected/init-legacy.out expected/init-8.4.out
expected/init-9.0.out:
	cp expected/init-legacy.out expected/init-9.0.out
expected/init-9.1.out:
	cp expected/init-extension.out expected/init-9.1.out
expected/init-9.2.out:
	cp expected/init-extension.out expected/init-9.2.out
expected/init-9.3.out:
	cp expected/init-extension.out expected/init-9.3.out

expected/reorg.out: expected/reorg-$(MAJORVERSION).out
	cp expected/reorg-$(MAJORVERSION).out expected/reorg.out
expected/reorg-8.3.out:
	cp expected/reorg-v1.out expected/reorg-8.3.out
expected/reorg-8.4.out:
	cp expected/reorg-v1.out expected/reorg-8.4.out
expected/reorg-9.0.out:
	cp expected/reorg-v1.out expected/reorg-9.0.out
expected/reorg-9.1.out:
	cp expected/reorg-v2.out expected/reorg-9.1.out
expected/reorg-9.2.out:
	cp expected/reorg-v2.out expected/reorg-9.2.out
expected/reorg-9.3.out:
	cp expected/reorg-v2.out expected/reorg-9.3.out

installcheck: sql/init.sql sql/reorg.sql expected/init.out expected/reorg.out

clean: subclean

subclean:
	rm -f sql/init.sql sql/init-{8.3,8.4,9.0,9.1,9.2,9.3}.sql
	rm -f sql/reorg.sql sql/reorg-{8.3,8.4,9.0,9.1,9.2,9.3}.sql
	rm -f expected/init.out expected/init-{8.3,8.4,9.0,9.1,9.2,9.3}.out
	rm -f expected/reorg.out expected/reorg-{8.3,8.4,9.0,9.1,9.2,9.3}.out

