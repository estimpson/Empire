
/*
Create View.EEH.SupplierEDI.CleanPartDescription.sql
*/

use EEH
go

--drop table SupplierEDI.CleanPartDescription
if	objectproperty(object_id('SupplierEDI.CleanPartDescription'), 'IsView') = 1 begin
	drop view SupplierEDI.CleanPartDescription
end
go

create view SupplierEDI.CleanPartDescription
with encryption
as
with
	partCBase
	(	part
	,	cleanName
	,	defect
	)
	as
	(	select
			p.part
		,	cleanName = convert(varchar(100), substring(p.name, 1, patindex('%[^ ,.0-9A-Z]%', p.name)-1) + substring(p.name, patindex('%[^ ,.0-9A-Z]%', p.name) + 1, 100))
		,	defect = patindex('%[^ ,.0-9A-Z]%', p.name)
		from
			dbo.part p
		where
			patindex('%[^ ,.0-9A-Z]%', p.name) > 0
		union all
		select
			p.part
		,	p.name
		,	0
		from
			dbo.part p
		where
			patindex('%[^ ,.0-9A-Z]%', p.name) = 0
	)
,	partC
	(	part
	,	cleanName
	,	defect
	)
	as
	(	select
			*
		from
			partCBase pcb
		union all
		select
			pc.part
		,	cleanName = convert(varchar(100), substring(pc.cleanName, 1, pc.Defect-1) + substring(pc.cleanName, pc.Defect + 1, 100))
		,	defect = patindex('%[^ ,.0-9A-Z]%', pc.cleanName)
		from
			partC pc
		where
			pc.Defect > 0
	)
select
	pc.part
,	pc.cleanName
from
	partC pc
where
	pc.defect = 0
;
go

select
	*
from
	SupplierEDI.CleanPartDescription
