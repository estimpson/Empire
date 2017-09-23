
--drop table FT.PreObjectHistory
if	object_id ('FT.PreObjectHistory') is null begin

	create table FT.PreObjectHistory
	(	ID int not null IDENTITY(1, 1) primary key
	,	CreateDT datetime not null default (getdate())
	,	Serial int null
	,	WODID int not null
	,	Operator varchar(10) not null
	,	Part varchar(25) not null
	,	Quantity numeric(20,6) null
	,	Status smallint null default (0)
	,	unique (Serial)
	)
end
go
