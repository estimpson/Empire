SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE function [FT].[fn_DemandChange]
(	@ReferenceDT datetime)
returns @Results table
(	Basepart varchar (24),
	CurrentSnapShotDT datetime,
	CurrentReleasePlanID int,
	PriorPeriodSnapShotDT datetime,
	PriorReleasePlanID int,
	AccumShippedPriorPeriod numeric(20,4),
	AccumShippedCurrentPeriod numeric(20,4),
	Week5AccumPriorPeriod  numeric(20,4),
	Week5AccumCurrentPeriod numeric(20,4),
	Week5NetChange as (Week5AccumCurrentPeriod-Week5AccumPriorPeriod),
	Week5AccumPercentChange as 
		case when Week5AccumPriorPeriod= Week5AccumCurrentPeriod 
					then 0.00
					when Week5AccumPriorPeriod = 0 and Week5AccumCurrentPeriod != 0  
					then 100.00
					when Week5AccumPriorPeriod != 0 and Week5AccumCurrentPeriod = 0
					then -100.00
					else   ((Week5AccumCurrentPeriod-Week5AccumPriorPeriod)/Week5AccumPriorPeriod)*100.00 end,
	Week10AccumPriorPeriod numeric(10,2),	
	Week10AccumCurrentPeriod numeric(10,2),
	Week10NetChange as (Week10AccumCurrentPeriod-Week10AccumPriorPeriod),
	Week10AccumPercentChange as
		case when Week10AccumPriorPeriod= Week10AccumCurrentPeriod 
					then 0.00
					when Week10AccumPriorPeriod = 0 and Week10AccumCurrentPeriod != 0  
					then 100.00
					when Week10AccumPriorPeriod != 0 and Week10AccumCurrentPeriod = 0
					then -100.00
					else   ((Week10AccumCurrentPeriod-Week10AccumPriorPeriod)/Week10AccumPriorPeriod)*100.00 end)
as
begin

--Select * From	[FT].[fn_DemandChange] (getdate()) where BasePart='NAL0124'
--Declare Variables
declare	@CurrentWeekNo int,
				@Week5WeekNo int,
				@Week10WeekNo int,
				@CustomerReleasePlanID int,
				@LastWeekCustomerReleasePlanID int,
				@BeginCustomerReleasePlanID int
			
--Populate variables
select		@CurrentWeekNo = datediff(wk, '1999-01-03', getdate())
select		@Week5WeekNo =		@CurrentWeekNo+5
select		@Week10WeekNo =	@CurrentWeekNo+10
select		@CustomerReleasePlanID = max(ID) from dbo.CustomerReleasePlans where GeneratedWeekNo = @CurrentWeekNo
select		@LastWeekCustomerReleasePlanID = max(ID) from dbo.CustomerReleasePlans where GeneratedWeekNo < @CurrentWeekNo
select		@BeginCustomerReleasePlanID = max(ID) from dbo.CustomerReleasePlans where GeneratedWeekNo < @CurrentWeekNo-16

--Get Base Part List (Uses same logic as target inventory report)			
Declare @OnPO table
        (
          BasePart varchar(25)
          PRIMARY KEY NONCLUSTERED ( BasePart )
        )

    INSERT  @OnPO
            select
				distinct left(part_number, 7)
            FROM    dbo.po_detail
            JOIN	dbo.part_standard ON po_detail.part_number = part
            join		dbo.part_eecustom on dbo.part_standard.part = part_eecustom.part
            WHERE   
					vendor_code = 'EEH'
                    AND balance > 0 
                    and not exists  (select 1 from bill_of_material bom where bom.parent_part = po_detail.part_number)

    Declare @Inventory Table
        (
          BasePart varchar(25)
          PRIMARY KEY NONCLUSTERED ( BasePart )
        )


    INSERT  @Inventory
            SELECT  
				distinct 
					left(o.part,7)
            FROM    object O
					JOIN dbo.part_standard ps ON O.part = ps.part
                    LEFT JOIN location l ON o.location = l.code
            WHERE   ISNULL(secured_location, 'N') != 'Y'
                    AND O.part IN ( SELECT  part
                                    FROM    part
                                    WHERE   type = 'F' )  
                                    and not exists  (select 1 from bill_of_material bom where bom.parent_part = O.part)
            GROUP BY o.part

    
    Declare @Demand Table
        (
          BasePart varchar(25)
          PRIMARY KEY NONCLUSTERED ( BasePart )
        )
    INSERT  @Demand
            ( BasePart
            )
          SELECT  
				distinct
					left(part_number,7)
            FROM    dbo.order_detail
					join	dbo.order_header on dbo.order_detail.order_no = dbo.order_header.order_no
					join	customer on order_header.customer = customer.customer
                    JOIN dbo.part_standard ON part_number = part
    WHERE	DATEDIFF(week, GETDATE(), order_detail.due_date) <= 16 
							and not exists (select 1 from bill_of_material bom where bom.parent_part = order_detail.part_number)
							and (case when isNull(eeiqty,0) = 0 then quantity else eeiqty end)  > 1
	  
--Populate table variable with base parts		
declare	@BaseParts table
			(	BasePart varchar(25) primary key
			)


