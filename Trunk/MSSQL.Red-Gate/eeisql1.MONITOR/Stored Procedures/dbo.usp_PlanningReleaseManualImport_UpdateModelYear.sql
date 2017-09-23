SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [dbo].[usp_PlanningReleaseManualImport_UpdateModelYear]
	@OrderNo int
,	@ModelYear char(1) = null
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
/*  Only one order can be set up for planning release import for a part / dest combination  */
if (@ModelYear is not null) begin

	declare
		@ActiveOrderNo int

	select
		@ActiveOrderNo = max(oh.order_no)
	from
		dbo.order_header oh
		join (
				select
					oh1.destination
				,	oh1.customer_part
				from
					dbo.order_header oh1
				where
					oh1.order_no = @OrderNo ) as currentOrder
			on currentOrder.destination = oh.destination
			and currentOrder.customer_part = oh.customer_part
	where
		oh.status = 'A'
		and coalesce(oh.model_year, '') = 'P'
		and oh.order_no <> @OrderNo
			
	if (@ActiveOrderNo is not null) begin
		set	@Result = 60001
		RAISERROR ('%d has model year set to P.  Only one active order can be set up for planning release import per part / destination.', 16, 1, @ActiveOrderNo)
		rollback tran @ProcName
		return
	end
	
end
---	</ArgumentValidation>


--- <Body>
--- <Update rows="1">
set	@TableName = 'dbo.order_header'

update
	oh
set
	oh.model_year = @ModelYear
from
	dbo.order_header oh
where
	oh.order_no = @OrderNo

	
select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount = 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Rows updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Update rows="1">
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
