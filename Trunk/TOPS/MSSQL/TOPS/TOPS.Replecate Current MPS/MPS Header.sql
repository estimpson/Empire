declare
	@FinishedPart varchar(25) = 'ALC0598-HC02'
	--@FinishedPart varchar(25) = 'ACH0021-HF00'

/*	Calendar */
declare
	@Today datetime = FT.fn_TruncDate('d', getdate())
declare
	@WkDay tinyint = datepart(weekday, @Today)
declare
	@MondayOffset int = -@WkDay + 2
declare
	@ThisMonday datetime = @Today + @MondayOffset
declare
	@LastDaily datetime = @ThisMonday + 13
declare
	@PastDT datetime = @ThisMonday - 2

declare
	@Calendar table
(	CalendarDT datetime
,	DailyWeekly char(1)
,	WeekNo int
)

insert
	@Calendar
(	CalendarDT
,	DailyWeekly
,	WeekNo
)
select
	CalendarDT = @ThisMonday + ur.RowNumber - 1
,	'D'
,	WeekNo = datediff(day, @ThisMonday, @ThisMonday + ur.RowNumber - 1)/7 + 1
from
	FT.udf_Rows(14) ur
union all
select
	CalendarDT = @ThisMonday + (ur.RowNumber - 1) * 7
,	'W'
,	WeekNo = datediff(day, @ThisMonday, @ThisMonday + (ur.RowNumber - 1) * 7)/7 + 1
from
	FT.udf_Rows(58) ur
where
	ur.RowNumber > 2

