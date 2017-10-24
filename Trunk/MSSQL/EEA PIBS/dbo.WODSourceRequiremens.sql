
--drop table dbo.WODSourceRequiremens
if	object_id ('dbo.WODSourceRequiremens') is null begin

	create table dbo.WODSourceRequiremens
	(	WODID int not null
	,	OrderNo int null
	,	BillTo varchar(10) null
	,	ShipTo varchar(20) null
	,	primary key clustered
		(	WODID
		)
	)
end

