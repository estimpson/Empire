SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EEA].[ProductionBoxes]
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
GO
