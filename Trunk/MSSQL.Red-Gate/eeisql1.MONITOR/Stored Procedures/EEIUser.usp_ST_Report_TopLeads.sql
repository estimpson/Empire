SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_ST_Report_TopLeads]
as
set nocount on
set ansi_warnings off

--- <Body>
select
	sls.PeakVolume
,	(sls.PeakVolume * clp.HarnessPcbPrice) as PeakVolumeSalesEstimate
,	sls.Customer
,	sls.Program
,	sls.Application
,	sls.BulbType
,	sls.Region
,	convert(varchar, convert(date, sls.SOP)) as SOP
,	convert(varchar, convert(date, sls.EOP)) as EOP
,	coalesce(sd.StatusType, 'No sales activity') as SalesLeadStatus
,	sls.AwardedVolume
,	sls.OEM
,	sls.NamePlate
,	coalesce(e.name, '') as SalesPerson
,	h.RowID as SalesLeadId
,	h.CombinedLightingId
from 
	eeiuser.ST_LightingStudy_2016 sls
	left join eeiuser.ST_SalesLeadLog_Header h
		on h.CombinedLightingId = sls.ID
	left join eeiuser.ST_SalesLeadLog_StatusDefinition sd
		on sd.statusValue = h.Status
	left join eeiuser.ST_CombinedLighting_Pricing clp
		on clp.Description = sls.Description
	left join dbo.employee e
		on e.operator_code = h.SalesPersonCode
where
	sls.PeakVolume > 10000
	and year(sls.SOP) in (2017,2018,2019)
order by
	PeakVolumeSalesEstimate desc
--- </Body>
GO
