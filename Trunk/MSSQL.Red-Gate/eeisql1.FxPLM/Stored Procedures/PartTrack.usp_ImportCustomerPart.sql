SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [PartTrack].[usp_ImportCustomerPart]
	@UserCode varchar(25)
,	@CustomerCode char(3)
,	@BasePart char(7)
,	@CustomerPartNumber varchar(100)
,	@VehicleOEM varchar(100)
,	@VehicleProgram varchar(100)
,	@VehicleApplication varchar(100)
,	@ModelYear int
,	@Description varchar(max)
,	@ReplacedByPart char(7)
,	@ReplacesPart char(7)
,	@RelatedPart char(7)
,	@CustomerRFQNumber varchar(100)
,	@SOP datetime
,	@EAU int
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
		@cDebug int = @Debug + 2 -- Proc level

	if	@Debug & 0x01 = 0x01 begin
		declare
			@TicDT datetime = getdate()
		,	@TocDT datetime
		,	@TimeDiff varchar(max)
		,	@TocMsg varchar(max)
		,	@cDebugMsg varchar(max)

		set @DebugMsg = replicate(' -', (@Debug & 0x3E) / 2) + 'Start ' + user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)
	end
	--- </TIC>

	--- <SP Begin Logging>
	declare
		@LogID int

	insert
		MONITOR.FXSYS.USP_Calls
	(	USP_Name
	,	BeginDT
	,	InArguments
	)
	select
		USP_Name = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)
	,	BeginDT = getdate()
	,	InArguments =
			'@CustomerCode' + coalesce(@CustomerCode, '<null>')
			+ ', @TranDT = ' + coalesce(convert(varchar, @TranDT, 121), '<null>')
			+ ', @Result = ' + coalesce(convert(varchar, @Result), '<null>')
			+ ', @Debug = ' + coalesce(convert(varchar, @Debug), '<null>')
			+ ', @DebugMsg = ' + coalesce('''' + @DebugMsg + '''', '<null>')

	set	@LogID = scope_identity()
	--- </SP Begin Logging>

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

	/*	Record initial transaction count. */
	declare
		@TranCount smallint

	set	@TranCount = @@TranCount

	begin try

		---	<ArgumentValidation>
		/*  Base part does not already exist (for any customer)  */
		if exists (
				select
					1
				from
					PartTrack.CustomerParts cp
				where	
					cp.BasePart = @BasePart ) begin

			set	@Result = 999999
			RAISERROR ('Part %s has already been imported.', 16, 1, @BasePart)
			--return
		end
		---	</ArgumentValidation>


		--- <Body>
		--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
		if	@TranCount = 0 begin
			begin tran @ProcName
		end
		else begin
			save tran @ProcName
		end
		set	@TranDT = coalesce(@TranDT, GetDate())
		--- </Tran>

		--- <Body>
		/*	Insert customer part. */
		set @TocMsg = 'Insert customer part'
		begin
			--- <Insert rows="1">
			set	@TableName = 'PartTrack.CustomerParts'
				
			insert PartTrack.CustomerParts
			(
				CustomerCode
			,	BasePart
			,	CustomerPartNumber
			,	VehicleOEM
			,	VehicleProgram
			,	VehicleApplication
			,	ModelYear
			,	[Description]
			,	ReplacedByBasePart
			,	ReplacesBasePart
			,	RelatedBasePart
			,	CustomerRFQNumber
			,	SOP
			,	EAU
			,	RowModifiedDT
			,	RowModifiedUser
			)
			values
			(
				@CustomerCode
			,	@BasePart
			,	@CustomerPartNumber
			,	@VehicleOEM
			,	@VehicleProgram
			,	@VehicleApplication
			,	@ModelYear
			,	@Description
			,	@ReplacedByPart
			,	@ReplacesPart
			,	@RelatedPart
			,	@CustomerRFQNumber
			,	@SOP
			,	@EAU
			,	@TranDT
			,	@UserCode
			)

			select
				@Error = @@error
			,	@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			end
			if	@RowCount != 1 begin
				set	@Result = 999999
				RAISERROR ('Error inserting into %s in procedure %s.  Rows Inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
			end
			--- </Insert>


			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
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
				'@TranDT = ' + coalesce(convert(varchar, @TranDT, 121), '<null>')
				+ ', @Result = ' + coalesce(convert(varchar, @Result), '<null>')
		from
			MONITOR.FXSYS.USP_Calls uc
		where
			uc.RowID = @LogID
		--- </SP End Logging>

		--- <TIC/TOC END>
		if	@Debug & 0x3F = 0x01 begin
			set @DebugMsg = @DebugMsg + char(13) + char(10)
			print @DebugMsg
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
		,	@xact_state int
	
		select
			@errorSeverity = error_severity()
		,	@errorState = error_state ()
		,	@errorMessage = error_message()
		,	@xact_state = xact_state()

		execute MONITOR.FXSYS.usp_PrintError

		if	@xact_state = -1 begin 
			rollback
			execute MONITOR.FXSYS.usp_LogError
		end
		if	@xact_state = 1 and @TranCount = 0 begin
			rollback
			execute MONITOR.FXSYS.usp_LogError
		end
		if	@xact_state = 1 and @TranCount > 0 begin
			rollback transaction @ProcName
			execute MONITOR.FXSYS.usp_LogError
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
,	@ParentHeirarchID hierarchyid

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = PartTrack.usp_SetCustomerPart
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
