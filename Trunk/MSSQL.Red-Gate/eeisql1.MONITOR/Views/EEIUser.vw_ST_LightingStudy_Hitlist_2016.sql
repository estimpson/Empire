SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE view [EEIUser].[vw_ST_LightingStudy_Hitlist_2016]
as
select
	hl.Customer
,	hl.Program
,	hl.EstYearlySales
,	hl.PeakYearlyVolume
,	hl.SOPYear
,	hl.[LED/Harness]
,	hl.[Application]
,	hl.Region
,	hl.[OEM]
,	hl.NamePlate
,	hl.Component
,	convert(varchar, convert(date, hl.SOP)) as SOP
,	convert(varchar, convert(date, hl.EOP)) as EOP
,	hl.[Type]
,	hl.Price
,	hl.Volume2017
,	hl.Volume2018
,	hl.Volume2019
,	hl.Volume2020
,	hl.Volume2021
,	hl.Volume2022
,	coalesce(hl.Status, 'Open') as [Status]
,	hl.AwardedVolume
,	hl.ID
,	coalesce(e.name, '') as SalesPerson
from
	eeiuser.ST_LightingStudy_Hitlist_2016 hl 
	left join eeiuser.ST_SalesLeadLog_Header h
		on h.CombinedLightingId = hl.ID
	left join dbo.employee e
		on e.operator_code = h.SalesPersonCode
where
	hl.PeakYearlyVolume > 0



GO
