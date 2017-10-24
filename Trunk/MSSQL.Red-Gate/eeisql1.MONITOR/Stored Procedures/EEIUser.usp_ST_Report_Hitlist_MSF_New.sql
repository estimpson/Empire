SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[usp_ST_Report_Hitlist_MSF_New]
	@Customer varchar(50) = null
,	@Region varchar(50) = null
,	@SOPYear int = null
as
set nocount on
set ansi_warnings off


--- <Body>
-- Get data for Master Sales Forecast columns
declare @SalesForecastData table
(	
	Vehicle varchar(511)
,	BasePart varchar(30)
,	SOPYear varchar(5)
--,	ParentCustomer varchar(50)
,	EmpireApplication varchar(500)
--,	EmpireMarketSegment varchar(200)
--,	ProductLine varchar(25)
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
,	convert(varchar(5), year(isnull(sop, ''))) as sop
--,	parent_customer
,	empire_application
--,	empire_market_segment
--,	product_line
,	Cal_16_Sales
,	Cal_17_Sales
,	Cal_18_Sales
,	Cal_19_Sales
,	Cal_20_Sales
,	Cal_21_Sales
,	Cal_22_Sales
from
	EEIUser.acctg_csm_vw_select_sales_forecast ssf
where
	parent_customer in (	
		select
			sf.SalesForecastParentCustomer
		from 
			EEIUser.ST_SalesForecastParentCustomers sf
		where
			sf.LightingStudyCustomer = @Customer
			and sf.SalesForecastParentCustomer is not null )
order by
	ssf.vehicle
,	ssf.base_part		

	
-- Create a separate, condensed data set
declare @SalesForecastDataGrouped table
(
	Vehicle varchar(50)
,	Applications varchar(1000)
,	BaseParts varchar(500)
,	SopYears varchar(100)
)
insert
	@SalesForecastDataGrouped
select
	sfd.Vehicle as Vehicle
,	FX.ToList(distinct sfd.EmpireApplication) as Applications
,	FX.ToList(distinct sfd.BasePart) as BaseParts
,	FX.ToList(distinct sfd.SOPYear) as SopYears
from 
	@SalesForecastData sfd
group by
	sfd.Vehicle
,	sfd.BasePart
,	sfd.EmpireApplication
,	sfd.SOPYear





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
,	Awarded char(3)
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
,	isnull(ql.Awarded, '') as Awarded
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


					
					
/*					
declare @temp table
(
	LightingStudyId int
,	EAU varchar(100)
,	QuotePrice varchar(50)
,	StraightMaterialCost varchar(50)
,	TotalQuotedSales varchar(100)
)	

declare
	@CurrentId int
,	@PartNumber varchar(50)	
,	@EAU varchar(100)
,	@QuotePrice varchar(50)
,	@StraightMaterialCost varchar(50)
,	@TotalQuotedSales varchar(100)
		
while ( (select count(1) from @QuoteLogData qld where qld.Processed = 0) > 0 ) begin	
	
	select
		@CurrentId = min(qld.LightingStudyId)
	from
		@QuoteLogData qld
	where
		qld.Processed = 0
		
	select
		@PartNumber = min(qld.EEIPartNumber)
	from
		@QuoteLogData qld
	where
		qld.LightingStudyId = @CurrentId
		and qld.Processed = 0
	
	
	if not exists (
			select
				1
			from
				@temp
			where
				LightingStudyId = @CurrentId ) begin
	
		insert
			@temp
		select
			qld.LightingStudyId
		,	qld.EAU
		,	qld.QuotePrice
		,	qld.StraightMaterialCost
		,	qld.TotalQuotedSales	
		from
			@QuoteLogData qld
		where
			qld.LightingStudyId = @CurrentId
			and qld.EEIPartNumber = @PartNumber
			
	end
	else begin

		select
			@EAU = t.EAU
		,	@QuotePrice = t.QuotePrice
		,	@StraightMaterialCost = t.StraightMaterialCost
		,	@TotalQuotedSales = t.TotalQuotedSales
		from
			@temp t
		where
			t.LightingStudyId = @CurrentId
			
		select
			@EAU = @EAU + ', ' + qld.EAU
		,	@QuotePrice = @QuotePrice + ', ' + qld.QuotePrice
		,	@StraightMaterialCost = @StraightMaterialCost + ', ' + qld.StraightMaterialCost
		,	@TotalQuotedSales = @TotalQuotedSales + ', ' + qld.TotalQuotedSales	
		from
			@QuoteLogData qld
		where
			qld.LightingStudyId = @CurrentId
			and qld.EEIPartNumber = @PartNumber	
				
		update
			@temp
		set
			EAU = @EAU
		,	QuotePrice = @QuotePrice
		,	StraightMaterialCost = @StraightMaterialCost
		,	TotalQuotedSales = @TotalQuotedSales
		where
			LightingStudyId = @CurrentId

	end
	
	
	update
		@QuoteLogData
	set
		Processed = 1
	where
		LightingStudyId = @CurrentId
		and EEIPartNumber = @PartNumber

end	
		
					--select * from @temp		
*/



/*
-- Create a condensed data set
declare @QuoteLogDataGrouped table
(
	LightingStudyId int
,	QuoteNumber varchar(200)
,	EEIPartNumber varchar(500)
,	EAU varchar(200)
,	ApplicationName varchar(1000)
,	SalesInitials varchar(50)
,	QuotePrice varchar(100)
,	Awarded varchar(50)
,	QuoteStatus varchar(100)
,	StraightMaterialCost varchar(100)
,	TotalQuotedSales varchar(200)
)
insert @QuoteLogDataGrouped
(
	LightingStudyId
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
)
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
*/
	
	
	


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
,	QuoteNumber varchar(200)
,	EEIPartNumber varchar(500)
,	EAU varchar(200)
,	ApplicationName varchar(1000)
,	SalesInitials varchar(50)
,	QuotePrice varchar(100)
,	Awarded varchar(50)
,	QuoteStatus varchar(100)
,	StraightMaterialCost varchar(100)
,	TotalQuotedSales varchar(200)
,	SalesForecastVehicle varchar(50)
,	SalesForecastEEIBasePart varchar(500)
,	SalesForecastPeakYearlyVolume decimal(20,6)
,	SalesForecastApplication varchar(1000)
,	SalesForecastSopYear varchar(100)
,	RowID int identity
,	primary key(ID, RowID)
)
;


