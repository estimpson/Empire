SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[usp_CreateRma_ImportSerialsQuantitiesByOperator]
	@OperatorCode varchar(5)
,	@Serial int
,	@Quantity numeric(20,6)
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
/*  Serials are not in use by another RMA / RTV operator  */
if exists (
		select
			1
		from
			dbo.SerialsQuantitiesToAutoRMA_RTV sq
		where
			sq.Serial = @Serial
			and sq.OperatorCode <> @OperatorCode ) begin

	set	@Result = 999999
	RAISERROR ('Serial %d is currently in use for RMA / RTV by another operator.  Procedure %s.', 16, 1, @Serial, @ProcName)
	rollback tran @ProcName
	return		
end
---	</ArgumentValidation>

--- <Body>
--- <Insert rows="1">
set	@TableName = 'dbo.SerialsQuantitiesToAutoRMA_RTV'
	
insert dbo.SerialsQuantitiesToAutoRMA_RTV
( 
	Serial
,	Quantity
,	OperatorCode
)
select	
	@Serial
,	@Quantity
,	@OperatorCode

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount = 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Insert>	
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
