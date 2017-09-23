SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_ST_Report_Hitlist_MSF_Dashboard]
	@Customer varchar(50) = null
,	@SOPYear int = null
as
set nocount on
set ansi_warnings off

--- <Body>
declare
	@SalesForecastData table
(	Vehicle varchar(511)
,	BasePart varchar(30)
,	ParentCustomer varchar(50)
,	EmpireApplication varchar(500)
,	EmpireMarketSegment varchar(200)
,	ProductLine varchar(25)
,	Cal_16_Sales numeric(20,6)
,	Cal_17_Sales numeric(20,6)
,	Cal_18_Sales numeric(20,6)
,	Cal_19_Sales numeric(20,6)
,	Cal_20_Sales numeric(20,6)
,	Cal_21_Sales numeric(20,6)
,	Cal_22_Sales numeric(20,6)
,	RowID int not null IDENTITY(1, 1)
,	primary key (BasePart, RowID)
)

insert
	@SalesForecastData
select
	vehicle
,	base_part
,	parent_customer
,	empire_application
,	empire_market_segment
,	product_line
,	Cal_16_Sales
,	Cal_17_Sales
,	Cal_18_Sales
,	Cal_19_Sales
,	Cal_20_Sales
,	Cal_21_Sales
,	Cal_22_Sales
from
	EEIUser.acctg_csm_vw_select_sales_forecast acvssf
where
	parent_customer in (	
		select
			sf.SalesForecastParentCustomer
		from 
			EEIUser.ST_SalesForecastParentCustomers sf
		where
			sf.LightingStudyCustomer = @Customer
			and sf.SalesForecastParentCustomer is not null )


declare @tempHitlistQuoteLog table
(
	Customer varchar(50)
,	Program varchar(50)
,	EstYearlySales int
,	PeakYearlyVolume int
,	SOPYear int
,	[LED/Harness] varchar(50)
,	[Application] varchar(50)
,	Region varchar(50)
,	[OEM] varchar(50)
,	NamePlate varchar(50)
,	Component varchar(50)
,	SOP varchar(20)
,	EOP varchar(20)
,	[Type] varchar(50)
,	Price decimal(10,2)
,	Volume2017 int 
,	Volume2018 int
,	Volume2019 int
,	Volume2020 int
,	Volume2021 int
,	Volume2022 int
,	ID int
,	SalesLeadId int
,	SalesPerson varchar(50)
,	QuoteNumber varchar(50)
,	EEIPartNumber varchar(50)
,	EAU numeric(20,0)
,	ApplicationName varchar(255)
,	SalesInitials varchar(10)
,	QuotePrice numeric(20,4)
,	Awarded char(3)
,	QuoteStatus varchar(10)
,	StraightMaterialCost numeric(20,6)
,	TotalQuotedSales numeric(38,4)
,	SalesForecastEEIBasePart varchar(500) null
,	SalesForecastPeakYearlyVolume decimal(20,6) null
,	SalesForecastApplication varchar(1000)
,	RowID int identity
,	primary key(ID, RowID)
)