with cte_msf (Vehicle, Applications, BaseParts, SopYears)
as
(
	select
		g.Vehicle as Vehicle
	,	FX.ToList(g.Applications) as Applications
	,	FX.ToList(g.BaseParts) as BaseParts
	,	FX.ToList(g.SOPYears) as SopYears
	from
		@SalesForecastDataGrouped g
	group by
		g.Vehicle
)
,
cte_ql (LightingStudyId, QuoteNumber, EEIPartNumber, EAU, ApplicationName, SalesInitials, QuotePrice, Awarded, QuoteStatus, StraightMaterialCost, TotalQuotedSales)
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
,	SalesForecastPeakYearlyVolume
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
,	msf.Vehicle
,	msf.BaseParts
,	0.0
,	msf.Applications
,	msf.SopYears
from 
	eeiuser.ST_LightingStudy_Hitlist_2016 hl
	--left join eeiuser.QT_LightingStudy_QuoteNumbers qt
	--	on qt.LightingStudyId = hl.ID
	--left join eeiuser.QT_QuoteLog ql
	--	on ql.QuoteNumber = qt.QuoteNumber	
	left join eeiuser.ST_SalesLeadLog_Header h
		on h.CombinedLightingId = hl.ID
	left join dbo.employee e
		on e.operator_code = h.SalesPersonCode
	left join cte_msf msf
		on (msf.Vehicle like '%' + hl.Nameplate + '%' COLLATE Latin1_General_CS_AS )
	left join cte_ql ql
		on ql.LightingStudyId = hl.ID
where
	hl.Customer = @Customer
	and hl.Region = @Region





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

update
	thql
set
	SalesForecastPeakYearlyVolume = thp.SalesForecastPeakYearlyVolume
from
	@tempHitlistQuoteLog thql
	join @tempHitlistPeaks thp
		on thp.ID = thql.ID




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
,	SalesForecastPeakYearlyVolume
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
GO
