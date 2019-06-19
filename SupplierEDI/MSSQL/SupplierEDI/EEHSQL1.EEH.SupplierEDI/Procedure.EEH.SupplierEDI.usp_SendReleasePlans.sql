
/*
Create Procedure.EEH.SupplierEDI.usp_SendReleasePlans.sql
*/

use EEH
go

if	objectproperty(object_id('SupplierEDI.usp_SendReleasePlans'), 'IsProcedure') = 1 begin
	drop procedure SupplierEDI.usp_SendReleasePlans
end
go

create procedure SupplierEDI.usp_SendReleasePlans
	@TradingPartnerList varchar(max) = null    -- specify a single trading partner, list of trading partners, or null for all trading partners
,	@PurchaseOrderList varchar(max) = null     -- specify a single purchase order, list of purchase orders, or null for all purchase orders
,	@TestMailBox bit = 1
,	@TranDT datetime = null out
,	@Result integer = null out
,	@Debug int = 0
,	@DebugMsg varchar(max) = null out
with encryption
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
	,	InArguments = convert
			(	varchar(max)
			,	(	select
						[@TradingPartnerList] = @TradingPartnerList
					,	[@PurchaseOrderList] = @PurchaseOrderList
					,	[@TranDT] = @TranDT
					,	[@Result] = @Result
					,	[@Debug] = @Debug
					,	[@DebugMsg] = @DebugMsg
					for xml raw			
				)
			)

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
		/*	Conditionally create trading partner list from edi vendor send list table. */
		set @TocMsg = 'Conditionally create trading partner list from edi vendor send list table'
		if @TradingPartnerList = 'LOADFROMTABLE' begin
			declare @Listado varchar(max)

			set @Listado = null

			select
				@Listado = coalesce(@Listado + ',' + Xdata.vendor, Xdata.vendor)
			from
				(	select
						evsl.vendor
					from
						dbo.edi_vendor_send_list evsl
				) Xdata

			set @TradingPartnerList = @Listado

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
		
		/*	Get the list of files to generate (grouped by Trading Partner Code). */
		set @TocMsg = 'Get the list of files to generate (grouped by Trading Partner Code)'
		begin
			declare
				@fileList table
			(	TradingPartnerCode varchar(50)
			,	FunctionName varchar(255)
			,	PurchaseOrderList varchar(max)
			)

			insert
				@fileList
			(	TradingPartnerCode
			,	FunctionName
			,	PurchaseOrderList
			)
			select
				po.TradingPartnerCode
			,	po.FunctionName
			,	PurchaseOrderList = FT.ToList(po.PurchaseOrderNumber)
			from
				(	select
						top(100000)
						*
					from
						SupplierEDI.PurchaseOrders po
					order by
						po.PurchaseOrderNumber asc
				) po
			where
				(	po.TradingPartnerCode in
					(	select
							ltrim(rtrim(fsstr.Value))
						from
							dbo.fn_SplitStringToRows(@TradingPartnerList, ',') fsstr
					)
					or
					@TradingPartnerList is null
				)
				and
				(	po.PurchaseOrderNumber in
					(	select
							ltrim(rtrim(fsstr.Value))
						from
							dbo.fn_SplitStringToRows(@PurchaseOrderList, ',') fsstr
					)
					or
					@PurchaseOrderList is null
				)
				and
				po.FunctionName is not null
			group by
				po.TradingPartnerCode
			,	po.FunctionName

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

		/*	Loop through and generate one file per trading partner. */
		set @TocMsg = 'Loop through and generate one file per trading partner'
		begin
			declare files cursor local read_only for
			select
				fl.TradingPartnerCode
			,	fl.FunctionName
			,	fl.PurchaseOrderList
			from
				@fileList fl

			open files

			while
				1 = 1 begin

				declare
					@tradingParnterCode varchar(50)
				,	@functionName varchar(255)
				,	@purchaseOrders varchar(max)

				fetch
					files
				into
					@tradingParnterCode
				,	@functionName
				,	@purchaseOrders

				if	@@fetch_status != 0 begin
					break
				end

				/*	Generate XML Release Plan. */
				declare
					@xmlReleasePlan xml

				declare
					@Statement nvarchar(max) = '
