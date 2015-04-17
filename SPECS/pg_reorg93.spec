# SPEC file for pg_reorg
# Copyright(C) 2009-2015 NIPPON TELEGRAPH AND TELEPHONE CORPORATION
%define sname	pg_reorg

%define _pgdir   /usr/pgsql-9.3
%define _bindir  %{_pgdir}/bin
%define _libdir  %{_pgdir}/lib
%define _datadir %{_pgdir}/share

Summary:	Reorganize tables in PostgreSQL databases without any locks. 
Name:		%{sname}
Version:	1.1.13
Release:	1%{?dist}
License:	BSD
Group:		Applications/Databases
Source0:	%{sname}-%{version}.tar.gz
URL:		http://pgfoundry.org/projects/%{sname}/
BuildRoot:	%{_tmppath}/%{name}-%{version}-%{release}-%(%{__id_u} -n)

BuildRequires:	postgresql93-devel, postgresql93
Requires:	postgresql93, postgresql93-libs

%description 	
pg_reorg can re-organize tables on a postgres database without any locks so that 
you can retrieve or update rows in tables being reorganized. 
The module is developed to be a better alternative of CLUSTER and VACUUM FULL.

%prep
%setup -q -n %{sname}-%{version}

%build
PATH=%{_pgdir}/bin:$PATH USE_PGXS=1 make %{?_smp_mflags}

%install
%define pg_contribdir %{_datadir}/contrib
%define pg_extensiondir %{_datadir}/extension

#rm -rf %{buildroot}

PATH=%{_pgdir}/bin:$PATH USE_PGXS=1 make DESTDIR=%{buildroot}

install -d %{buildroot}%{_libdir}
install -d %{buildroot}%{_bindir}
install -d %{buildroot}%{pg_contribdir}
install -d %{buildroot}%{pg_extensiondir}

install -m 755 bin/pg_reorg             %{buildroot}%{_bindir}/pg_reorg
install -m 755 lib/pg_reorg.so          %{buildroot}%{_libdir}/pg_reorg.so

install -m 644 lib/pg_reorg.sql             %{buildroot}%{pg_contribdir}/pg_reorg.sql
install -m 644 lib/uninstall_pg_reorg.sql   %{buildroot}%{pg_contribdir}/uninstall_pg_reorg.sql

install -m 644 lib/pg_reorg.control           %{buildroot}%{pg_extensiondir}/pg_reorg.control
install -m 644 lib/pg_reorg--%{version}.sql   %{buildroot}%{pg_extensiondir}/pg_reorg--%{version}.sql




%files
%defattr(755,root,root,755)
%{_bindir}/pg_reorg
%{_libdir}/pg_reorg.so
%defattr(644,root,root,755)
#%{_datadir}/contrib/pg_reorg.sql 
#%{_datadir}/contrib/uninstall_pg_reorg.sql 
%{pg_contribdir}/pg_reorg.sql
%{pg_contribdir}/uninstall_pg_reorg.sql
%{pg_extensiondir}/pg_reorg.control
%{pg_extensiondir}/pg_reorg--%{version}.sql

%clean
rm -rf %{buildroot}

%changelog
* Fri Apr 17 2015 - NTT OSS Center <onishi_takashi_d5@lab.ntt.co.jp> 1.1.13-1
* Mon Mar 16 2015 - NTT OSS Center <onishi_takashi_d5@lab.ntt.co.jp> 1.1.12-1
* Mon Jan 05 2015 - NTT OSS Center <onishi_takashi_d5@lab.ntt.co.jp> 1.1.11-1
* Fri May 09 2014 - NTT OSS Center <onishi_takashi_d5@lab.ntt.co.jp> 1.1.10-1
* Thu Nov 21 2013 - NTT OSS Center <onishi_takashi_d5@lab.ntt.co.jp> 1.1.9-1
* Thu May 30 2013 - NTT OSS Center <onishi_takashi_d5@lab.ntt.co.jp> 1.1.8-1
* Thu Oct 21 2010 - NTT OSS Center <sakamoto.masahiko@oss.ntt.co.jp> 1.1.5-1
* Wed Sep 22 2010 - NTT OSS Center <sakamoto.masahiko@oss.ntt.co.jp> 1.1.4-1
* Thu Apr 22 2010 - NTT OSS Center <itagaki.takahiro@oss.ntt.co.jp> 1.1.2-1
* Mon Jan 15 2010 - Toru SHIMOGAKI <shimogaki.toru@oss.ntt.co.jp> 1.0.8-1
* Tue Sep 08 2009 - Toru SHIMOGAKI <shimogaki.toru@oss.ntt.co.jp> 1.0.6-1
* Fri May 15 2009 - Toru SHIMOGAKI <shimogaki.toru@oss.ntt.co.jp> 1.0.4-1
- Initial packaging