if (@SOPYear is null) begin

	-- STEP 1:  Get Lighting Study Hitlist data, plus Quote Log data tied to LSH records, plus MSF base parts tied to LSH records
	-- Headlamps, LED (PCB)
	with cte_head_pcb (Vehicle, Applications, BaseParts)
	as
	(
		--select
		--	sf.vehicle as Vehicle
		--,	FX.ToList(sf.base_part) as BaseParts
		--from 
		--	eeiuser.acctg_csm_vw_select_sales_forecast sf
		--where 
		--	sf.parent_customer in (	
		--		select
		--			sf.SalesForecastParentCustomer
		--		from 
		--			EEIUser.ST_SalesForecastParentCustomers sf
		--		where
		--			sf.LightingStudyCustomer = @Customer
		--			and sf.SalesForecastParentCustomer is not null )
		--	and sf.empire_application like '%head%'
		--group by
		--	sf.vehicle
		select
			sfd.Vehicle as Vehicle
		,	FX.ToList(distinct sfd.EmpireApplication) as Applications
		,	FX.ToList(distinct sfd.BasePart) as BaseParts
		from 
			@SalesForecastData sfd
		where 
			sfd.EmpireApplication like '%head%'
			and (	(CHARINDEX('LED', sfd.EmpireApplication ) > 0)
				or	(CHARINDEX('LED', sfd.EmpireMarketSegment ) > 0)
				or	(CHARINDEX('LED', sfd.ProductLine ) > 0) 
				or	(CHARINDEX('PCB', sfd.EmpireApplication ) > 0)
				or	(CHARINDEX('PCB', sfd.EmpireMarketSegment ) > 0)
				or	(CHARINDEX('PCB', sfd.ProductLine ) > 0) )
		group by
			sfd.Vehicle
	)
	,
	
	-- Headlamps, Harness
	cte_head_harness (Vehicle, Applications, BaseParts)
	as
	(
		select
			sfd.Vehicle as Vehicle
		,	FX.ToList(distinct sfd.EmpireApplication) as Applications
		,	FX.ToList(distinct sfd.BasePart) as BaseParts
		from 
			@SalesForecastData sfd
		where 
			sfd.EmpireApplication like '%head%'
			and (	(CHARINDEX('LED', sfd.EmpireApplication ) = 0)
				and	(CHARINDEX('LED', sfd.EmpireMarketSegment ) = 0)
				and	(CHARINDEX('LED', sfd.ProductLine ) = 0) 
				and	(CHARINDEX('PCB', sfd.EmpireApplication ) = 0)
				and	(CHARINDEX('PCB', sfd.EmpireMarketSegment ) = 0)
				and	(CHARINDEX('PCB', sfd.ProductLine ) = 0) )
		group by
			sfd.Vehicle
	)

	insert into @tempHitlistQuoteLog
	(
		Customer
	,	Program
	,	EstYearlySales
	,	PeakYearlyVolume
	,	SOPYear
	,	[LED/Harness]
	,	Application
	,	Region
	,	OEM
	,	NamePlate
	,	Component
	,	SOP
	,	EOP
	,	Type
	,	Price
	,	Volume2017
	,	Volume2018
	,	Volume2019
	,	Volume2020
	,	Volume2021
	,	Volume2022
	,	ID
	,	SalesLeadId
	,	SalesPerson
	,	QuoteNumber
	,	EEIPartNumber
	,	EAU
	,	ApplicationName
	,	SalesInitials
	,	QuotePrice
	,	Awarded
	,	QuoteStatus
	,	StraightMaterialCost
	,	TotalQuotedSales
	,	SalesForecastEEIBasePart
	,	SalesForecastPeakYearlyVolume
	,	SalesForecastApplication
	)

	select distinct
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
	,	h.RowID
	,	coalesce(e.name, '') as SalesPerson
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
	,	case
			when coalesce(pcb.BaseParts, '') <> '' then pcb.BaseParts
			else harness.BaseParts
		end as BaseParts
	,	0.0
	,	case
			when coalesce(pcb.Applications, '') <> '' then pcb.Applications
			else harness.Applications
		end as Applications
	from 
		eeiuser.ST_LightingStudy_Hitlist_2016 hl
		left join eeiuser.QT_LightingStudy_QuoteNumbers qt
			on qt.LightingStudyId = hl.ID
		left join eeiuser.QT_QuoteLog ql
			on ql.QuoteNumber = qt.QuoteNumber	
		left join eeiuser.ST_SalesLeadLog_Header h
			on h.CombinedLightingId = hl.ID
		left join dbo.employee e
			on e.operator_code = h.SalesPersonCode
		left join cte_head_pcb pcb
			on (pcb.Vehicle like '%' + hl.Nameplate + '%' COLLATE Latin1_General_CS_AS )
			and hl.[LED/Harness] = 'LED'
		left join cte_head_harness harness
			on (harness.Vehicle like '%' + hl.Nameplate + '%' COLLATE Latin1_General_CS_AS )
			and hl.[LED/Harness] = 'Harness'
	where
		hl.Customer = @Customer
		and hl.[Application] like '%head%'
	;	
		

	

	-- Taillamps, LED (PCB)
	with cte_tail_pcb (Vehicle, Applications, BaseParts)
	as
	(
		select
			sfd.Vehicle as Vehicle
		,	FX.ToList(distinct sfd.EmpireApplication) as Applications
		,	FX.ToList(sfd.BasePart) as BaseParts
		from 
			@SalesForecastData sfd
		where 
			sfd.EmpireApplication like '%tail%'
			and (	(CHARINDEX('LED', sfd.EmpireApplication ) > 0)
				or	(CHARINDEX('LED', sfd.EmpireMarketSegment ) > 0)
				or	(CHARINDEX('LED', sfd.ProductLine ) > 0) 
				or	(CHARINDEX('PCB', sfd.EmpireApplication ) > 0)
				or	(CHARINDEX('PCB', sfd.EmpireMarketSegment ) > 0)
				or	(CHARINDEX('PCB', sfd.ProductLine ) > 0) )
		group by
			sfd.Vehicle
	)
	,
	
	-- Taillamps, Harness
	cte_tail_harness (Vehicle, Applications, BaseParts)
	as
	(
		select
			sfd.Vehicle as Vehicle
		,	FX.ToList(distinct sfd.EmpireApplication) as Applications
		,	FX.ToList(distinct sfd.BasePart) as BaseParts
		from 
			@SalesForecastData sfd
		where 
			sfd.EmpireApplication like '%tail%'
			and (	(CHARINDEX('LED', sfd.EmpireApplication ) = 0)
				and	(CHARINDEX('LED', sfd.EmpireMarketSegment ) = 0)
				and	(CHARINDEX('LED', sfd.ProductLine ) = 0) 
				and	(CHARINDEX('PCB', sfd.EmpireApplication ) = 0)
				and	(CHARINDEX('PCB', sfd.EmpireMarketSegment ) = 0)
				and	(CHARINDEX('PCB', sfd.ProductLine ) = 0) )
		group by
			sfd.Vehicle
	)
	
	insert into @tempHitlistQuoteLog
	(
		Customer
	,	Program
	,	EstYearlySales
	,	PeakYearlyVolume
	,	SOPYear
	,	[LED/Harness]
	,	Application
	,	Region
	,	OEM
	,	NamePlate
	,	Component
	,	SOP
	,	EOP
	,	Type
	,	Price
	,	Volume2017
	,	Volume2018
	,	Volume2019
	,	Volume2020
	,	Volume2021
	,	Volume2022
	,	ID
	,	SalesLeadId
	,	SalesPerson
	,	QuoteNumber
	,	EEIPartNumber
	,	EAU
	,	ApplicationName
	,	SalesInitials
	,	QuotePrice
	,	Awarded
	,	QuoteStatus
	,	StraightMaterialCost
	,	TotalQuotedSales
	,	SalesForecastEEIBasePart
	,	SalesForecastPeakYearlyVolume
	,	SalesForecastApplication
	)
	
	select distinct
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
	,	h.RowID
	,	coalesce(e.name, '') as SalesPerson
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
	,	case
			when coalesce(pcb.BaseParts, '') <> '' then pcb.BaseParts
			else harness.BaseParts
		end as BaseParts
	,	0.0
	,	case
			when coalesce(pcb.Applications, '') <> '' then pcb.Applications
			else harness.Applications
		end as Applications
	from 
		eeiuser.ST_LightingStudy_Hitlist_2016 hl
		left join eeiuser.QT_LightingStudy_QuoteNumbers qt
			on qt.LightingStudyId = hl.ID
		left join eeiuser.QT_QuoteLog ql
			on ql.QuoteNumber = qt.QuoteNumber	
		left join eeiuser.ST_SalesLeadLog_Header h
			on h.CombinedLightingId = hl.ID
		left join dbo.employee e
			on e.operator_code = h.SalesPersonCode
		left join cte_tail_pcb pcb
			on (pcb.Vehicle like '%' + hl.Nameplate + '%' COLLATE Latin1_General_CS_AS )
			and hl.[LED/Harness] = 'LED'
		left join cte_tail_harness harness
			on (harness.Vehicle like '%' + hl.Nameplate + '%' COLLATE Latin1_General_CS_AS )
			and hl.[LED/Harness] = 'Harness'
	where
		hl.Customer = @Customer
		and hl.[Application] like '%tail%'

