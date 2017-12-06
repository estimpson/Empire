SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [PFS].[usp_Variance_InsertPfsFromRaw]
	@OperatorCode varchar(5)
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
	RAISERROR ('Invalid operator code.  Procedure: %s.', 16, 1, @ProcName)
	rollback tran @ProcName
	return
end

/*  No duplicate data  */
if exists (
		select
			v.ID
		from
			PFS.Variance v
			join PFS.VarianceRawDataTemp t
				on convert(int, t.[Load]) = v.[Load] ) begin

	set	@Result = 999991
	RAISERROR ('One or more records exist in the database with the same load number.  Procedure: %s.', 16, 1, @ProcName)
	rollback tran @ProcName
	return
end		
---	</ArgumentValidation>


--- <Body>
--- <Insert rows="1+">	
set	@TableName = 'PFS.Variance'
insert into PFS.Variance
(
	[Load]
,	Pickup
,	Shipper
,	City
,	Consignee
,	ConsigneeCity
,	Pieces
,	[Weight]
,	Class
,	Carrier
,	Billed
,	CostPerPound
,	InvDate
,	PoRef
,	ProNumber
,	OperatorCode
,	RowCreateDT
)
select
	[Load] = convert(int, t.[Load])
,	Pickup = convert(datetime, nullif(t.Pickup, '')) 
,	Shipper = t.Shipper
,	City = t.City
,	Consignee = t.Consignee
,	ConsigneeCity = t.ConsigneeCity
,	Pieces = convert(int, t.Pieces)
,	[Weight] = convert(int, t.[Weight])
,	Class = convert(decimal(12,6), nullif(t.Class, ''))
,	Carrier = t.Carrier
,	Billed = convert(decimal(12,6), nullif(substring(t.Billed, 2, 20), '')) 
,	CostPerPound = convert(decimal(12,6), nullif(t.CostPerPound, ''))
,	InvDate = convert(datetime, nullif(t.InvDate, '')) 
,	PoRef = t.PoRef
,	ProNumber = convert(bigint, t.ProNumber)
,	OperatorCode = @OperatorCode
,	RowCreateDT = @TranDT
from
	PFS.VarianceRawDataTemp t


select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error <> 0 begin
	set	@Result = 999993
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount < 1 begin
	set	@Result = 999994
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1+.', 16, 1, @TableName, @ProcName, @RowCount)
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
