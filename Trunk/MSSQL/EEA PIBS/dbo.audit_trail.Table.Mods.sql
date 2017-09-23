alter table audit_trail add id int not null IDENTITY(1, 1)
go
alter table audit_trail alter column type varchar(2)
go
alter table audit_trail drop constraint PK_audit_trail
go
alter table audit_trail add primary key (id)
go
create index ix_audit_trail_1 on audit_trail (serial, date_stamp, type)
go