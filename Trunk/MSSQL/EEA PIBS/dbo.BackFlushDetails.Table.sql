
--drop table dbo.BackFlushDetails
if	object_id ('dbo.BackFlushDetails') is null begin

	create table dbo.BackFlushDetails
	(	ID int not null IDENTITY(1, 1) primary key
	,	BFID int null references dbo.BackFlushHeaders (ID)
	,	BOMID int null
	,	PartConsumed varchar(25) null
	,	SerialConsumed int null
	,	QtyAvailable numeric(20, 6) null
	,	QtyRequired numeric(20, 6) null
	,	QtyIssue numeric(20, 6) null
	,	QtyOverage numeric(20, 6) null
	)
end
go

