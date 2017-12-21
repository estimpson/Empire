SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [TOPS].[usp_PlanningSnapshot_NewPlanningForFinishedPart]
	@FinishedPart varchar(25)
,	@ParentHeirarchID hierarchyid
,	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_warnings off
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
/*	Generate important dates. */
begin
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
		@KeyDatesXML xml =
		(	select
				*
			from
				(	select
						[TranDT] = @TranDT
					,	[Today] = @Today
					,	[WkDay] = @WkDay
					,	[MondayOffset] = @MondayOffset
					,	[ThisMonday] = @ThisMonday
					,	[LastDaily] = @LastDaily
					,	[PastDT] = @PastDT
				) KD
			for xml auto
		)
end

/*	Get planning calendar. */
begin
	declare
		@PlanningCalendarXML xml

	--- <Call>	
	set	@CallProcName = 'TOPS.usp_PlanningSnapshot_GetNewPlanningCalendarXML'

	execute @ProcReturn = TOPS.usp_PlanningSnapshot_GetNewPlanningCalendarXML
		@ThisMonday = @ThisMonday
	,	@PlanningCalendarXML = @PlanningCalendarXML out
	,	@TranDT = @TranDT out
	,	@Result = @Result out

	set	@Error = @@Error
	if	@Error != 0 begin
		set	@Result = 900501
		RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	if	@ProcReturn != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	if	@ProcResult != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	--- </Call>
end

/*	Get header data. */
begin
	declare
		@PlanningHeaderXML xml

	--- <Call>	
	set	@CallProcName = 'TOPS.usp_PlanningSnapshot_GetHeaderXML'
	exec @ProcReturn = TOPS.usp_PlanningSnapshot_GetHeaderXML
		@FinishedPart = @FinishedPart
	,	@ThisMonday = @ThisMonday
	,	@PlanningHeaderXML = @PlanningHeaderXML out
	,	@TranDT = @TranDT out
	,	@Result = @ProcResult out
	
	set	@Error = @@Error
	if	@Error != 0 begin
		set	@Result = 900501
		RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	if	@ProcReturn != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	if	@ProcResult != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	--- </Call>
	
end

/*	Get customer requirements. */
begin
	declare
		@CustomerRequirementsXML xml

	--- <Call>	
	set	@CallProcName = 'TOPS.usp_PlanningSnapshot_GetCustomerRequirementsXML'
	
	execute @ProcReturn = TOPS.usp_PlanningSnapshot_GetCustomerRequirementsXML
			@FinishedPart = @FinishedPart
		,	@ThisMonday = @ThisMonday
		,	@LastDaily = @LastDaily
		,	@PastDT = @PastDT
		,	@CustomerRequirementsXML = @CustomerRequirementsXML out
		,	@TranDT = @TranDT out
		,	@Result = @ProcResult out
	
	set	@Error = @@Error
	if	@Error != 0 begin
		set	@Result = 900501
		RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	if	@ProcReturn != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	if	@ProcResult != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	--- </Call>
	
end

/*	Get in transit EEI. */
begin
	declare
		@InTransInventoryXML xml

	--- <Call>	
	set	@CallProcName = 'TOPS.usp_PlanningSnapshot_GetInTransInventoryXML'

	execute @ProcReturn = TOPS.usp_PlanningSnapshot_GetInTransInventoryXML
			@FinishedPart = @FinishedPart
		,	@InTransInventoryXML = @InTransInventoryXML out
		,	@TranDT = @TranDT out
		,	@Result = @ProcResult out
	
	set	@Error = @@Error
	if	@Error != 0 begin
		set	@Result = 900501
		RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	if	@ProcReturn != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	if	@ProcResult != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	--- </Call>
	
end

/*	Get on order EEH. */
begin
	declare
		@OnOrderEEHXML xml

	--- <Call>	
	set	@CallProcName = 'TOPS.usp_PlanningSnapshot_GetOnOrderXML'

	execute @ProcReturn = TOPS.usp_PlanningSnapshot_GetOnOrderXML
			@FinishedPart = @FinishedPart
		,	@ThisMonday = @ThisMonday
		,	@LastDaily = @LastDaily
		,	@PastDT = @PastDT
		,	@OnOrderEEHXML = @OnOrderEEHXML
		,	@TranDT = @TranDT out
		,	@Result = @ProcResult out
	
	set	@Error = @@Error
	if	@Error != 0 begin
		set	@Result = 900501
		RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	if	@ProcReturn != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	if	@ProcResult != 0 begin
		set	@Result = 900502
		RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
		rollback tran @ProcName
		return	@Result
	end
	--- </Call>
	
end

/*	Get holiday schedule. */
declare
	@HolidayScheduleXML xml =
	(	select
			*
		from
			TOPS.HolidaySchedule HS
		for xml auto
	)

/*	Generate Planning Snapshot XML. */
declare
	@PlanningSnapshotXML xml =
	(	select
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
				,	HolidaySchedule = @HolidayScheduleXML
			) PlanningSnapshot
		for xml auto
	)

select
	@PlanningSnapshotXML
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
,	@ParentHeirarchID hierarchyid

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = TOPS.usp_PlanningSnapshot_NewPlanningForFinishedPart
	@FinishedPart = @FinishedPart
,	@ParentHeirarchID = @ParentHeirarchID
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
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
