SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE function [FT].[fn_DemandChangeWeekly]
(	@ReferenceDT datetime)
returns @Results table
(	Basepart varchar (24),
	CurrentSnapShotDT datetime,
	CurrentReleasePlanID int,
	PriorPeriodSnapShotDT datetime,
	PriorReleasePlanID int,
	AccumShippedPriorPeriod numeric(20,4),
	AccumShippedCurrentPeriod numeric(20,4),
	Week0AccumPriorPeriod  numeric(20,4),
	Week0AccumCurrentPeriod numeric(20,4),
	Week0NetChange as (Week0AccumCurrentPeriod-Week0AccumPriorPeriod),
	Week1AccumPriorPeriod  numeric(20,4),
	Week1AccumCurrentPeriod numeric(20,4),
	Week1NetChange as (Week1AccumCurrentPeriod-Week1AccumPriorPeriod),
	Week2AccumPriorPeriod  numeric(20,4),
	Week2AccumCurrentPeriod numeric(20,4),
	Week2NetChange as (Week2AccumCurrentPeriod-Week2AccumPriorPeriod),
	Week3AccumPriorPeriod  numeric(20,4),
	Week3AccumCurrentPeriod numeric(20,4),
	Week3NetChange as (Week3AccumCurrentPeriod-Week3AccumPriorPeriod),
	Week4AccumPriorPeriod  numeric(20,4),
	Week4AccumCurrentPeriod numeric(20,4),
	Week4NetChange as (Week4AccumCurrentPeriod-Week4AccumPriorPeriod),
	Week5AccumPriorPeriod  numeric(20,4),
	Week5AccumCurrentPeriod numeric(20,4),
	Week5NetChange as (Week5AccumCurrentPeriod-Week5AccumPriorPeriod),
	Week6AccumPriorPeriod  numeric(20,4),
	Week6AccumCurrentPeriod numeric(20,4),
	Week6NetChange as (Week6AccumCurrentPeriod-Week6AccumPriorPeriod),
	Week7AccumPriorPeriod  numeric(20,4),
	Week7AccumCurrentPeriod numeric(20,4),
	Week7NetChange as (Week7AccumCurrentPeriod-Week7AccumPriorPeriod),
	Week8AccumPriorPeriod  numeric(20,4),
	Week8AccumCurrentPeriod numeric(20,4),
	Week8NetChange as (Week8AccumCurrentPeriod-Week8AccumPriorPeriod),
	Week9AccumPriorPeriod  numeric(20,4),
	Week9AccumCurrentPeriod numeric(20,4),
	Week9NetChange as (Week9AccumCurrentPeriod-Week9AccumPriorPeriod),
	Week10AccumPriorPeriod numeric(10,2),	
	Week10AccumCurrentPeriod numeric(10,2),
	Week10NetChange as (Week10AccumCurrentPeriod-Week10AccumPriorPeriod))
	
as
begin

--Select * From	[FT].[fn_DemandChangeWeekly] (getdate()) where BasePart='NAL0124'
--Declare Variables
declare	@CurrentWeekNo int,
				@Week0WeekNo int,
				@Week1WeekNo int,
				@Week2WeekNo int,
				@Week3WeekNo int,
				@Week4WeekNo int,
				@Week5WeekNo int,
				@Week6WeekNo int,
				@Week7WeekNo int,
				@Week8WeekNo int,
				@Week9WeekNo int,
				@Week10WeekNo int,
				@CustomerReleasePlanID int,
				@LastWeekCustomerReleasePlanID int,
				@BeginCustomerReleasePlanID int
			
