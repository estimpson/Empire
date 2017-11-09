SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[usp_CreateRma_GenerateRmaNumber]
	@OperatorCode varchar(5)
,	@RmaNumber varchar(20) = null out
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
if not exists (
		select
			1
		from
			dbo.employee e
		where	
			e.operator_code = @OperatorCode ) begin

	set	@Result = 999999
	RAISERROR ('Invalid operator code.  Procedure %s', 16, 1, @ProcName)
	rollback tran @ProcName
	return
end
---	</ArgumentValidation>


--- <Body>
declare
	@lastRma varchar(20)

select
	@lastRma = rmn.RmaNumber
from
	dbo.RmaMaintenance_GeneratedRmaNumbers rmn
where
	RowCreateDT = (	
		select 
			max(rmn2.RowCreateDT)
		from 
			dbo.RmaMaintenance_GeneratedRmaNumbers rmn2 )

declare
	@currentYear char(2)
,	@rmaYear char(2)
,	@rmaNumberValue int

set @currentYear = substring(convert(varchar, year(getdate())), 3, 2)
set @rmaYear = substring(@lastRma, 4, 2)


if (convert(int, @currentYear) > convert(int, @rmaYear)) begin

	set @RmaNumber = 'RMA' + @currentYear + '-1000'
		
end
else begin

	set @rmaNumberValue = convert(int, substring(@lastRma, 7, 4)) + 1
	set @RmaNumber = 'RMA' + @currentYear + '-' + convert(varchar(5), @rmaNumberValue)

end
		
--- <Insert rows="1">
set	@TableName = 'dbo.RmaMaintenance_GeneratedRmaNumbers'
	
insert dbo.RmaMaintenance_GeneratedRmaNumbers
( 
	RmaNumber
,	RowCreateUser
,	RowModifiedUser
)
values
(
	@RmaNumber
,	@OperatorCode
,	@OperatorCode
)

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount != 1 begin
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
