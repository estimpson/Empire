SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_ST_SalesLeadLog_SearchForSalesLeads]
	@CombinedLightingId int
,	@TranDT datetime = null out
,	@Result integer = null  out
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDIStanley.usp_Test
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
/*  For the selected sales opportunity (CombinedLightingId), has a sales lead been created?  */
if ( (
		select	
			coalesce(h.SalesPersonCode, '')
		from
			eeiuser.ST_LightingStudy_2016 sls
			left join eeiuser.ST_SalesLeadLog_Header h
				on h.CombinedLightingId = sls.ID
		where
			sls.ID = @CombinedLightingId ) <> '' ) begin

	set	@Result = 100600
	RAISERROR ('A sales lead has already been created for this Customer/Program/Application.', 16, 1)
	rollback tran @ProcName
	return
end
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
GO
