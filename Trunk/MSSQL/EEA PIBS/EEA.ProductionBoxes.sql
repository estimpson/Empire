
if	objectproperty(object_id('EEA.ProductionBoxes'), 'IsView') = 1 begin
	drop view EEA.ProductionBoxes
end
go

create view EEA.ProductionBoxes
as
select
	poh.CreateDT
,	poh.Serial
,	poh.WODID
,	poh.Operator
,	poh.Part
,	poh.Quantity
,	BoxStatus = case when poh.Status = 0 then 'Pre-object' when poh.Status = 2 then 'Complete' else 'Canceled' end
,	CompletionDT = bfh.TranDT
from
	FT.PreObjectHistory poh
	left join dbo.BackFlushHeaders bfh on
		bfh.WODID = poh.WODID
		and
			bfh.SerialProduced = poh.Serial
go

select
	CreateDT
,	Serial
,	WODID
,	Operator
,	Part
,	Quantity
,	BoxStatus
,	CompletionDT
from
	EEA.ProductionBoxes pb
where
	pb.WODID = 7
order by
	pb.BoxStatus desc
,	pb.CompletionDT
,	pb.CreateDT
go

