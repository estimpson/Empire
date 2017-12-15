declare
	@TestPart varchar(25) = 'ALC0598-HC02'

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
	@Day1 datetime = @ThisMonday
,	@Day2 datetime = @ThisMonday + 1
,	@Day3 datetime = @ThisMonday + 2
,	@Day4 datetime = @ThisMonday + 3
,	@Day5 datetime = @ThisMonday + 4
,	@Day6 datetime = @ThisMonday + 5
,	@Day7 datetime = @ThisMonday + 6
,	@Day8 datetime = @ThisMonday + 7
,	@Day9 datetime = @ThisMonday + 8
,	@Day10 datetime = @ThisMonday + 9
,	@Day11 datetime = @ThisMonday + 10
,	@Day12 datetime = @ThisMonday + 11
,	@Day13 datetime = @ThisMonday + 12
,	@Day14 datetime = @ThisMonday + 13
,	@Day15 datetime = @ThisMonday + 14
,	@Week1 datetime = @ThisMonday
,	@Week2 datetime = @ThisMonday + 1 * 7
,	@Week3 datetime = @ThisMonday + 2 * 7
,	@Week4 datetime = @ThisMonday + 3 * 7
,	@Week5 datetime = @ThisMonday + 4 * 7

select
	@Today
,	@WkDay
,	@MondayOffset
,	@ThisMonday
,	@Day1
,	@Day2
,	@Day3
,	@Day4
,	@Day5
,	@Day6
,	@Day7
,	@Day8
,	@Day9
,	@Day10
,	@Day11
,	@Day12
,	@Day13
,	@Day14
,	@Day15
,	@Week1
,	@Week2
,	@Week3
,	@Week4
,	@Week5


/*	Honduras Lead Time. */
begin
declare
	@LeadTimeSyntax nvarchar(max) = N'

	select
		*
	from
		openquery(EEHSQL1, ''exec MONITOR.TOPS.Leg_GetHNLeadTime ''''' + @TestPart + ''''''')

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
	@LeadTimeDate datetime = @Week5 + @LeadTime

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
		lpmd.Part = @TestPart

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
		ldpo.Part = @TestPart
	
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
			openquery(EEHSQL1, ''exec MONITOR.TOPS.Leg_Get_EEH_Capacity ''''' + left(@TestPart, 7) + ''''''')

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
		BasePart = left(@TestPart, 7)

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



select
	[@TestPart] = @TestPart
,	[@CountIfMinProduction] = @CountIfMinProduction
,	[@StandardPack] = @StandardPack
,	[@CountIfDefaultPO] = @CountIfDefaultPO
,	[@DefaultPO] = @DefaultPO
,	[@SalesPrice] = @SalesPrice
,	[@ABC_Class] = @ABC_Class
,	[@ABC_Class_1] = @ABC_Class_1
,	[@ABC_Class_2] = @ABC_Class_2
,	[@LongestLeadtime] = @LongestLeadtime
,	[@Backdays] = @Backdays
,	[@LeadTime] = @LeadTime
,	[@LeadTimeDate] = @LeadTimeDate
,	[@EAU_EEI] = @EAU_EEI
,	[@EEH_Capacity] = @EEH_Capacity
,	[@SOP] = @SOP
,	[@EOP] = @EOP
,	[@CustomerPart] = @CustomerPart
,	[@Description] = @Description