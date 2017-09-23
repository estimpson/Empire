SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EEA].[JobConsumption]
as
select
	bfh.WODID
,	bfd.SerialConsumed
,	bfd.PartConsumed
,	QtyIssue = sum (bfd.QtyIssue)
,	QtyScrap = coalesce((select sum(ScrapQty) from EEA.JobScrap where WODID = bfh.WODID and DefectSerial = bfd.SerialConsumed), 0)
,	QtyOverage = sum (bfd.QtyOverage)
from
	dbo.BackFlushHeaders bfh
	join dbo.BackFlushDetails bfd
		on bfd.BFID = bfh.ID
group by
	bfh.WODID
,	bfd.SerialConsumed
,	bfd.PartConsumed
GO
