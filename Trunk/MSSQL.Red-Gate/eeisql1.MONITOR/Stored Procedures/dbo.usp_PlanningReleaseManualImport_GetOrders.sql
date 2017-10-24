SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[usp_PlanningReleaseManualImport_GetOrders]
	@Destination varchar(50)
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
/*  Destination is valid:  */
if not exists (
		select
			1
		from
			dbo.destination d
		where
			d.destination = @Destination ) begin
	
	set	@Result = 60000
	RAISERROR ('Destination is not valid.', 16, 1)
	rollback tran @ProcName
	return		
end		
---	</ArgumentValidation>


--- <Body>
select
	oh.order_no as OrderNo
,	oh.customer_part as CustomerPart
,	oh.blanket_part as BlanketPart
,	coalesce(oh.model_year, '') as ModelYear
from
	dbo.order_header oh
where
	oh.destination = @Destination
	and oh.status = 'A'
order by
	oh.customer_part
,	oh.blanket_part
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