end
else begin

	-- STEP 1:  Get Lighting Study Hitlist data, plus Quote Log data tied to LSH records, plus MSF base parts tied to LSH records
	-- Headlamps, LED (PCB)
	with cte_head_pcb (Vehicle, Applications, BaseParts)
	as
	(
		select
			sfd.Vehicle as Vehicle
		,	FX.ToList(distinct sfd.EmpireApplication) as Applications
		,	FX.ToList(distinct sfd.BasePart) as BaseParts
		from 
			@SalesForecastData sfd
		where 
			sfd.EmpireApplication like '%head%'
			and (	(CHARINDEX('LED', sfd.EmpireApplication ) > 0)
				or	(CHARINDEX('LED', sfd.EmpireMarketSegment ) > 0)
				or	(CHARINDEX('LED', sfd.ProductLine ) > 0) 
				or	(CHARINDEX('PCB', sfd.EmpireApplication ) > 0)
				or	(CHARINDEX('PCB', sfd.EmpireMarketSegment ) > 0)
				or	(CHARINDEX('PCB', sfd.ProductLine ) > 0) )
		group by
			sfd.Vehicle
	)
	,
	
	-- Headlamps, Harness
	cte_head_harness (Vehicle, Applications, BaseParts)
	as
	(
		select
			sfd.Vehicle as Vehicle
		,	FX.ToList(distinct sfd.EmpireApplication) as Applications
		,	FX.ToList(distinct sfd.BasePart) as BaseParts
		from 
			@SalesForecastData sfd
		where 
			sfd.EmpireApplication like '%head%'
			and (	(CHARINDEX('LED', sfd.EmpireApplication ) = 0)
				and	(CHARINDEX('LED', sfd.EmpireMarketSegment ) = 0)
				and	(CHARINDEX('LED', sfd.ProductLine ) = 0) 
				and	(CHARINDEX('PCB', sfd.EmpireApplication ) = 0)
				and	(CHARINDEX('PCB', sfd.EmpireMarketSegment ) = 0)
				and	(CHARINDEX('PCB', sfd.ProductLine ) = 0) )
		group by
			sfd.Vehicle
	)

	insert into @tempHitlistQuoteLog
	(
		Customer
	,	Program
	,	EstYearlySales
	,	PeakYearlyVolume
	,	SOPYear
	,	[LED/Harness]
	,	Application
	,	Region
	,	OEM
	,	NamePlate
	,	Component
	,	SOP
	,	EOP
	,	Type
	,	Price
	,	Volume2017
	,	Volume2018
	,	Volume2019
	,	Volume2020
	,	Volume2021
	,	Volume2022
	,	ID
	,	SalesLeadId
	,	SalesPerson
	,	QuoteNumber
	,	EEIPartNumber
	,	EAU
	,	ApplicationName
	,	SalesInitials
	,	QuotePrice
	,	Awarded
	,	QuoteStatus
	,	StraightMaterialCost
	,	TotalQuotedSales
	,	SalesForecastEEIBasePart
	,	SalesForecastPeakYearlyVolume
	,	SalesForecastApplication
	)

	select distinct
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
	,	h.RowID
	,	coalesce(e.name, '') as SalesPerson
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
	,	case
			when coalesce(pcb.BaseParts, '') <> '' then pcb.BaseParts
			else harness.BaseParts
		end as BaseParts
	,	0.0
	,	case
			when coalesce(pcb.Applications, '') <> '' then pcb.Applications
			else harness.Applications
		end as Applications
	from 
		eeiuser.ST_LightingStudy_Hitlist_2016 hl
		left join eeiuser.QT_LightingStudy_QuoteNumbers qt
			on qt.LightingStudyId = hl.ID
		left join eeiuser.QT_QuoteLog ql
			on ql.QuoteNumber = qt.QuoteNumber	
		left join eeiuser.ST_SalesLeadLog_Header h
			on h.CombinedLightingId = hl.ID
		left join dbo.employee e
			on e.operator_code = h.SalesPersonCode
		left join cte_head_pcb pcb
			on (pcb.Vehicle like '%' + hl.Nameplate + '%' COLLATE Latin1_General_CS_AS )
			and hl.[LED/Harness] = 'LED'
		left join cte_head_harness harness
			on (harness.Vehicle like '%' + hl.Nameplate + '%' COLLATE Latin1_General_CS_AS )
			and hl.[LED/Harness] = 'Harness'
	where
		hl.Customer = @Customer
		and hl.SOPYear = @SOPYear
		and hl.[Application] like '%head%'
	;	
		

	

	-- Taillamps, LED (PCB)
	with cte_tail_pcb (Vehicle, Applications, BaseParts)
	as
	(
		select
			sfd.Vehicle as Vehicle
		,	FX.ToList(distinct sfd.EmpireApplication) as Applications
		,	FX.ToList(sfd.BasePart) as BaseParts
		from 
			@SalesForecastData sfd
		where 
			sfd.EmpireApplication like '%tail%'
			and (	(CHARINDEX('LED', sfd.EmpireApplication ) > 0)
				or	(CHARINDEX('LED', sfd.EmpireMarketSegment ) > 0)
				or	(CHARINDEX('LED', sfd.ProductLine ) > 0) 
				or	(CHARINDEX('PCB', sfd.EmpireApplication ) > 0)
				or	(CHARINDEX('PCB', sfd.EmpireMarketSegment ) > 0)
				or	(CHARINDEX('PCB', sfd.ProductLine ) > 0) )
		group by
			sfd.Vehicle
	)
	,
	
	-- Taillamps, Harness
	cte_tail_harness (Vehicle, Applications, BaseParts)
	as
	(
		select
			sfd.Vehicle as Vehicle
		,	FX.ToList(distinct sfd.EmpireApplication) as Applications
		,	FX.ToList(distinct sfd.BasePart) as BaseParts
		from 
			@SalesForecastData sfd
		where 
			sfd.EmpireApplication like '%tail%'
			and (	(CHARINDEX('LED', sfd.EmpireApplication ) = 0)
				and	(CHARINDEX('LED', sfd.EmpireMarketSegment ) = 0)
				and	(CHARINDEX('LED', sfd.ProductLine ) = 0) 
				and	(CHARINDEX('PCB', sfd.EmpireApplication ) = 0)
				and	(CHARINDEX('PCB', sfd.EmpireMarketSegment ) = 0)
				and	(CHARINDEX('PCB', sfd.ProductLine ) = 0) )
		group by
			sfd.Vehicle
	)
	
	insert into @tempHitlistQuoteLog
	(
		Customer
	,	Program
	,	EstYearlySales
	,	PeakYearlyVolume
	,	SOPYear
	,	[LED/Harness]
	,	Application
	,	Region
	,	OEM
	,	NamePlate
	,	Component
	,	SOP
	,	EOP
	,	Type
	,	Price
	,	Volume2017
	,	Volume2018
	,	Volume2019
	,	Volume2020
	,	Volume2021
	,	Volume2022
	,	ID
	,	SalesLeadId
	,	SalesPerson
	,	QuoteNumber
	,	EEIPartNumber
	,	EAU
	,	ApplicationName
	,	SalesInitials
	,	QuotePrice
	,	Awarded
	,	QuoteStatus
	,	StraightMaterialCost
	,	TotalQuotedSales
	,	SalesForecastEEIBasePart
	,	SalesForecastPeakYearlyVolume
	,	SalesForecastApplication
	)
	
	select distinct
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
	,	h.RowID
	,	coalesce(e.name, '') as SalesPerson
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
	,	case
			when coalesce(pcb.BaseParts, '') <> '' then pcb.BaseParts
			else harness.BaseParts
		end as BaseParts
	,	0.0
	,	case
			when coalesce(pcb.Applications, '') <> '' then pcb.Applications
			else harness.Applications
		end as Applications
	from 
		eeiuser.ST_LightingStudy_Hitlist_2016 hl
		left join eeiuser.QT_LightingStudy_QuoteNumbers qt
			on qt.LightingStudyId = hl.ID
		left join eeiuser.QT_QuoteLog ql
			on ql.QuoteNumber = qt.QuoteNumber
		left join eeiuser.ST_SalesLeadLog_Header h
			on h.CombinedLightingId = hl.ID
		left join dbo.employee e
			on e.operator_code = h.SalesPersonCode
		left join cte_tail_pcb pcb
			on (pcb.Vehicle like '%' + hl.Nameplate + '%' COLLATE Latin1_General_CS_AS )
			and hl.[LED/Harness] = 'LED'
		left join cte_tail_harness harness
			on (harness.Vehicle like '%' + hl.Nameplate + '%' COLLATE Latin1_General_CS_AS )
			and hl.[LED/Harness] = 'Harness'
	where
		hl.Customer = @Customer
		and hl.SOPYear = @SOPYear
		and hl.[Application] like '%tail%'

