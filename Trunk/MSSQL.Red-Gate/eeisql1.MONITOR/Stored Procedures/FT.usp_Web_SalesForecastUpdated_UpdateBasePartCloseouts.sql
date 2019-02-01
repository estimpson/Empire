SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [FT].[usp_Web_SalesForecastUpdated_UpdateBasePartCloseouts]
	@UserCode varchar(5)
,	@BasePart varchar(50)
,	@VerifiedEop varchar(30)
,	@VerifiedEopDate datetime = null
,	@SchedulerResponsible varchar(50)
,	@RfMpsLink varchar(100)
,	@SchedulingTeamComments varchar(500)
,	@MaterialsComments varchar(500)
,	@ShipToLocation varchar(50)
,	@FgInventoryAfterBuildout decimal(20,6) = null
,	@CostEach varchar(50)
,	@ExcessFgAfterBuildout decimal(20,6) = null
,	@ExcessRmAfterBuildout decimal(20,6) = null
,	@ProgramExposure decimal(20,6) = null
,	@DateToSendCoLetter datetime = null
,	@ObsolescenceCost decimal(20,6) = null
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
--- </Error Handling>


--- <SP Begin Logging>
declare
	@LogID int

insert
	FxSYS.USP_Calls
(	USP_Name
,	BeginDT
,	InArguments
)
select
	USP_Name = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)
,	BeginDT = getdate()
,	InArguments =
		'@UserCode = ' + coalesce('''' + @UserCode + '''', '<null>')
		+ ', @TranDT = ' + coalesce(convert(varchar, @TranDT, 121), '<null>')
		+ ', @Result = ' + coalesce(convert(varchar, @Result), '<null>')

set	@LogID = scope_identity()
--- </SP Begin Logging>


/*	Record initial transaction count. */
declare
	@TranCount smallint

set	@TranCount = @@TranCount


begin try

	---	<ArgumentValidation>

	---	</ArgumentValidation>


	--- <Body>
	--- <Update rows="1">
	set	@TableName = 'eeiuser.acctg_csm_base_part_attributes'
		
	update
		eeiuser.acctg_csm_base_part_attributes
	set
		verified_eop = @VerifiedEop
	,	verified_eop_date = @VerifiedEopDate
	where
		base_part = @BasePart
		and release_id = (select [dbo].[fn_ReturnLatestCSMRelease] ('CSM'))

	select 
		@RowCount = @@Rowcount
				
	if	@RowCount != 1 begin
		set	@Result = 999999
		RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	end
	--- </Update>	
	

	if ( (
			select 
				count(*)
			from
				eeiuser.BasePartCloseouts bpc
			where
				bpc.BasePart = @BasePart) = 0) begin

		--- <Insert rows="1">
		set	@TableName = 'eeiuser.BasePartCloseouts'

		insert eeiuser.BasePartCloseouts
		(
			BasePart
		,	SchedulerResponsible
		,	RfMpsLink
		,	SchedulingTeamComments
		,	MaterialsComments
		,	ShipToLocation
		,	FgInventoryAfterBuildout
		,	CostEach
		,	ExcessFgAfterBuildout
		,	ExcessRmAfterBuildout
		,	ProgramExposure
		,	DateToSendCoLetter
		,	ObsolescenceCost
		,	RowCreateUser
		)
		values
		(
			@BasePart 
		,	@SchedulerResponsible 
		,	@RfMpsLink 
		,	@SchedulingTeamComments
		,	@MaterialsComments 
		,	@ShipToLocation 
		,	@FgInventoryAfterBuildout 
		,	@CostEach 
		,	@ExcessFgAfterBuildout 
		,	@ExcessRmAfterBuildout 
		,	@ProgramExposure 
		,	@DateToSendCoLetter 
		,	@ObsolescenceCost
		,	@UserCode
		)

		select
			@RowCount = @@Rowcount
				
		if	@RowCount != 1 begin
			set	@Result = 999999
			RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		end
		--- </Insert>

	end
	else begin

		--- <Update rows="1">
		set	@TableName = 'eeiuser.BasePartCloseouts'

		update
			eeiuser.BasePartCloseouts
		set
			SchedulerResponsible = @SchedulerResponsible
		,	RfMpsLink = @RfMpsLink
		,	SchedulingTeamComments = @SchedulingTeamComments
		,	MaterialsComments = @MaterialsComments
		,	ShipToLocation = @ShipToLocation
		,	FgInventoryAfterBuildout = @FgInventoryAfterBuildout
		,	CostEach = @CostEach
		,	ExcessFgAfterBuildout = @ExcessFgAfterBuildout
		,	ExcessRmAfterBuildout = @ExcessRmAfterBuildout
		,	ProgramExposure = @ProgramExposure
		,	DateToSendCoLetter = @DateToSendCoLetter
		,	ObsolescenceCost = @ObsolescenceCost
		,	RowModifiedUser = @UserCode
		where
			BasePart = @BasePart

		select 
			@RowCount = @@Rowcount
				
		if	@RowCount != 1 begin
			set	@Result = 999999
			RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		end
	--- </Update>	
	end
	--- </Body>


	--- <SP End Logging>
	update
		uc
	set	EndDT = getdate()
	,	OutArguments = 
			'@TranDT = ' + coalesce(convert(varchar, @TranDT, 121), '<null>')
			+ ', @Result = ' + coalesce(convert(varchar, @Result), '<null>')
	from
		FXSYS.USP_Calls uc
	where
		uc.RowID = @LogID
	--- </SP End Logging>


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
	,	@xact_state int
	
	select
		@errorSeverity = error_severity()
	,	@errorState = error_state ()
	,	@errorMessage = error_message()
	,	@xact_state = xact_state()

	execute FXSYS.usp_PrintError

	if	@xact_state = -1 begin 
		rollback
		execute FXSYS.usp_LogError
	end
	if	@xact_state = 1 and @TranCount = 0 begin
		rollback
		execute FXSYS.usp_LogError
	end
	if	@xact_state = 1 and @TranCount > 0 begin
		rollback transaction @ProcName
		execute FXSYS.usp_LogError
	end

	raiserror(@errorMessage, @errorSeverity, @errorState)
end catch


---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>


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
	@Param1 [scalar_data_type]

set	@Param1 = [test_value]

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_Admin_LoginUser
	@Param1 = @Param1
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