/*	Honduras Lead Time. */
begin
declare
	@LeadTimeSyntax nvarchar(max) = N'

	select
		*
	from
		openquery(EEHSQL1, ''exec MONITOR.TOPS.Leg_GetHNLeadTime ''''' + @FinishedPart + ''''''')

'
--print @LeadTimeSyntax

declare
	@HNLeadTime table
(	TopPart varchar(25)
,	Part varchar(25)
,	RealLeadTime int
,	LongestLeadTime int
,	BackDays int
)

insert
	@HNLeadTime
exec master.dbo.sp_executesql
	@LeadTimeSyntax

--select
--	*
--from
--	@HNLeadTime hlt

declare
	@LongestLeadtime int =
	(	select
			max(LongestLeadTime)
		from
			@HNLeadTime
	)

declare
	@Backdays int =
	(	select
			max(BackDays)
		from
			@HNLeadTime
	)

declare
	@LeadTime int =
	(	select
			max(LongestLeadTime + round(BackDays / 7.0, 0) * 7)
		from
			@HNLeadTime
	)
declare
	@LeadTimeDate datetime = @ThisMonday + 7 * 4 + @LeadTime

end

/*	Miscellaneous Data. */
begin

	declare
		@MiscData table
	(	Part varchar(25)
	,	Description varchar(100)
	,	CrossRef varchar(100)
	,	Type char(1)
	,	UserDefined1 varchar(30)
	,	StandardPack numeric(20,6)
	,	Price numeric(20,6)
	,	LongestLT int
	,	MinProdRun numeric(20,6)
	,	ProdEnd datetime
	,	EAU numeric(20,6)
	,	ProdStart datetime
	,	ProdEnd2 datetime
	)
	insert
		@MiscData
	(	Part
	,	Description
	,	CrossRef
	,	Type
	,	UserDefined1
	,	StandardPack
	,	Price
	,	LongestLT
	,	MinProdRun
	,	ProdEnd
	,	EAU
	,	ProdStart
	,	ProdEnd2
	)
	select
		*
	from
		TOPS.Leg_PartMiscData lpmd
	where
		lpmd.Part = @FinishedPart

	/*	Is there a min production (aka Misc data) data row. */
	declare
		@CountIfMinProduction tinyint =
			(	select
					count(*)
				from
					@MiscData
			)

	/*	Standard pack */
	declare
		@StandardPack numeric (20,6) =
			case when @CountIfMinProduction = 1 then
				(	select
						max(StandardPack)
					from
						@MiscData
				)
				else 1
			end


	/*	Sales Price */
	declare
		@SalesPrice numeric (20,6) =
			(	select
					max(Price)
				from
					@MiscData
			)

	/*	ABC Class */
	declare
		@ABC_Class varchar(30) =
			(	select
					max(UserDefined1)
				from
					@MiscData
			)
	declare
		@ABC_Class_1 tinyint =
			case
				when @ABC_Class in ('A', 'B', 'C') then 2
				else 0
			end
	declare
		@ABC_Class_2 tinyint =
			case
				when @ABC_Class in ('A', 'B', 'C') then 3
				when @ABC_Class = 'SB' then 1
				else 0
			end

	/*	EAU EEI */
	declare
		@EAU_EEI numeric(20,6) =
			(	select
					round(EAU / 48.0, 2)
				from
					@MiscData
			)
	
	/*	Customer Part */
	declare
		@CustomerPart varchar(30) =
		(	select
				CrossRef
			from
				@MiscData
		)

	/*	Description */
	declare
		@Description varchar(100) =
		(	select
				Description
			from
				@MiscData
		)
end

/*	Default PO Data. */
begin
	declare
		@DefaultPOData table
	(	Part varchar(25)
	,	Type char(1)
	,	DefaultPONumber int
	,	VendorCode varchar(10)
	,	BlanketPart varchar(25)
	)
	insert
		@DefaultPOData
	(	Part
	,	Type
	,	DefaultPONumber
	,	VendorCode
	,	BlanketPart
	)
	select
		*
	from
		TOPS.Leg_DefaultPOs ldpo
	where
		ldpo.Part = @FinishedPart
	
	/*	Is there a default po (aka default po] data row. */
	declare
		@CountIfDefaultPO tinyint =
			(	select
					count(*)
				from
					@DefaultPOData
			)

	/*	Default PO */
	declare
		@DefaultPO varchar(50) =
			case when @CountIfDefaultPO > 0 then
				(	select
						convert(varchar, max(DefaultPONumber))
					from
						@DefaultPOData
				)
				else 'NO OPEN ORDERS'
			end
end

/*	EEH Capacity Data. */
begin

	declare
		@EEH_CapacitySyntax nvarchar(max) = N'

		select
			*
		from
			openquery(EEHSQL1, ''exec MONITOR.TOPS.Leg_Get_EEH_Capacity ''''' + left(@FinishedPart, 7) + ''''''')

'
	--print @@EEH_CapacitySyntax

	declare
		@EEH_CapacityData table
	(	BasePart char(7)
	,	CapacityPerHour numeric(10)
	,	ProductionCoordinator nvarchar(30)
	,	AssociatedLine varchar(25)
	,	IsPremium varchar(3)
	,	TransactionDT datetime
	,	BottleNeck numeric(18,2)
	)

	insert
		@EEH_CapacityData
	exec master.dbo.sp_executesql
		@EEH_CapacitySyntax

	declare
		@EEH_Capacity numeric(18,2) =
		(	select
				BottleNeck * 41.65
			from
				@EEH_CapacityData
		)
end

/*	EOP Data. */
begin
	declare
		@EOP_Data table
	(	BasePart char(7)
	,	SOP datetime
	,	EOP datetime
	)

	insert
		@EOP_Data
	select
		*
	from
		TOPS.Leg_EOP
	where
		BasePart = left(@FinishedPart, 7)

	declare
		@SOP datetime =
		(	select
				ed.SOP
			from
				@EOP_Data ed			
		)

	declare
		@EOP datetime =
		(	select
				ed.EOP
			from
				@EOP_Data ed			
		)
end

/*	Troy OnHand Data. */
begin
	declare
		@TroyOnHandData table
	(	Serial int
	,	Part varchar(25)
	,	Location varchar(10)
	,	Quantity numeric(20,6)
	,	Type char(1)
	,	LocationCode varchar(10)
	)
	
	insert
		@TroyOnHandData
	select
		*
	from
		TOPS.Leg_TroyOnHand
	where
		Part = @FinishedPart

	declare
		@InitOnHand numeric(20,6) =
		(	select
				sum(tohd.Quantity)
			from
				@TroyOnHandData tohd
		)
	declare
		@InitBalance numeric(20,6) = @InitOnHand

end

/*	Customer requirements. */
declare
	@CustomerRequirements table
(	DueDT datetime
,	OrderQty numeric(20,6)
,	DailyWeekly char(1)
)

insert
	@CustomerRequirements
(	DueDT
,	OrderQty
,	DailyWeekly
)
select
	loo.DueDT
,	loo.OrderQty
,	DailyWeekly =
		case
			when loo.DueDT < @LastDaily then 'D'
			else 'W'
		end
from
	(	select
			DueDT =
				case
					when loo.DueDT < @ThisMonday then @PastDT
					when loo.DueDT < @LastDaily then loo.DueDT
					else loo.MondayDate
				end
		,	OrderQty = sum(loo.Quantity)
		from
			TOPS.Leg_OpenOrders loo
		where
			loo.Part = @FinishedPart
		group by
			case
				when loo.DueDT < @ThisMonday then @PastDT
				when loo.DueDT < @LastDaily then loo.DueDT
				else loo.MondayDate
			end
		) loo
order by
	1

/*	In transit inventory. */
declare
	@InTransInventory table
(	InTransDT datetime
,	InTransQty numeric(20,6)
)

insert
	@InTransInventory
(	InTransDT
,	InTransQty
)
select
	lti.InTransDT
,	InTransQty = sum(lti.InTransQty)
from
	TOPS.Leg_TransInventory lti
where
	lti.Part = @FinishedPart
group by
	lti.InTransDT
order by
	lti.InTransDT

/*	On order with EEH. */
declare
	@OnOrderEEH table
(	PONumber int
,	OrderDT datetime
,	OrderQty numeric(20,6)
,	DailyWeekly char(1)
)

insert
	@OnOrderEEH
(	PONumber
,	OrderDT
,	OrderQty
,	DailyWeekly
)
select
	loo.PONumber
,	loo.DueDT
,	loo.Balance
,	DailyWeekly =
		case
			when loo.DueDT < @LastDaily then 'D'
			else 'W'
		end
from
	(	select
			PONumber = max(loo.PONumber)
		,	DueDT =
				case
					when loo.DueDT < @ThisMonday then @PastDT
					when loo.DueDT < @LastDaily then loo.DueDT
					else loo.MondayDate
				end
		,	Balance = sum(loo.Balance)
		from
			TOPS.Leg_OnOrder loo
		where
			loo.Part = @FinishedPart
		group by
				case
					when loo.DueDT < @ThisMonday then @PastDT
					when loo.DueDT < @LastDaily then loo.DueDT
					else loo.MondayDate
				end
	) loo
order by
	loo.DueDT

/*	Generate Planning Snapshot. */
declare
	@PlanningHeaderXML xml =
	(	select
			*
		from
			(	select
					[FinishedPart] = @FinishedPart
				,	[CountIfMinProduction] = @CountIfMinProduction
				,	[StandardPack] = @StandardPack
				,	[CountIfDefaultPO] = @CountIfDefaultPO
				,	[DefaultPO] = @DefaultPO
				,	[SalesPrice] = @SalesPrice
				,	[ABC_Class] = @ABC_Class
				,	[ABC_Class_1] = @ABC_Class_1
				,	[ABC_Class_2] = @ABC_Class_2
				,	[LongestLeadtime] = @LongestLeadtime
				,	[Backdays] = @Backdays
				,	[LeadTime] = @LeadTime
				,	[LeadTimeDate] = @LeadTimeDate
				,	[EAU_EEI] = @EAU_EEI
				,	[EEH_Capacity] = @EEH_Capacity
				,	[SOP] = @SOP
				,	[EOP] = @EOP
				,	[CustomerPart] = @CustomerPart
				,	[Description] = @Description
				,	[InitOnHand] = @InitOnHand
				,	[InitBalance] = @InitBalance
			) PH
		for xml auto
	)

declare
	@KeyDatesXML xml =
	(	select
			*
		from
			(	select
					[Today] = @Today
				,	[WkDay] = @WkDay
				,	[MondayOffset] = @MondayOffset
				,	[ThisMonday] = @ThisMonday
				,	[LastDaily] = @LastDaily
				,	[PastDT] = @PastDT
			) KD
		for xml auto
	)

declare
	@PlanningCalendarXML xml =
	(	select
			*
		from
			@Calendar PC
		for xml auto
	)

declare
	@CustomerRequirementsXML xml =
	(	select
			*
		from
			@CustomerRequirements CR
		for xml auto
	)

declare
	@InTransInventoryXML xml =
	(	select
			*
		from
			@InTransInventory ITI
		for xml auto
	)

declare
	@OnOrderEEhXML xml =
	(	select
			*
		from
			@OnOrderEEH OOE
		for xml auto
	)


declare
	@HolidaySchedule xml =
	(	select
			*
		from
			TOPS.HolidaySchedule HS
		for xml auto
	)

select
	PlanningSnapshot.PlanningHeader
,	KeyDates = PlanningSnapshot.KeyDates
,	PlanningSnapshot.PlanningCalendar
,	PlanningSnapshot.CustomerRequirements
,	PlanningSnapshot.InTransInventoryXML
,	PlanningSnapshot.OnOrderEEhXML
,	PlanningSnapshot.HolidaySchedule
from
	(	select
			PlanningHeader = @PlanningHeaderXML
		,	KeyDates = @KeyDatesXML
		,	PlanningCalendar = @PlanningCalendarXML
		,	CustomerRequirements = @CustomerRequirementsXML
		,	InTransInventoryXML = @InTransInventoryXML
		,	OnOrderEEhXML = @OnOrderEEhXML
		,	HolidaySchedule = @HolidaySchedule
	) PlanningSnapshot
for xml auto