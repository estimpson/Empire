SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_ST_Report_Hitlist_MSF_New2]
	@Customer varchar(50) = null
,	@Region varchar(50) = null
,	@SOPYear int = null
as
set nocount on
set ansi_warnings off

--- <Body>
-- Get Master Sales Forecast data
declare
	@SalesForecastData table
(	Vehicle varchar(511)
,	BasePart varchar(30)
,	SOPYear char(4)
,	ParentCustomer varchar(50)
,	EmpireApplication varchar(200)
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
	isnull(vehicle, '') as vehicle
,	base_part
,	isnull(convert(char(4), year(sop)), '') as sop
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
			


-- Combine base parts (for the same vehicle) produced at different assembly plants
declare @SalesForecastDataSummarizedA table
(
	Vehicle varchar(50)
,	BasePart varchar(50)
,	SopYear varchar(5)
,	EmpireApplication varchar(200)
,	EmpireMarketSegment varchar(200)
,	ProductLine varchar(25)
,	TotalSales2016 decimal(20,2)
,	TotalSales2017 decimal(20,2)
,	TotalSales2018 decimal(20,2)
,	TotalSales2019 decimal(20,2)
,	TotalSales2020 decimal(20,2)
,	TotalSales2021 decimal(20,2)
,	TotalSales2022 decimal(20,2)
,	primary key (Vehicle, BasePart)
)

insert 
	@SalesForecastDataSummarizedA
select
	sfd.Vehicle
,	sfd.BasePart
,	min(sfd.SOPYear) as SOPYear
,	min(sfd.EmpireApplication)
,	min(sfd.EmpireMarketSegment)
,	min(sfd.ProductLine)
,	sum(sfd.Cal_16_Sales) as TotalSales2016
,	sum(sfd.Cal_17_Sales) as TotalSales2017
,	sum(sfd.Cal_18_Sales) as TotalSales2018
,	sum(sfd.Cal_19_Sales) as TotalSales2019
,	sum(sfd.Cal_20_Sales) as TotalSales2020
,	sum(sfd.Cal_21_Sales) as TotalSales2021
,	sum(sfd.Cal_22_Sales) as TotalSales2022
from
	@SalesForecastData sfd
group by
	sfd.Vehicle
,	sfd.BasePart
--,	sfd.EmpireApplication
--,	sfd.EmpireMarketSegment
--,	sfd.ProductLine
order by
	sfd.Vehicle
,	sfd.BasePart




-- Get the max sales number across all years (peak yearly sales) per base part
declare @SalesForecastDataSummarizedB table
(
	Vehicle varchar(50)
,	BasePart varchar(50)
,	SopYear varchar(5)
,	EmpireApplication varchar(200)
,	EmpireMarketSegment varchar(200)
,	ProductLine varchar(25)
,	PeakYearlySalesPerBasePart decimal(20,2)
,	primary key (Vehicle, BasePart)
)

insert
	@SalesForecastDataSummarizedB
select
	sfdsa.Vehicle
,	sfdsa.BasePart
,	min(sfdsa.SopYear)
,	min(sfdsa.EmpireApplication)
,	min(sfdsa.EmpireMarketSegment)
,	min(sfdsa.ProductLine)
,	max(ys.YearlySales) as PeakYearlySales
from
	@SalesForecastDataSummarizedA sfdsa
	cross apply
		(
			select
				max(sfdsa2.TotalSales2016) as YearlySales
			from
				@SalesForecastDataSummarizedA sfdsa2
			where
				sfdsa2.BasePart = sfdsa.BasePart
			union all
			select
				max(sfdsa2.TotalSales2017) as YearlySales
			from
				@SalesForecastDataSummarizedA sfdsa2
			where
				sfdsa2.BasePart = sfdsa.BasePart
			union all
			select
				max(sfdsa2.TotalSales2018) as YearlySales
			from
				@SalesForecastDataSummarizedA sfdsa2
			where
				sfdsa2.BasePart = sfdsa.BasePart
			union all
			select
				max(sfdsa2.TotalSales2019) as YearlySales
			from
				@SalesForecastDataSummarizedA sfdsa2
			where
				sfdsa2.BasePart = sfdsa.BasePart
			union all
			select
				max(sfdsa2.TotalSales2020) as YearlySales
			from
				@SalesForecastDataSummarizedA sfdsa2
			where
				sfdsa2.BasePart = sfdsa.BasePart
			union all
			select
				max(sfdsa2.TotalSales2021) as YearlySales
			from
				@SalesForecastDataSummarizedA sfdsa2
			where
				sfdsa2.BasePart = sfdsa.BasePart
			union all
			select
				max(sfdsa2.TotalSales2022) as YearlySales
			from
				@SalesForecastDataSummarizedA sfdsa2
			where
				sfdsa2.BasePart = sfdsa.BasePart	
		) ys
group by
	sfdsa.Vehicle
,	sfdsa.BasePart
--,	sfdsa.SopYear
--,	sfdsa.EmpireApplication
--,	sfdsa.EmpireMarketSegment
--,	sfdsa.ProductLine
order by
	sfdsa.Vehicle
,	sfdsa.BasePart





-- Get data for Quote Log columns
declare @QuoteLogData table
(
	LightingStudyId int
,	QuoteNumber varchar(50)
,	EEIPartNumber varchar(50)
,	EAU varchar(100)
,	ApplicationName varchar(255)
,	SalesInitials varchar(10)
,	QuotePrice varchar(50)
,	Awarded varchar(3)
,	QuoteStatus varchar(10)
,	StraightMaterialCost varchar(50)
,	TotalQuotedSales varchar(100)
,	RowID int not null IDENTITY(1, 1)
,	primary key (QuoteNumber, RowID)
)
insert
	@QuoteLogData
select
	qt.LightingStudyId
,	qt.QuoteNumber
,	ql.EEIPartNumber
,	convert(varchar, isnull(ql.EAU, 0)) as EAU
,	ql.ApplicationName
,	ql.SalesInitials
,	convert(varchar, cast(isnull(ql.QuotePrice, 0) as money), 1) as QuotePrice
,	ql.Awarded
,	ql.QuoteStatus
,	convert(varchar, cast(isnull(ql.StraightMaterialCost, 0) as money), 1) as StraightMaterialCost
,	left(convert(varchar, cast(isnull(ql.TotalQuotedSales, 0) as money), 1), charindex('.', convert(varchar, cast(isnull(ql.TotalQuotedSales, 0) as money), 1)) -1) as TotalQuotedSales
from
	eeiuser.QT_LightingStudy_QuoteNumbers qt
	join eeiuser.QT_QuoteLog ql
		on ql.QuoteNumber = qt.QuoteNumber	
where
	qt.LightingStudyId is not null
order by
	qt.LightingStudyId
,	ql.EEIPartNumber






-- Pull Lighting Study data and join both the MSF and Quote Log data to it
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
,	QuoteNumber varchar(100)
,	EEIPartNumber varchar(250)
,	EAU varchar(100)
,	ApplicationName varchar(1000)
,	SalesInitials varchar(50)
,	QuotePrice varchar(100)
,	Awarded varchar(50)
,	QuoteStatus varchar(100)
,	StraightMaterialCost varchar(100)
,	TotalQuotedSales varchar(100)
,	SalesForecastVehicle varchar(50)
,	SalesForecastEEIBasePart varchar(500) null
,	SalesForecastTotalPeakYearlySales decimal(20,6) null
,	SalesForecastApplication varchar(1000)
,	SalesForecastSopYear varchar(100)
,	RowID int identity
,	primary key(ID, RowID)
)
;




