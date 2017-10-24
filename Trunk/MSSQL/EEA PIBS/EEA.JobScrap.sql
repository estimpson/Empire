
if	objectproperty(object_id('EEA.JobScrap'), 'IsView') = 1 begin
	drop view EEA.JobScrap
end
go

create view EEA.JobScrap
as
select
	d.DefectSerial
,	d.WODID
,	d.Part
,	d.DefectCode
,	ScrapQty = sum(d.QtyScrapped)
,	ScrapDT = min(d.TransactionDT)
from
	FT.Defects d
group by
	d.DefectSerial
,	d.WODID
,	d.Part
,	d.DefectCode
go

select
	DefectSerial
,	WODID
,	Part
,	DefectCode
,	ScrapQty
,	ScrapDT
from
	EEA.JobScrap js
order by
	ScrapDT
