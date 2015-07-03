pg_reorg
=======
This tools re-organize tables on a PostgreSQL database without keeping any locks so that you can retrieve or update rows.

Now, the development of pg_reorg has been stopped.
We keep maintain stable branch maint_1.1 for already supported PostgreSQL version, 8.4 to 9.4.

* maint_1.1 : [![Build Status](https://travis-ci.org/ossc-db/pg_reorg.svg?branch=maint_1.1)](https://travis-ci.org/ossc-db/pg_reorg)

Recently, we plan to stop doing maintain pg_reorg  and start contribute  to [pg_repack](http://github.com/reorg/pg_repack) project.

How to use
----------
pg_reorg run for a specified table like below:

````
$ pg_reorg -t test1 -o a
INFO: ---- reorganize one table with 7 steps. ----
INFO: target table name    : test1
INFO: ---- STEP1. setup ----
INFO: This needs EXCLUSIVE LOCK against the target table.
INFO: ---- STEP2. copy tuples into temp table----
INFO: ---- STEP3. create indexes ----
INFO: ---- STEP4. apply logs  ----
INFO: ---- STEP5. swap tables ----
INFO: This needs EXCLUSIVE LOCK against the target table.
INFO: ---- STEP6. drop old table----
INFO: ---- STEP7. analyze ---
````

See documentation about detail usage.

http://ossc-db.github.io/pg_reorg/index.html

How to build and install from source code
-----------------------------------------
Change directory into top directory of pg_reorg sorce codes and
run the below commands.

````
 $ make
 # make install
````

How to run regression tests
---------------------------
Start PostgreSQL server and run the below command.

````
 $ make installcheck
````