select
	@XMLRaw = convert(nvarchar(max), ' + @functionName + '(''' + @tradingParnterCode + ''', ''' + convert(varchar(max), @purchaseOrders) + ''', ''05'', 1))
'
				,	@XMLRaw nvarchar(max)

				execute
					sys.sp_executesql
					@stmt = @Statement
				,	@parameters = N'@XMLRaw nvarchar(max) out'
				,	@XMLRaw = @XMLRaw out

				set @xmlReleasePlan = convert(xml, @XMLRaw)

				/*	Create files for the release plans. */
				declare
					@binXmlData varbinary(max) = convert(varbinary(max), @xmlReleasePlan)

				--- <Call>	
				set	@CallProcName = 'FxEDI.RAWEDIDATA_FS.usp_XMLReleasePlan_CreateOutboundFile'
				
				execute @ProcReturn = FxEDI.RAWEDIDATA_FS.usp_XMLReleasePlan_CreateOutboundFile
					@TradingPartner = @tradingParnterCode
				,	@PurchaseOrderList = @purchaseOrders
				,	@FunctionName = @functionName
				,	@XMLData = @binXmlData
				,	@TestMailBox = @TestMailBox
				,	@FileGenerationTime = @TranDT
				,	@TranDT = @TranDT out
				,	@Result = @Result out
				
				set	@Error = @@Error
				if	@Error != 0 begin
					set	@Result = 900501
					RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
				end
				if	@ProcReturn != 0 begin
					set	@Result = 900502
					RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
				end
				if	@ProcResult != 0 begin
					set	@Result = 900502
					RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
				end
				--- </Call>
				
				print @Statement
				print @tradingParnterCode
				print @functionName
				print @purchaseOrders
				print len(convert(varchar(max), @xmlReleasePlan))
			end

			close
				files

			deallocate
				files

			select
				*
			from
				FxEDI.RAWEDIDATA_FS.udf_DIR('\SupplierEDI\Outbound\Staging', 1)

			/*	Send EDI to the test mailbox. */
			if	exists
				(	select
						*
					from
						@fileList
				)
				and @TestMailBox = 1 begin

				--- <Call>	
				set @CallProcName = 'FxEdi.FTP.usp_SendSupplierEDI_TestMailBox'
				execute
					@ProcReturn = FxEDI.FTP.usp_SendSupplierEDI_TestMailBox
					@TranDT = @TranDT out
				,	@Result = @ProcResult out

				set @Error = @@Error
				if	@Error != 0 begin
					set @Result = 900501
					raiserror ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
				end
				if	@ProcReturn != 0 begin
					set @Result = 900502
					raiserror ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
				end
				if	@ProcResult != 0 begin
					set @Result = 900502
					raiserror ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
				end
				--- </Call>
			end

			/*	Send EDI to the production mailbox. */
			if	exists
				(	select
						*
					from
						@fileList
				)
				and @TestMailBox = 0 begin

				--- <Call>	
				set @CallProcName = 'FxEdi.FTP.usp_SendSupplierEDI'
				execute
					@ProcReturn = FxEDI.FTP.usp_SendSupplierEDI
					@TranDT = @TranDT out
				,	@Result = @ProcResult out

				set @Error = @@Error
				if	@Error != 0 begin
					set @Result = 900501
					raiserror ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
				end
				if	@ProcReturn != 0 begin
					set @Result = 900502
					raiserror ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
				end
				if	@ProcResult != 0 begin
					set @Result = 900502
					raiserror ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
				end
				--- </Call>
			end

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

		--- <SP End Logging>
		update
			uc
		set	EndDT = getdate()
		,	OutArguments = convert
				(	varchar(max)
				,	(	select
							[@TranDT] = @TranDT
						,	[@Result] = @Result
						,	[@DebugMsg] = @DebugMsg
						for xml raw			
					)
				)
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
	@TradingPartnerList varchar(max) = 'ARROW, DELFINGEN'    -- specify a single trading partner, list of trading partners, or null for all trading partners
,	@PurchaseOrderList varchar(max) = null -- '31461, 31482, 31524, 31530, 31912, 31993, 31995, 32093, 32119'     -- specify a single purchase order, list of purchase orders, or null for all purchase orders

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = SupplierEDI.usp_SendReleasePlans
	@TradingPartnerList = @TradingPartnerList
,	@PurchaseOrderList = @PurchaseOrderList
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

