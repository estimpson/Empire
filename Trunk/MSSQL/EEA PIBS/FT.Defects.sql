
--drop table FT.Defects
if	object_id ('FT.Defects') is null begin

	create table FT.Defects
	(	ID int not null IDENTITY(1, 1) primary key
	,	TransactionDT datetime not null
	,	Machine varchar(10) not null
	,	Part varchar(25) not null
	,	DefectCode varchar(20) null
	,	QtyScrapped numeric(20, 6) null
	,	Operator varchar(10) null
	,	Shift char(1) null
	,	WODID int null
	,	DefectSerial int null
	,	Comments varchar(150) null
	,	AuditTrailID int null
	,	AreaToCharge varchar(25) null
	)
end
go

if	not exists
	(	select
			*
		from
			dbo.sysindexes
		where
			id = object_id(N'FT.Defects')
			and name = N'idx_Defects_1'
	) begin
	
    create nonclustered index idx_Defects_1 on FT.Defects 
    (	DefectSerial asc
    ,	ID asc
    )
end
go

if	not exists
	(	select
			*
		from
			dbo.sysindexes
		where
			id = object_id(N'FT.Defects')
			and name = N'idx_Defects_2'
	) begin
	
    create nonclustered index idx_Defects_2 on FT.Defects 
    (	TransactionDT asc
    ,	DefectCode asc
    ,	Part asc
    ,	DefectSerial asc
    )
end
go
