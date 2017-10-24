SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE view [EEIUser].[vw_ST_LightingStudy_2016]
as
select
	sls.Customer
,	sls.Program
,	convert(varchar, convert(date, sls.SOP)) as SOP
,	year(sls.SOP) as SOPYear
,	convert(varchar, convert(date, sls.EOP)) as EOP
,	year(sls.EOP) as EOPYear
,	sls.BulbType
,	sls.Application
,	sls.Description
,	sls.OEM
,	sls.NamePlate
,	sls.Label
,	sls.Region
,	coalesce(sls.Status, 'Open') as Status
,	sls.Volume2017
,	sls.Volume2018
,	sls.Volume2019
,	sls.PeakVolume
,	sls.AwardedVolume
,	isnull(sls.ID, 0) as ID
,	coalesce(e.name, '') as SalesPerson
from
	eeiuser.ST_LightingStudy_2016 sls 
	left join eeiuser.ST_SalesLeadLog_Header h
		on h.CombinedLightingId = sls.ID
	left join dbo.employee e
		on e.operator_code = h.SalesPersonCode
where
	sls.PeakVolume > 0


GO