end




-- Search for duplicate IDs caused by multiple MSF vehicle 'like' matches for a single Hitlist Nameplate
declare @DupTable table
(
	ID int
,	Processed int
)

insert 
	@DupTable
select
	ID
,	0
from
	@tempHitlistQuoteLog t
group by
	t.ID
,	t.Program
,	t.SOPYear
,	t.[Application]
,	t.EstYearlySales
having
	count(t.ID) > 1
order by
	t.ID
	
declare
	@MinId int
,	@BaseParts varchar(500)
,	@MsfApplications varchar(1000)
,	@BasePartForDeletion varchar(50)
	
if ((select count(1) from @DupTable) > 0) begin

	select @MinId = min(d.ID) from @DupTable d where d.Processed = 0
	
	
	-- Create lists of all base parts and applications with this ID
	select
		@MsfApplications = FX.ToList(distinct t.SalesForecastApplication)
	,	@BaseParts = FX.ToList(distinct t.SalesForecastEEIBasePart)
	from
		@tempHitlistQuoteLog t
	where
		t.ID = @MinId
	
	-- Delete all rows but one with this ID
	select
		@BasePartForDeletion = min(t.SalesForecastEEIBasePart)
	from
		@tempHitlistQuoteLog t
	where
		t.ID = @MinId
		
	delete from
		@tempHitlistQuoteLog
	where
		ID = @MinId
		and SalesForecastEEIBasePart <> @BasePartForDeletion
	
	-- Update the single row that remains with the base parts and applications from all the original rows
	update
		@tempHitlistQuoteLog
	set
		SalesForecastEEIBasePart = @BaseParts
	,	SalesForecastApplication = @MsfApplications
	where
		ID = @MinId
		
		
	update
		@DupTable
	set
		Processed = 1
	where
		ID = @MinId
		
