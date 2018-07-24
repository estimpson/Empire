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
,	@Debug int = 0
,	@DebugMsg varchar(max) = null out
as
begin

	--set xact_abort on
	set nocount on

	--- <TIC>
	declare
		@cDebug int = @Debug + 2 -- Child procedure call level

	if	@Debug & 0x01 = 0x01 begin
		declare
			@TicDT datetime = getdate()
		,	@TocDT datetime
		,	@cDebugMsg varchar(max)

		set @DebugMsg = replicate(' -', (@Debug & 0x3E) / 2) + 'Start ' + user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)
	end
	--- </TIC>

	--- <SP Begin Logging>
	declare
		@LogID int

	insert
		FXSYS.USP_Calls
	(	USP_Name
	,	BeginDT
	,	InArguments
	)
	select
		USP_Name = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)
	,	BeginDT = getdate()
	,	InArguments =
			'@FinishedPart = ' + FXSYS.fnStringArgument(@FinishedPart)
			+ ', @ThisMonday = ' + FXSYS.fnDateTimeArgument(@ThisMonday)
			+ ', @PlanningHeaderXML = ' + FXSYS.fnXMLArgument(@PlanningHeaderXML)
			+ ', @TranDT = ' + FXSYS.fnDateTimeArgument(@TranDT)
			+ ', @Result = ' + FXSYS.fnIntArgument(@Result)
			+ ', @Debug = ' + FXSYS.fnIntArgument(@Debug)
			+ ', @DebugMsg = ' + FXSYS.fnStringArgument(@DebugMsg)

	set	@LogID = scope_identity()
	--- </SP Begin Logging>

	set	@Result = 999999

	--- <Error Handling>
	declare
		@CallProcName sysname
	,	@TableName sysname
	,	@ProcName sysname
	,	@ProcReturn integer
	,	@ProcResult integer
	,	@RowCount integer

	set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. TOPS.usp_Test
	--- </Error Handling>

	--- <TranCount>
	declare
		@TranCount smallint

	set	@TranCount = @@TranCount
	--- </TranCount>

	begin try
		--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
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
				@HNLeadTime table
			(	TopPart varchar(25)
			,	Part varchar(25)
			,	RealLeadTime int
			,	LongestLeadTime int
			,	BackDays int
			)

			if	exists
				(	select
						*
					from
						tempdb.sys.objects o
					where
						o.type in ('U')
						and o.object_id = object_id(N'tempdb..#HNLeadTime')
				) begin
				insert
					@HNLeadTime
				(	TopPart
				,	Part
				,	RealLeadTime
				,	LongestLeadTime
				,	BackDays
				)
				select
					ht.TopPart
				,	ht.Part
				,	ht.RealLeadTime
				,	ht.LongestLeadTime
				,	ht.BackDays
				from
					#HNLeadTime ht
				where
					ht.TopPart = @FinishedPart
			end
			else begin
				declare
					@LeadTimeSyntax nvarchar(max) = N'

					select
						*
					from
						openquery(EEHSQL1, ''exec MONITOR.TOPS.Leg_GetHNLeadTime ''''' + @FinishedPart + ''''''')

				'
				--print @LeadTimeSyntax

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
	
			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Honduras Lead Time'
				,	@TicDT = @TicDT
				,	@TocDT = @TocDT out
				,	@Debug = @Debug
				,	@DebugMsg = @DebugMsg out
				
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
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

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Miscellaneous Data'
				,	@TicDT = @TicDT
				,	@TocDT = @TocDT out
				,	@Debug = @Debug
				,	@DebugMsg = @DebugMsg out
							
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
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

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Default PO Data'
				,	@TicDT = @TicDT
				,	@TocDT = @TocDT out
				,	@Debug = @Debug
				,	@DebugMsg = @DebugMsg out
							
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	EEH Capacity Data. */
		begin
			declare
				@EEH_CapacityData table
			(	BasePart char(7)
			,	BottleNeck numeric(18,2)
			)

			if	exists
				(	select
						*
					from
						tempdb.dbo.sysobjects o
					where
						o.xtype in ('U')
						and o.id = object_id(N'tempdb..#EEHCapacityData')
				) begin
				insert
					@EEH_CapacityData
				(	BasePart
				,	BottleNeck
				)
				select
					BasePart
				,	BottleNeck
				from
					#EEHCapacityData
				where
					BasePart = left(@FinishedPart, 7)
			end
			else begin
				declare
					@EEH_CapacitySyntax nvarchar(max) = N'

					select
						*
					from
						openquery(EEHSQL1, ''exec MONITOR.TOPS.Leg_Get_EEH_Capacity ''''' + left(@FinishedPart, 7) + ''''''')

			'
				--print @@EEH_CapacitySyntax

				insert
					@EEH_CapacityData
				exec master.dbo.sp_executesql
					@EEH_CapacitySyntax
			end

			declare
				@EEH_Capacity numeric(18,2) =
				(	select
						min(BottleNeck * 41.65)
					from
						@EEH_CapacityData
				)
	
			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'EEH Capacity Data'
				,	@TicDT = @TicDT
				,	@TocDT = @TocDT out
				,	@Debug = @Debug
				,	@DebugMsg = @DebugMsg out
							
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	EOP Data. */
		begin
			declare
				@EOP_Data table
			(	BasePart char(7)
			,	SOP datetime
			,	EOP datetime
			)

			if	exists
				(	select
						*
					from
						tempdb.dbo.sysobjects o
					where
						o.xtype in ('U')
						and o.id = object_id(N'tempdb..#EOPData')
				) begin
				insert
					@EOP_Data
				(	BasePart
				,	SOP
				,	EOP
				)
				select
					ed.BasePart
				,	ed.SOP
				,	ed.EOP
				from
					#EOPData ed
				where
					ed.BasePart = left(@FinishedPart, 7)
			end
			else begin
				insert
					@EOP_Data
				select
					le.BasePart
				,	le.SOP
				,	le.EOP
				from
					TOPS.Leg_EOP le
				where
					le.BasePart = left(@FinishedPart, 7)
			end

			declare
				@SOP datetime =
				(	select
						min(ed.SOP)
					from
						@EOP_Data ed			
				)
			--	'Error Checking'

			declare
				@EOP datetime =
				(	select
						min(ed.EOP)
					from
						@EOP_Data ed			
				)

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'EOP Data'
				,	@TicDT = @TicDT
				,	@TocDT = @TocDT out
				,	@Debug = @Debug
				,	@DebugMsg = @DebugMsg out
							
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
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

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Troy OnHand Data'
				,	@TicDT = @TicDT
				,	@TocDT = @TocDT out
				,	@Debug = @Debug
				,	@DebugMsg = @DebugMsg out
							
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Create Planning Header XML. */
		begin
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

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				exec FXSYS.usp_SPTock
					@StepDescription = N'Create Planning Header XML'
				,	@TicDT = @TicDT
				,	@TocDT = @TocDT out
				,	@Debug = @Debug
				,	@DebugMsg = @DebugMsg out
							
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end
		--- </Body>

		---	<CloseTran AutoCommit=Yes>
		if	@TranCount = 0 begin
			commit tran @ProcName
		end
		---	</CloseTran AutoCommit=Yes>

		--- <SP End Logging>
		update
			uc
		set	EndDT = getdate()
		,	OutArguments = 
				'@PlanningHeaderXML = ' + coalesce(convert(varchar(max), @PlanningHeaderXML), '<null>')
				+ ', @TranDT = ' + coalesce(convert(varchar, @TranDT, 121), '<null>')
				+ ', @Result = ' + coalesce(convert(varchar, @Result), '<null>')
		from
			FXSYS.USP_Calls uc
		where
			uc.RowID = @LogID
		--- </SP End Logging>

		--- <TIC/TOC END>
		if	@Debug & 0x3F = 0x01 begin
			set @DebugMsg = @DebugMsg + char(13) + char(10)
			print @DebugMsg
			print ''
		end
		--- </TIC/TOC END>

		---	<Return>
		set	@Result = 0
		return
			@Result
		--- </Return>
	end try
	begin catch
		declare
			@errorSeverity int
		,	@errorState int
		,	@errorMessage nvarchar(2048)
		,	@xact_state int;
	
		select
			@errorSeverity = error_severity()
		,	@errorState = error_state ()
		,	@errorMessage = error_message()
		,	@xact_state = xact_state();

		execute FXSYS.usp_PrintError;

		if	@xact_state = -1 begin 
			rollback;
			execute FXSYS.usp_LogError;
		end
		if	@xact_state = 1 and @TranCount = 0 begin
			rollback;
			execute FXSYS.usp_LogError;
		end
		if	@xact_state = 1 and @TranCount > 0 begin
			rollback transaction @ProcName;
			execute FXSYS.usp_LogError;
		end

		raiserror(@errorMessage, @errorSeverity, @errorState)
	end catch
end
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
,	@Debug int = 3
,	@DebugMsg varchar(max) = null

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
,	@Debug = @Debug
,	@DebugMsg = @DebugMsg out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult, @PlanningHeaderXML, @DebugMsg
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