-- STEP 1:  Get Lighting Study Hitlist data, plus Quote Log data tied to LSH records, plus MSF base parts tied to LSH records
with cte_ql (LightingStudyId, QuoteNumber, EEIPartNumber, EAU, ApplicationName, SalesInitials, QuotePrice, Awarded, QuoteStatus, StraightMaterialCost, TotalQuotedSales)
as
(
	select
		qld.LightingStudyId as LightingStudyId
	,	FX.ToList(qld.QuoteNumber) as QuoteNumber
	,	FX.ToList(qld.EEIPartNumber) as EEIPartNumber
	,	FX.ToList(qld.EAU) as EAU
	,	FX.ToList(qld.ApplicationName) as ApplicationName
	,	FX.ToList(qld.SalesInitials) as SalesInitials
	,	FX.ToList(qld.QuotePrice) as QuotePrice
	,	FX.ToList(qld.Awarded) as Awarded
	,	FX.ToList(qld.QuoteStatus) as QuoteStatus
	,	FX.ToList(qld.StraightMaterialCost) as StraightMaterialCost
	,	FX.ToList(qld.TotalQuotedSales) as TotalQuotedSales
	from
		@QuoteLogData qld
	group by
		qld.LightingStudyId
)
,

-- Headlamps, LED (PCB)
cte_head_pcb (Vehicle, Applications, BaseParts, SopYears, TotalPeakYearlySales)
as
(
	select
		sfdsb.Vehicle as Vehicle
	,	FX.ToList(sfdsb.EmpireApplication) as Applications
	,	FX.ToList(sfdsb.BasePart) as BaseParts
	,	FX.ToList(sfdsb.SOPYear) as SopYears
	,	sum(sfdsb.PeakYearlySalesPerBasePart) as TotalPeakYearlySales
	from
		@SalesForecastDataSummarizedB sfdsb
	where 
		sfdsb.EmpireApplication like '%head%'
		and (	(CHARINDEX('LED', sfdsb.EmpireApplication ) > 0)
			or	(CHARINDEX('LED', sfdsb.EmpireMarketSegment ) > 0)
			or	(CHARINDEX('LED', sfdsb.ProductLine ) > 0) 
			or	(CHARINDEX('PCB', sfdsb.EmpireApplication ) > 0)
			or	(CHARINDEX('PCB', sfdsb.EmpireMarketSegment ) > 0)
			or	(CHARINDEX('PCB', sfdsb.ProductLine ) > 0) )
	group by 
		sfdsb.Vehicle
)
,