end







/*
else begin

	-- STEP 1:  Get Lighting Study Hitlist data, plus Quote Log data tied to LSH records, plus MSF base parts tied to LSH records
	with cte_bp (Vehicle, BaseParts)
	as
	(
		select
			sf.vehicle as Vehicle
		,	FX.ToList(sf.base_part) as BaseParts
		from 
			eeiuser.acctg_csm_vw_select_sales_forecast sf
		where 
			sf.parent_customer in (	
				select
					sf.SalesForecastParentCustomer
				from 
					EEIUser.ST_SalesForecastParentCustomers sf
				where
					sf.LightingStudyCustomer = @Customer
					and sf.SalesForecastParentCustomer is not null )
		group by
			sf.vehicle
	)
	
	insert into @tempHitlistQuoteLog
	(
		Customer
	,	Program
	,	EstYearlySales
	,	PeakYearlyVolume
	,	SOPYear
	,	[LED/Harness]
	,	Application
	,	Region
	,	OEM
	,	NamePlate
	,	Component
	,	SOP
	,	EOP
	,	Type
	,	Price
	,	Volume2017
	,	Volume2018
	,	Volume2019
	,	Volume2020
	,	Volume2021
	,	Volume2022
	,	ID
	,	QuoteNumber
	,	EEIPartNumber
	,	EAU
	,	ApplicationName
	,	SalesInitials
	,	QuotePrice
	,	Awarded
	,	QuoteStatus
	,	StraightMaterialCost
	,	TotalQuotedSales
	,	SalesForecastEEIBasePart
	,	SalesForecastPeakYearlyVolume
	)

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
	/*
	,	(	select
				FX.ToList(sf.base_part) 
			from 
				eeiuser.acctg_csm_vw_select_sales_forecast sf
			where 
				sf.parent_customer in (	
					select
						sf.SalesForecastParentCustomer
					from 
						EEIUser.ST_SalesForecastParentCustomers sf
					where
						sf.LightingStudyCustomer = hl.Customer
						and sf.SalesForecastParentCustomer is not null )
				and sf.vehicle like '%' + hl.Nameplate  +'%' ) as EEIBasePart
	*/
	,	bp.BaseParts
	,	0.0
	from 
		eeiuser.ST_LightingStudy_Hitlist_2016 hl
		left join eeiuser.QT_LightingStudy_QuoteNumbers qt
			on qt.LightingStudyId = hl.ID
		left join eeiuser.QT_QuoteLog ql
			on ql.QuoteNumber = qt.QuoteNumber	
		left join cte_bp bp
			on bp.Vehicle like '%' + hl.Nameplate  +'%' 		
	where
		hl.Customer = @Customer
		and hl.SOPYear = @SOPYear
	order by
		hl.ID asc

