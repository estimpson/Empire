SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EEA].[JobScrap]
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
GO
