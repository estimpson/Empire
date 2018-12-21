SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [FxPVQ].[usp_GetPartVendorQuotes]
as
begin

	--set xact_abort on
	set nocount on

	--- <SP Begin Logging>
	declare
		@ProcName sysname = object_name(@@procid)

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
--	,	InArguments = convert
--			(	varchar(max)
--			,	(	select
--						[@QuoteNumber] = @QuoteNumber
--					for xml raw			
--				)
--			)
,	InArguments = ''

	set	@LogID = scope_identity()
	--- </SP Begin Logging>

	/*	Record initial transaction count. */
	declare
		@TranCount smallint

	set	@TranCount = @@TranCount

	begin try
		--- <Body>
		begin
			select
				pvq.RowID	
			,	pvq.VendorCode
			,	pvq.PartCode
			,	pvq.[Oem]
			,	pvq.EffectiveDate
			,	pvq.EndDate
			,	pvq.Price
			,	pvq.QuoteFileName
			from
				FxPVQ.PartVendorQuotes pvq
			order by
				pvq.VendorCode asc
			,	pvq.PartCode asc
		end
		--- </Body>

		--- <SP End Logging>
		update
			uc
		set	EndDT = getdate()
		from
			FXSYS.USP_Calls uc
		where
			uc.RowID = @LogID
		--- </SP End Logging>
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

--declare
--	@FinishedPart varchar(25) = 'ALC0598-HC02'
--,	@ParentHeirarchID hierarchyid

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn =  FxPVQ.usp_GetPartVendorQuotes
--	@FinishedPart = @FinishedPart
--,	@ParentHeirarchID = @ParentHeirarchID
--,	@TranDT = @TranDT out
	@TranDT = @TranDT out
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