end
*/



-- For each Hitlist ID, get the highest volumes across the sales forecast years for each base part
declare
	@tempHitlistPeaksPerBasePart table
(	ID int
,	BasePart varchar(50)
,	SalesForecastPeakYearlyVolume decimal(20,6)
)

insert
	@tempHitlistPeaksPerBasePart
select
	thql.ID
,	pl.BasePart
,	max(v.Volume)
from
	@tempHitlistQuoteLog thql
	cross apply
		(	select
	 		    fsstr.ID
	 		,   BasePart = ltrim(rtrim(fsstr.Value))
		 	from
		 		dbo.fn_SplitStringToRows(thql.SalesForecastEEIBasePart, ',') fsstr
		) pL
	cross apply
		(	select
		 		Volume = max(sfd.Cal_16_Sales)
		 	from
		 		@SalesForecastData sfd
		 	where
		 		sfd.BasePart = pL.BasePart
		 	union all
		 	select
		 		Volume = max(sfd.Cal_17_Sales)
		 	from
		 		@SalesForecastData sfd
		 	where
		 		sfd.BasePart = pL.BasePart
		 	union all
		 	select
		 		Volume = max(sfd.Cal_18_Sales)
		 	from
		 		@SalesForecastData sfd
		 	where
		 		sfd.BasePart = pL.BasePart
		 	union all
		 	select
		 		Volume = max(sfd.Cal_19_Sales)
		 	from
		 		@SalesForecastData sfd
		 	where
		 		sfd.BasePart = pL.BasePart
		 	union all
		 	select
		 		Volume = max(sfd.Cal_20_Sales)
		 	from
		 		@SalesForecastData sfd
		 	where
		 		sfd.BasePart = pL.BasePart
		 	union all
		 	select
		 		Volume = max(sfd.Cal_21_Sales)
		 	from
		 		@SalesForecastData sfd
		 	where
		 		sfd.BasePart = pL.BasePart
		 	union all
		 	select
		 		Volume = max(sfd.Cal_22_Sales)
		 	from
		 		@SalesForecastData sfd
		 	where
		 		sfd.BasePart = pL.BasePart
		 ) v
where
	thql.SalesForecastEEIBasePart is not null
group by
	thql.ID
