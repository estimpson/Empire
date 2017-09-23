SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_ST_Report_Hitlist]
	@Customer varchar(50)
,	@SOPYear int = null
as
set nocount on
set ansi_warnings off

--- <Body>
if (@SOPYear is null) begin

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
	,	hl.ID
	,	qt.QuoteNumber
	,	ql.EEIPartNumber
	,	ql.EAU
	,	ql.ApplicationName
	,	ql.SalesInitials
	,	ql.QuotePrice
	,	ql.Awarded
	,	ql.QuoteStatus
	,	ql.StraightMaterialCost
	,	ql.TotalQuotedSales
	from 
		eeiuser.ST_LightingStudy_Hitlist_2016 hl
		left join eeiuser.QT_LightingStudy_QuoteNumbers qt
			on qt.LightingStudyId = hl.ID
		left join eeiuser.QT_QuoteLog ql
			on ql.QuoteNumber = qt.QuoteNumber
	where
		hl.Customer = @Customer
	order by
		hl.EstYearlySales desc

end
else begin

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
	,	hl.ID
	,	qt.QuoteNumber
	,	ql.EEIPartNumber
	,	ql.EAU
	,	ql.ApplicationName
	,	ql.SalesInitials
	,	ql.QuotePrice
	,	ql.Awarded
	,	ql.QuoteStatus
	,	ql.StraightMaterialCost
	,	ql.TotalQuotedSales
	from 
		eeiuser.ST_LightingStudy_Hitlist_2016 hl
		left join eeiuser.QT_LightingStudy_QuoteNumbers qt
			on qt.LightingStudyId = hl.ID
		left join eeiuser.QT_QuoteLog ql
			on ql.QuoteNumber = qt.QuoteNumber
	where
		hl.Customer = @Customer
		and hl.SOPYear = @SOPYear
	order by
		hl.EstYearlySales desc

end
--- </Body>
GO
