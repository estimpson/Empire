
/*
Create Procedure.MONITOR.dbo.usp_CreateRma_GetSerialsFromPartDest.sql
*/

use MONITOR
go

if	objectproperty(object_id('dbo.usp_CreateRma_GetSerialsFromPartDest'), 'IsProcedure') = 1 begin
	drop procedure dbo.usp_CreateRma_GetSerialsFromPartDest
end
go

create procedure dbo.usp_CreateRma_GetSerialsFromPartDest
	@OperatorCode varchar(5)
,	@Destination varchar(20)
,	@PartNumber varchar(25)
,	@RequiredQuantity numeric(20,6)
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
/*  Shipped inventory quantity must be equal or greater than the RMA amount.  */
if ( (
		select
			sum(at.quantity)
		from
			dbo.shipper s
			join dbo.shipper_detail sd
				on sd.shipper = s.id
			join dbo.audit_trail at
				on at.shipper = convert(varchar(20), s.id)
		where
			at.part = @PartNumber
			and at.type = 'S'
			and s.destination = @Destination ) < @RequiredQuantity ) begin

	set	@Result = 999999
	RAISERROR ('There is not enough shipped inventory to cover the total RMA quantity.  Procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
	
end			
---	</ArgumentValidation>


--- <Body>
declare
	@Serial int
,	@AllocatedQty numeric(20,6)

select top(1)
	@Serial = at.serial
,	@AllocatedQty = 
		case
			when at.quantity > @RequiredQuantity then @RequiredQuantity
			else at.quantity
		end 
from
	dbo.shipper s
	join dbo.shipper_detail sd
		on sd.shipper = s.id
	join dbo.audit_trail at
		on at.shipper = convert(varchar(20), s.id)
where
	at.part = @PartNumber
	and at.type = 'S'
	and s.destination = @Destination
order by
	at.date_stamp desc
	

insert into dbo.SerialsQuantitiesToAutoRMA_RTV
(
	Serial
,	Quantity
)
select
	@Serial
,	@AllocatedQty
		
select
	@RequiredQuantity = @RequiredQuantity - @AllocatedQty


while (@RequiredQuantity > 0) begin

	select top(1)
		@Serial = at.serial
	,	@AllocatedQty = 
			case
				when at.quantity > @RequiredQuantity then @RequiredQuantity
				else at.quantity
			end 
	from
		dbo.shipper s
		join dbo.shipper_detail sd
			on sd.shipper = s.id
		join dbo.audit_trail at
			on at.shipper = convert(varchar(20), s.id)
	where
		at.part = @PartNumber
		and at.type = 'S'
		and at.serial < @Serial
		and s.destination = @Destination
	order by
		at.date_stamp desc
	
	
	insert into dbo.SerialsQuantitiesToAutoRMA_RTV
	(
		Serial
	,	Quantity
	)
	select
		@Serial
	,	@AllocatedQty
	
	select
		@RequiredQuantity = @RequiredQuantity - @AllocatedQty
		
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