,	pl.BasePart
order by
	thql.ID
,	pl.BasePart


-- Sum the volumes of each base part in the previous temp table 
declare
	@tempHitlistPeaks table
(	ID int
,	SalesForecastPeakYearlyVolume decimal(20,6)
)

insert
	@tempHitlistPeaks
select
	ID = t.ID
,	SalesForecastPeakYearlyVolume = sum(t.SalesForecastPeakYearlyVolume)
from
	@tempHitlistPeaksPerBasePart t
group by
	t.ID
order by
	t.ID

/*
declare
	@tempHitlistPeaks table
(	ID int
,	SalesForecastPeakYearlyVolume decimal(20,6)
)

insert
	@tempHitlistPeaks
select
	thql.ID
,	max(v.Volume)
from
	@tempHitlistQuoteLog thql
	cross apply
		(	select
	 		    fsstr.ID
	 		,   BasePart = ltrim(rtrim(fsstr.Value))
		 	from
		 		dbo.fn_SplitStringToRows(thql.SalesForecastEEIBasePart, ',') fsstr
		) pL
	cross apply
		(	select
		 		Volume = sfd.Cal_16_Sales
		 	from
		 		@SalesForecastData sfd
		 	where
		 		sfd.BasePart = pL.BasePart
		 	union all
		 	select
		 		Volume = sfd.Cal_17_Sales
		 	from
		 		@SalesForecastData sfd
		 	where
		 		sfd.BasePart = pL.BasePart
		 	union all
		 	select
		 		Volume = sfd.Cal_18_Sales
		 	from
		 		@SalesForecastData sfd
		 	where
		 		sfd.BasePart = pL.BasePart
		 	union all
		 	select
		 		Volume = sfd.Cal_19_Sales
		 	from
		 		@SalesForecastData sfd
		 	where
		 		sfd.BasePart = pL.BasePart
		 	union all
		 	select
		 		Volume = sfd.Cal_20_Sales
		 	from
		 		@SalesForecastData sfd
		 	where
		 		sfd.BasePart = pL.BasePart
		 	union all
		 	select
		 		Volume = sfd.Cal_21_Sales
		 	from
		 		@SalesForecastData sfd
		 	where
		 		sfd.BasePart = pL.BasePart
		 	union all
		 	select
		 		Volume = sfd.Cal_22_Sales
		 	from
		 		@SalesForecastData sfd
		 	where
		 		sfd.BasePart = pL.BasePart
		 ) v
where
	thql.SalesForecastEEIBasePart is not null
group by
	thql.ID
order by
	thql.ID
*/


update
	thql
set
	SalesForecastPeakYearlyVolume = thp.SalesForecastPeakYearlyVolume
from
	@tempHitlistQuoteLog thql
	join @tempHitlistPeaks thp
		on thp.ID = thql.ID


-- STEP 2:  Update the temp table with peak yearly volumes of base part(s)
--declare 
--	@MaxId int
--,	@CurrentId int
--,	@LastId int

--select 
--	@CurrentId = min(t.ID)
--,	@MaxId = max(t.ID) 
--from 
--	@tempHitlistQuoteLog t
--where
--	t.SalesForecastEEIBasePart is not null
	
--declare
--	@BaseParts varchar(100)
--,	@Part varchar(50) = null

--declare
--	@TotalVolume2016 decimal(20,6)
--,	@TotalVolume2017 decimal(20,6)
--,	@TotalVolume2018 decimal(20,6)
--,	@TotalVolume2019 decimal(20,6)
--,	@TotalVolume2020 decimal(20,6)
--,	@TotalVolume2021 decimal(20,6)
--,	@TotalVolume2022 decimal(20,6)

--declare @tempVolumes table
--(
--	TotalYearlyVolume decimal(20,6)
--)
--declare
--	@PeakYearlyVolume decimal(20,6)


--while (@CurrentId <= @MaxId) begin

--	select
--		@BaseParts = t.SalesForecastEEIBasePart
--	from
--		@tempHitlistQuoteLog t
--	where
--		t.ID = @CurrentId
		

--	while (len(@BaseParts) > 0) begin
	    
--		if (patindex('%,%', @BaseParts) > 0) begin
	        
