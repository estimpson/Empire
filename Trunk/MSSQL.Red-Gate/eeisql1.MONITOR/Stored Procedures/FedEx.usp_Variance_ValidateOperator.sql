SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [FedEx].[usp_Variance_ValidateOperator]
	@OperatorCode varchar(5)
,	@Password varchar(5)
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
/*  Valid operator  */
if not exists (
		select
			1
		from
			dbo.employee e
		where
			e.operator_code = @OperatorCode) begin
	
	set	@Result = 999990
	RAISERROR ('Invalid operator code.', 16, 1)
	rollback tran @ProcName
	return
end

/*  Valid password  */
if not exists (
		select
			1
		from
			dbo.employee e
		where
			e.operator_code = @OperatorCode
			and e.password = @Password) begin
	
	set	@Result = 999990
	RAISERROR ('Invalid password for operator code %s', 16, 1, @OperatorCode)
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