--Populate variables
select		@CurrentWeekNo = datediff(wk, '1999-01-03', getdate())
select		@Week0WeekNo =		@CurrentWeekNo+0
select		@Week1WeekNo =		@CurrentWeekNo+1
select		@Week2WeekNo =		@CurrentWeekNo+2
select		@Week3WeekNo =		@CurrentWeekNo+3
select		@Week4WeekNo =		@CurrentWeekNo+4
select		@Week5WeekNo =		@CurrentWeekNo+5
select		@Week6WeekNo =		@CurrentWeekNo+6
select		@Week7WeekNo =		@CurrentWeekNo+7
select		@Week8WeekNo =		@CurrentWeekNo+8
select		@Week9WeekNo =		@CurrentWeekNo+9
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
			Week0AccumPriorPeriod,
			Week0AccumCurrentPeriod,
			Week1AccumPriorPeriod,
			Week1AccumCurrentPeriod,
			Week2AccumPriorPeriod,
			Week2AccumCurrentPeriod,
			Week3AccumPriorPeriod,
			Week3AccumCurrentPeriod,
			Week4AccumPriorPeriod,
			Week4AccumCurrentPeriod,
			Week5AccumPriorPeriod,
			Week5AccumCurrentPeriod,
			Week6AccumPriorPeriod,
			Week6AccumCurrentPeriod,
			Week7AccumPriorPeriod,
			Week7AccumCurrentPeriod,
			Week8AccumPriorPeriod,
			Week8AccumCurrentPeriod,
			Week9AccumPriorPeriod,
			Week9AccumCurrentPeriod,
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
				dbo.fn_GreaterOf(PriorPeriodWeek0Demand,PriorPeriodAccumShipped) ,
				dbo.fn_GreaterOf(CurrentPeriodWeek0Demand,CurrentPeriodAccumShipped),
				dbo.fn_GreaterOf(PriorPeriodWeek1Demand,PriorPeriodAccumShipped) ,
				dbo.fn_GreaterOf(CurrentPeriodWeek1Demand,CurrentPeriodAccumShipped),
				dbo.fn_GreaterOf(PriorPeriodWeek2Demand,PriorPeriodAccumShipped) ,
				dbo.fn_GreaterOf(CurrentPeriodWeek2Demand,CurrentPeriodAccumShipped),
				dbo.fn_GreaterOf(PriorPeriodWeek3Demand,PriorPeriodAccumShipped) ,
				dbo.fn_GreaterOf(CurrentPeriodWeek3Demand,CurrentPeriodAccumShipped),
				dbo.fn_GreaterOf(PriorPeriodWeek4Demand,PriorPeriodAccumShipped) ,
				dbo.fn_GreaterOf(CurrentPeriodWeek4Demand,CurrentPeriodAccumShipped),
				dbo.fn_GreaterOf(PriorPeriodWeek5Demand,PriorPeriodAccumShipped) ,
				dbo.fn_GreaterOf(CurrentPeriodWeek5Demand,CurrentPeriodAccumShipped) ,
				dbo.fn_GreaterOf(PriorPeriodWeek6Demand,PriorPeriodAccumShipped) ,
				dbo.fn_GreaterOf(CurrentPeriodWeek6Demand,CurrentPeriodAccumShipped),
				dbo.fn_GreaterOf(PriorPeriodWeek7Demand,PriorPeriodAccumShipped) ,
				dbo.fn_GreaterOf(CurrentPeriodWeek7Demand,CurrentPeriodAccumShipped),
				dbo.fn_GreaterOf(PriorPeriodWeek8Demand,PriorPeriodAccumShipped) ,
				dbo.fn_GreaterOf(CurrentPeriodWeek8Demand,CurrentPeriodAccumShipped),
				dbo.fn_GreaterOf(PriorPeriodWeek9Demand,PriorPeriodAccumShipped) ,
				dbo.fn_GreaterOf(CurrentPeriodWeek9Demand,CurrentPeriodAccumShipped),
				dbo.fn_GreaterOf(PriorPeriodWeek10Demand,PriorPeriodAccumShipped) ,
				dbo.fn_GreaterOf(CurrentPeriodWeek10Demand,CurrentPeriodAccumShipped)
	from(
		select 
		BasePart ,
		Crps2.GeneratedDT CurrentPeriodGenDate,
		Crps2.ID CurrentPeriodID,
		Crps1.GeneratedDT PriorPeriodGenDate,
		CRps1.ID PriorPeriodID ,
		Coalesce((select max(AccumShipped) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs1.id and BasePart = BasePartIds.BasePart ),0) PriorPeriodAccumShipped,
		Coalesce((select max(AccumShipped) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs2.id and BasePart = BasePartIds.BasePart ),0) CurrentPeriodAccumShipped,
		Coalesce((select max(PostAccum) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs1.id and BasePart = BasePartIds.BasePart and WeekNo<= @Week0WeekNo),0) PriorPeriodWeek0Demand,
		Coalesce((select max(PostAccum) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs2.id and BasePart = BasePartIds.BasePart and WeekNo<= @Week0WeekNo),0) CurrentPeriodWeek0Demand,
		Coalesce((select max(PostAccum) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs1.id and BasePart = BasePartIds.BasePart and WeekNo<= @Week1WeekNo),0) PriorPeriodWeek1Demand,
		Coalesce((select max(PostAccum) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs2.id and BasePart = BasePartIds.BasePart and WeekNo<= @Week1WeekNo),0) CurrentPeriodWeek1Demand,
		Coalesce((select max(PostAccum) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs1.id and BasePart = BasePartIds.BasePart and WeekNo<= @Week2WeekNo),0) PriorPeriodWeek2Demand,
		Coalesce((select max(PostAccum) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs2.id and BasePart = BasePartIds.BasePart and WeekNo<= @Week2WeekNo),0) CurrentPeriodWeek2Demand,
		Coalesce((select max(PostAccum) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs1.id and BasePart = BasePartIds.BasePart and WeekNo<= @Week3WeekNo),0) PriorPeriodWeek3Demand,
		Coalesce((select max(PostAccum) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs2.id and BasePart = BasePartIds.BasePart and WeekNo<= @Week3WeekNo),0) CurrentPeriodWeek3Demand,
		Coalesce((select max(PostAccum) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs1.id and BasePart = BasePartIds.BasePart and WeekNo<= @Week4WeekNo),0) PriorPeriodWeek4Demand,
		Coalesce((select max(PostAccum) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs2.id and BasePart = BasePartIds.BasePart and WeekNo<= @Week4WeekNo),0) CurrentPeriodWeek4Demand,
		Coalesce((select max(PostAccum) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs1.id and BasePart = BasePartIds.BasePart and WeekNo<= @Week5WeekNo),0) PriorPeriodWeek5Demand,
		Coalesce((select max(PostAccum) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs2.id and BasePart = BasePartIds.BasePart and WeekNo<= @Week5WeekNo),0) CurrentPeriodWeek5Demand,
		Coalesce((select max(PostAccum) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs1.id and BasePart = BasePartIds.BasePart and WeekNo<= @Week6WeekNo),0) PriorPeriodWeek6Demand,
		Coalesce((select max(PostAccum) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs2.id and BasePart = BasePartIds.BasePart and WeekNo<= @Week6WeekNo),0) CurrentPeriodWeek6Demand,
		Coalesce((select max(PostAccum) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs1.id and BasePart = BasePartIds.BasePart and WeekNo<= @Week7WeekNo),0) PriorPeriodWeek7Demand,
		Coalesce((select max(PostAccum) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs2.id and BasePart = BasePartIds.BasePart and WeekNo<= @Week7WeekNo),0) CurrentPeriodWeek7Demand,
		Coalesce((select max(PostAccum) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs1.id and BasePart = BasePartIds.BasePart and WeekNo<= @Week8WeekNo),0) PriorPeriodWeek8Demand,
		Coalesce((select max(PostAccum) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs2.id and BasePart = BasePartIds.BasePart and WeekNo<= @Week8WeekNo),0) CurrentPeriodWeek8Demand,
		Coalesce((select max(PostAccum) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs1.id and BasePart = BasePartIds.BasePart and WeekNo<= @Week9WeekNo),0) PriorPeriodWeek9Demand,
		Coalesce((select max(PostAccum) from dbo.CustomerReleasePlanRaw where ReleasePlanID = CRPs2.id and BasePart = BasePartIds.BasePart and WeekNo<= @Week9WeekNo),0) CurrentPeriodWeek9Demand,
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
