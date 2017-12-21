SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [TOPS].[usp_PlanningSnapshot_GetHeaderXML]
	@FinishedPart varchar(25)
,	@ThisMonday datetime
,	@PlanningHeaderXML xml out
,	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_warnings on
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. TOPS.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
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

set @PlanningHeaderXML =
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
--- </Body>

---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>

/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go

declare
	@FinishedPart varchar(25) = 'ALC0598-HC02'
,	@ThisMonday datetime = '2017-12-18'
,	@PlanningHeaderXML xml

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = TOPS.usp_PlanningSnapshot_GetHeaderXML
	@FinishedPart = @FinishedPart
,	@ThisMonday = @ThisMonday
,	@PlanningHeaderXML = @PlanningHeaderXML out
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult, @PlanningHeaderXML
go

if	@@trancount > 0 begin
	rollback
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/
GO
