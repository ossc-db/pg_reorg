pg_reorg -- UNOFFICIAL REPOSITORY
=================================

* maint_1.1 branch: .. image:: https://travis-ci.org/bwtakacy/pg_reorg.svg?branch=maint_1.1
    :target: https://travis-ci.org/bwtakacy/pg_reorg

This is NOT the official pg_reorg repository. Official development is
currently on pgFoundry: http://pgfoundry.org/projects/reorg

This repository (and the url https://github.com/reorg) has been set up
to provide greater visibility and easier contribution to the
pg_reorg project, an intention apparent from a recent `mailing list
discussion`__.

.. __: http://archives.postgresql.org/pgsql-hackers/2012-09/msg00746.php

The current pg_reorg maintainers have been be invited to the organization with
administrative privileges, keeping total control of the project.

----

In this repository there are changesets fixing pg_reorg 1.1.7 bugs and
shortcomings (in the ``maint_1.1`` branch) and new development ideas (in the
``master`` branch and several feature branches). Not having heard recently
from pg_reorg authors, we don't think we have the authority to distribute them
as a new pg_reorg release.  For this reason, the fork pg_repack_ is being
developed.

.. _pg_repack: https://github.com/reorg/pg_repack

----

This repository has been converted from CVS using the command::

	git cvsimport -v -d :pserver:anonymous@cvs.pgfoundry.org:/cvsroot/reorg -A pg_reorg.auths -C pg_reorg -k -r cvs pg_reorg

with a suitably populated pg_reorg.auths.

I assume new CSV commits will be added to ``remotes/cvs/master``, but I'm not
sure yet, so please consider this repository unstable until the development
model has been organized.