insert	@BaseParts
        ( BasePart )
	
select	BasePart
			
	from
		( select BasePart from @Demand
			union
			select basePart from @Inventory
			union
			select BasePart from @OnPO) Baseparts
			
	
	--Get the last Release plan ID and base part  captured for the last 16 weeks
	declare	@BasePartReleasePlanIDs table
	(	BasePart varchar(25),
		LastReleasePlanID int ,
		ReleasePlanWeek int, primary key(Basepart,  LastReleasePlanID)
	)	
	
	insert 	@BasePartReleasePlanIDs
		(	BasePart,
			LastReleasePlanID,
			ReleasePlanWeek )
		
	select	
		BasePart,
		max(ReleasePlanID),
		CurrentWeek
	from
		dbo.CustomerReleasePlanRaw RAW1  
	 join	order_header oh on RAW1.OrderNumber =oh.order_no and oh.customer not in ('EEA', 'EEH')		
	Where RAW1.ReleasePlanID>=@LastWeekCustomerReleasePlanID and basePart in (select BasePart from @BaseParts)
	
	group by 
		BasePart,
		CurrentWeek

--Get the last release plan ID / base part captured 
declare	@LastBasePartReleasePlanID table
	(	BasePart varchar(25),
		LastReleasePlanID int,
		LastReleasePlanWeek int,
		primary key(Basepart)
	)	
	
	insert 	@LastBasePartReleasePlanID
		(	BasePart,
			LastReleasePlanID, 
			LastReleasePlanWeek
			)
		
	select	
		BasePart ,		
		max(LastReleasePlanID) ,
		max(ReleasePlanWeek)
	from
		@BasePartReleasePlanIDs
		group by
		BasePart
		
					
--Get last and prior Release Plan Ids / base Part
declare	@BasePartReleasePlanID table
	(	BasePart varchar(25),
		LastReleasePlanID int,
		PriorReleasePlanID int,
		primary key(Basepart, LastReleasePlanID, PriorReleasePlanID)
	)	
	
	insert 	@BasePartReleasePlanID
		(	BasePart,
			LastReleasePlanID, 
			PriorReleasePlanID
			)
select
	BasePart,
	LastReleasePlanID,
	coalesce((Select max(LastReleasePlanID) from @BasePartReleasePlanIDs BRPs where BRPs.ReleasePlanWeek<LRPs.LastReleasePlanWeek ), LastReleasePlanID)
from
	@LastBasePartReleasePlanID LRPs

order by 
	1,2
	
insert @Results
        (	Basepart ,
			CurrentSnapShotDT, 
			CurrentReleasePlanID,
			PriorPeriodSnapShotDT,
			PriorReleasePlanID,
			AccumShippedPriorPeriod,
			AccumShippedCurrentPeriod,
			Week5AccumPriorPeriod,
			Week5AccumCurrentPeriod,
			Week10AccumPriorPeriod,
			Week10AccumCurrentPeriod
        )

	select BasePart ,
				CurrentPeriodGenDate ,
				CurrentPeriodID ,
				PriorPeriodGenDate ,
				PriorPeriodID ,
				PriorPeriodAccumShipped ,
				CurrentPeriodAccumShipped ,
				dbo.fn_GreaterOf(PriorPeriodWeek5Demand,PriorPeriodAccumShipped) ,
				dbo.fn_GreaterOf(CurrentPeriodWeek5Demand,CurrentPeriodAccumShipped) ,
				PriorPeriodWeek10Demand ,
				CurrentPeriodWeek10Demand
	from(
		select 
		BasePart ,
		Crps2.GeneratedDT CurrentPeriodGenDate,
		Crps2.ID CurrentPeriodID,
		Crps1.GeneratedDT PriorPeriodGenDate,
		CRps1.ID PriorPeriodID ,
		Coalesce((select max(AccumShipped) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs1.id and BasePart = BasePartIds.BasePart ),0) PriorPeriodAccumShipped,
		Coalesce((select max(AccumShipped) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs2.id and BasePart = BasePartIds.BasePart ),0) CurrentPeriodAccumShipped,
		Coalesce((select max(PostAccum) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs1.id and BasePart = BasePartIds.BasePart and WeekNo<= @Week5WeekNo),0) PriorPeriodWeek5Demand,
		Coalesce((select max(PostAccum) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs2.id and BasePart = BasePartIds.BasePart and WeekNo<= @Week5WeekNo),0) CurrentPeriodWeek5Demand,
		Coalesce((select max(PostAccum) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs1.id and BasePart = BasePartIds.BasePart and WeekNo<= @Week10WeekNo),0) PriorPeriodWeek10Demand,
		Coalesce((select max(PostAccum) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs2.id and BasePart = BasePartIds.BasePart and WeekNo<= @Week10WeekNo),0) CurrentPeriodWeek10Demand
		
			
	       
	from	
		@BasePartReleasePlanID BasePartIds
	join
		dbo.CustomerReleasePlans CRps1 on BasePartIds.PriorReleasePlanID = CRps1.ID
	join
		dbo.CustomerReleasePlans Crps2 on BasePartIds.LastReleasePlanID = CRps2.id
	) DemandChange
	order by 1 asc
	return
end




GO
