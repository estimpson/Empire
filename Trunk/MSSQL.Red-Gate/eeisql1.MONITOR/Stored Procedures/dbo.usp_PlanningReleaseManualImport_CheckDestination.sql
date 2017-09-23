SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[usp_PlanningReleaseManualImport_CheckDestination]
	@Customer varchar(50)
,	@Destination varchar(50)
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDILiteTek.usp_Test
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
-- The destination found in the import spreadsheet is tied to the selected customer in the app
if not exists (
		select
			1
		from
			dbo.destination d
		where
			d.customer = @Customer
			and d.destination = @Destination) begin
	
	set	@Result = 100900
	RAISERROR ('The destination found in the spreadsheet (%s) is not tied to customer %s.', 16, 1, @Destination, @Customer)
	rollback tran @ProcName
	return
end
---	</ArgumentValidation>


--- <Body>

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