--			select @Part = substring(@BaseParts, 0, patindex('%,%', @BaseParts))
			
			
--			-- Sum rows / volumes for this part.  (More than one row might be returned from the view.  Example: same part, two different assembly plants.)
--			select
--				@TotalVolume2016 = sum(isnull(sf.Cal_16_Sales, 0.0))
--			,	@TotalVolume2017 = sum(isnull(sf.Cal_17_Sales, 0.0))
--			,	@TotalVolume2018 = sum(isnull(sf.Cal_18_Sales, 0.0))
--			,	@TotalVolume2019 = sum(isnull(sf.Cal_19_Sales, 0.0))
--			,	@TotalVolume2020 = sum(isnull(sf.Cal_20_Sales, 0.0))
--			,	@TotalVolume2021 = sum(isnull(sf.Cal_21_Sales, 0.0))
--			,	@TotalVolume2022 = sum(isnull(sf.Cal_22_Sales, 0.0))
--			from 
--				eeiuser.acctg_csm_vw_select_sales_forecast sf 
--			where 
--				sf.base_part = @Part
				
--			insert into @tempVolumes (TotalYearlyVolume)
--			select @TotalVolume2016
--			insert into @tempVolumes (TotalYearlyVolume)
--			select @TotalVolume2017
--			insert into @tempVolumes (TotalYearlyVolume)
--			select @TotalVolume2018
--			insert into @tempVolumes (TotalYearlyVolume)
--			select @TotalVolume2019
--			insert into @tempVolumes (TotalYearlyVolume)
--			select @TotalVolume2020
--			insert into @tempVolumes (TotalYearlyVolume)
--			select @TotalVolume2021
--			insert into @tempVolumes (TotalYearlyVolume)
--			select @TotalVolume2022
			
			
--			select @BaseParts = substring(@BaseParts, len(@Part + ',') + 1, len(@BaseParts))
	    
--		end
--		else begin

--			select @Part = @BaseParts
	        

--			-- Sum rows / volumes for this part.  (More than one row might be returned from the view.  Example: same part, two different assembly plants.)
--			select
--				@TotalVolume2016 = sum(isnull(sf.Cal_16_Sales, 0.0))
--			,	@TotalVolume2017 = sum(isnull(sf.Cal_17_Sales, 0.0))
--			,	@TotalVolume2018 = sum(isnull(sf.Cal_18_Sales, 0.0))
--			,	@TotalVolume2019 = sum(isnull(sf.Cal_19_Sales, 0.0))
--			,	@TotalVolume2020 = sum(isnull(sf.Cal_20_Sales, 0.0))
--			,	@TotalVolume2021 = sum(isnull(sf.Cal_21_Sales, 0.0))
--			,	@TotalVolume2022 = sum(isnull(sf.Cal_22_Sales, 0.0))
--			from 
--				eeiuser.acctg_csm_vw_select_sales_forecast sf 
--			where 
--				sf.base_part = @Part
				
--			insert into @tempVolumes (TotalYearlyVolume)
--			select @TotalVolume2016
--			insert into @tempVolumes (TotalYearlyVolume)
--			select @TotalVolume2017
--			insert into @tempVolumes (TotalYearlyVolume)
--			select @TotalVolume2018
--			insert into @tempVolumes (TotalYearlyVolume)
--			select @TotalVolume2019
--			insert into @tempVolumes (TotalYearlyVolume)
--			select @TotalVolume2020
--			insert into @tempVolumes (TotalYearlyVolume)
--			select @TotalVolume2021
--			insert into @tempVolumes (TotalYearlyVolume)
--			select @TotalVolume2022

	        
--			select @BaseParts = null
		
--		end	
--	end


--	-- Get the max volume of all parts in the base part list
--	select 
--		@PeakYearlyVolume = max(v.TotalYearlyVolume)
--	from
--		@tempVolumes v
	
--	-- Update the temp table	
--	update
--		@tempHitlistQuoteLog
--	set
--		SalesForecastPeakYearlyVolume = @PeakYearlyVolume
--	where
--		ID = @CurrentId
	
--	-- Clear out volumes to prepare for the next base part(s)	
--	delete from
--		@tempVolumes


--	-- Set variable for next loop
--	select
--		@CurrentId = min(ID)
--	from
--		@tempHitlistQuoteLog
--	where
--		ID > @CurrentId
	
--end


-- Return
select
	Customer
,	Program
,	EstYearlySales
,	PeakYearlyVolume
,	SOPYear
,	[LED/Harness]
,	Application
,	Region
,	OEM
,	NamePlate
,	Component
,	SOP
,	EOP
,	Type
,	Price
,	Volume2017
,	Volume2018
,	Volume2019
,	Volume2020
,	Volume2021
,	Volume2022
,	ID
,	SalesLeadId
,	SalesPerson
,	QuoteNumber
,	EEIPartNumber
,	EAU
,	ApplicationName
,	SalesInitials
,	QuotePrice
,	Awarded
,	QuoteStatus
,	StraightMaterialCost
,	TotalQuotedSales
,	SalesForecastEEIBasePart
,	SalesForecastPeakYearlyVolume
,	SalesForecastApplication
from 
	@tempHitlistQuoteLog
--- </Body>
GO