-- Headlamps, Harness
cte_head_harness (Vehicle, Applications, BaseParts, SopYears, TotalPeakYearlySales)
as
(
	select
		sfdsb.Vehicle as Vehicle
	,	FX.ToList(sfdsb.EmpireApplication) as Applications
	,	FX.ToList(sfdsb.BasePart) as BaseParts
	,	FX.ToList(sfdsb.SOPYear) as SopYears
	,	sum(sfdsb.PeakYearlySalesPerBasePart) as TotalPeakYearlySales
	from
		@SalesForecastDataSummarizedB sfdsb
	where 
		sfdsb.EmpireApplication like '%head%'
		and (	(CHARINDEX('LED', coalesce(sfdsb.EmpireApplication,'')) = 0)
			and	(CHARINDEX('LED', coalesce(sfdsb.EmpireMarketSegment,'')) = 0)
			and	(CHARINDEX('LED', coalesce(sfdsb.ProductLine,'')) = 0) 
			and	(CHARINDEX('PCB', coalesce(sfdsb.EmpireApplication,'')) = 0)
			and	(CHARINDEX('PCB', coalesce(sfdsb.EmpireMarketSegment,'')) = 0)
			and	(CHARINDEX('PCB', coalesce(sfdsb.ProductLine,'')) = 0) )
	group by
		sfdsb.Vehicle
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
,	SalesForecastVehicle
,	SalesForecastEEIBasePart
,	SalesForecastTotalPeakYearlySales
,	SalesForecastApplication
,	SalesForecastSopYear
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
,	ql.QuoteNumber
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
		when coalesce(pcb.Vehicle, '') <> '' then pcb.Vehicle
		else harness.Vehicle
	end as Vehicle
,	case
		when coalesce(pcb.BaseParts, '') <> '' then pcb.BaseParts
		else harness.BaseParts
	end as BaseParts
,	case
		when coalesce(pcb.BaseParts, '') <> '' then pcb.TotalPeakYearlySales
		else harness.TotalPeakYearlySales
	end as TotalPeakYearlySales
,	case
		when coalesce(pcb.Applications, '') <> '' then pcb.Applications
		else harness.Applications
	end as Applications
,	case
		when coalesce(pcb.SopYears, '') <> '' then pcb.SopYears
		else harness.SopYears
	end as SopYears
from 
	eeiuser.ST_LightingStudy_Hitlist_2016 hl	
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
	left join cte_ql ql
		on ql.LightingStudyId = hl.ID
where
	hl.Customer = @Customer
	and hl.Region = @Region
	and hl.SOPYear = coalesce(@SOPYear, hl.SOPYear)
	and hl.[Application] like '%head%'
;	
	



with cte_ql (LightingStudyId, QuoteNumber, EEIPartNumber, EAU, ApplicationName, SalesInitials, QuotePrice, Awarded, QuoteStatus, StraightMaterialCost, TotalQuotedSales)
as
(
	select
		qld.LightingStudyId as LightingStudyId
	,	FX.ToList(qld.QuoteNumber) as QuoteNumber
	,	FX.ToList(qld.EEIPartNumber) as EEIPartNumber
	,	FX.ToList(qld.EAU) as EAU
	,	FX.ToList(qld.ApplicationName) as ApplicationName
	,	FX.ToList(qld.SalesInitials) as SalesInitials
	,	FX.ToList(qld.QuotePrice) as QuotePrice
	,	FX.ToList(qld.Awarded) as Awarded
	,	FX.ToList(qld.QuoteStatus) as QuoteStatus
	,	FX.ToList(qld.StraightMaterialCost) as StraightMaterialCost
	,	FX.ToList(qld.TotalQuotedSales) as TotalQuotedSales
	from
		@QuoteLogData qld
	group by
		qld.LightingStudyId
)
,

-- Taillamps, LED (PCB)
cte_tail_pcb (Vehicle, Applications, BaseParts, SopYears, TotalPeakYearlySales)
as
(
	select
		sfdsb.Vehicle as Vehicle
	,	FX.ToList(sfdsb.EmpireApplication) as Applications
	,	FX.ToList(sfdsb.BasePart) as BaseParts
	,	FX.ToList(sfdsb.SOPYear) as SopYears
	,	sum(sfdsb.PeakYearlySalesPerBasePart) as TotalPeakYearlySales
	from
		@SalesForecastDataSummarizedB sfdsb
	where 
		sfdsb.EmpireApplication like '%tail%'
		and (	(CHARINDEX('LED', sfdsb.EmpireApplication ) > 0)
			or	(CHARINDEX('LED', sfdsb.EmpireMarketSegment ) > 0)
			or	(CHARINDEX('LED', sfdsb.ProductLine ) > 0) 
			or	(CHARINDEX('PCB', sfdsb.EmpireApplication ) > 0)
			or	(CHARINDEX('PCB', sfdsb.EmpireMarketSegment ) > 0)
			or	(CHARINDEX('PCB', sfdsb.ProductLine ) > 0) )
	group by
		sfdsb.Vehicle
)
,

-- Taillamps, Harness
cte_tail_harness (Vehicle, Applications, BaseParts, SopYears, TotalPeakYearlySales)
as
(
	select
		sfdsb.Vehicle as Vehicle
	,	FX.ToList(sfdsb.EmpireApplication) as Applications
	,	FX.ToList(sfdsb.BasePart) as BaseParts
	,	FX.ToList(sfdsb.SOPYear) as SopYears
	,	sum(sfdsb.PeakYearlySalesPerBasePart) as TotalPeakYearlySales
	from
		@SalesForecastDataSummarizedB sfdsb
	where 
		sfdsb.EmpireApplication like '%tail%'
		and (	(CHARINDEX('LED', coalesce(sfdsb.EmpireApplication,'')) = 0)
			and	(CHARINDEX('LED', coalesce(sfdsb.EmpireMarketSegment,'')) = 0)
			and	(CHARINDEX('LED', coalesce(sfdsb.ProductLine,'')) = 0) 
			and	(CHARINDEX('PCB', coalesce(sfdsb.EmpireApplication,'')) = 0)
			and	(CHARINDEX('PCB', coalesce(sfdsb.EmpireMarketSegment,'')) = 0)
			and	(CHARINDEX('PCB', coalesce(sfdsb.ProductLine,'')) = 0) )
	group by
		sfdsb.Vehicle
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
,	SalesForecastVehicle
,	SalesForecastEEIBasePart
,	SalesForecastTotalPeakYearlySales
,	SalesForecastApplication
,	SalesForecastSopYear
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
,	ql.QuoteNumber
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
		when coalesce(pcb.Vehicle, '') <> '' then pcb.Vehicle
		else harness.Vehicle
	end as Vehicle
,	case
		when coalesce(pcb.BaseParts, '') <> '' then pcb.BaseParts
		else harness.BaseParts
	end as BaseParts
,	case
		when coalesce(pcb.BaseParts, '') <> '' then pcb.TotalPeakYearlySales
		else harness.TotalPeakYearlySales
	end as TotalPeakYearlySales
,	case
		when coalesce(pcb.Applications, '') <> '' then pcb.Applications
		else harness.Applications
	end as Applications
,	case
		when coalesce(pcb.SopYears, '') <> '' then pcb.SopYears
		else harness.SopYears
	end as SopYears
from 
	eeiuser.ST_LightingStudy_Hitlist_2016 hl
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
	left join cte_ql ql
		on ql.LightingStudyId = hl.ID
where
	hl.Customer = @Customer
	and hl.Region = @Region
	and hl.SOPYear = coalesce(@SOPYear, hl.SOPYear)
	and hl.[Application] like '%tail%'





/*
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
,	@SopYears char(4)
,	@MsfApplications varchar(1000)
,	@BasePartForDeletion varchar(50)
	
if ((select count(1) from @DupTable) > 0) begin

	select @MinId = min(d.ID) from @DupTable d where d.Processed = 0
	
	
	-- Create lists of all base parts, SOP years and applications with this ID
	select
		@MsfApplications = FX.ToList(distinct t.SalesForecastApplication)
	,	@BaseParts = FX.ToList(distinct t.SalesForecastEEIBasePart)
	,	@SopYears = FX.ToList(distinct t.SalesForecastSopYear)
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
	,	SalesForecastSopYear = @SopYears
	where
		ID = @MinId
		
		
	update
		@DupTable
	set
		Processed = 1
	where
		ID = @MinId
		
end
*/




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
,	SalesForecastVehicle
,	SalesForecastEEIBasePart
,	SalesForecastTotalPeakYearlySales
,	SalesForecastApplication
,	SalesForecastSopYear
from 
	@tempHitlistQuoteLog t
order by
	t.Program
,	t.[Application]
,	t.[LED/Harness]
,	t.NamePlate
,	t.EstYearlySales
--- </Body>
GO
