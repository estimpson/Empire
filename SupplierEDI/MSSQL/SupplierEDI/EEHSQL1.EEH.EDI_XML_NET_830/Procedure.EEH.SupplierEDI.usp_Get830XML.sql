
/*
Create Procedure.EEH.SupplierEDI.usp_Get830XML.sql
*/

use EEH
go

if	objectproperty(object_id('SupplierEDI.usp_Get830XML'), 'IsProcedure') = 1 begin
	drop procedure SupplierEDI.usp_Get830XML
end
go

create procedure SupplierEDI.usp_Get830XML
	@TradingPartnerCode varchar(12)
,	@PurchaseOrderList varchar(max)
,	@XMLGet830_FunctionName sysname
,	@PurposeCode char(2) = '00'
,	@Complete bit = 0
,	@830XML xml = null out
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
		FXSYS.USP_Calls
	(	USP_Name
	,	BeginDT
	,	InArguments
	)
	select
		USP_Name = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)
	,	BeginDT = getdate()
	,	InArguments =
			'@TradingPartnerCode = ' + coalesce('''' + @TradingPartnerCode + '''', '<null>')
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

	set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. SupplierEDI.usp_Test
	--- </Error Handling>

	/*	Record initial transaction count. */
	declare
		@TranCount smallint

	set	@TranCount = @@TranCount

	begin try

		---	<ArgumentValidation>

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
		/*	Do something. */
		set @TocMsg = 'Do something'
		begin
			/* statements */
			if	@XMLGet830_FunctionName is null begin

				select
					@XMLGet830_FunctionName = xrpdrf.FunctionName
				from
					SupplierEDI.XML_ReleasePlanDataRootFunctions xrpdrf
					join SupplierEDI.TradingPartnerOverlayGroups tpog
						on tpog.OverlayGroup = xrpdrf.OverlayGroup
				where
					tpog.TradingPartnerCode = @TradingPartnerCode
			end

			declare
				@Statement nvarchar(max) = '
			select
				@XMLOutput = convert(nvarchar(max), ' + @XMLGet830_FunctionName + '(''' + @TradingPartnerCode + ''', ' +
					case
						when @PurchaseOrderList is not null then '''' + @PurchaseOrderList + ''''
						else 'default'
					end + ', ''' + @PurposeCode + ''', ' + convert(char(1), @Complete) + '))
			'
			,	@XMLOutput nvarchar(max)

			execute
				sys.sp_executesql
				@stmt = @Statement
			,	@parameters = N'@XMLOutput nvarchar(max) output'
			,	@XMLOutput = @XMLOutput out

			set	@830XML = convert(xml, @XMLOutput)

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
			FXSYS.USP_Calls uc
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
	@ProcReturn = SupplierEDI.usp_Get830XML
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
go

declare
	@830XML xml

execute
	SupplierEDI.usp_Get830XML
	@TradingPartnerCode = 'PSG'
,	@PurchaseOrderList = '52721, 49600'
,	@XMLGet830_FunctionName = null
,	@PurposeCode = '05'
,	@Complete = 0
,	@830XML = @830XML out

select
	@830XML