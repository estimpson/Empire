
--drop table dbo.BackFlushHeaders
if	object_id ('dbo.BackFlushHeaders') is null begin

	create table dbo.BackFlushHeaders
	(
		ID int not null IDENTITY(1, 1) primary key
	,	WODID int null
	,	PartProduced varchar(25) null
	,	SerialProduced int null
	,	QtyProduced numeric(20, 6) null
	,	TranDT datetime null
	)
end
go

