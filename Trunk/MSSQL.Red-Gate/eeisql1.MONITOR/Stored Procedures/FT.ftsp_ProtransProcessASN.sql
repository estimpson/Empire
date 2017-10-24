SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [FT].[ftsp_ProtransProcessASN]
(	@ProTransOrderNo varchar (15) = null,
	@Result int = 0 output)
/*
Example:
use MONITOR
begin transaction
execute	FT.ftsp_ProtransProcessASN
select	*
from	FT.vwProTransASNUnprocessed
select	*
from	FT.ProTransASN
where	OrderNo = 483014
commit

update	FT.ProTransASN
set	ShipToId = '36126'
where	OrderNo = 485504

update	FT.ProTransASN
set	Status = -1
where	OrderNo in (486051)

select	*
from	audit_trail
where	serial = 4043646

select	*
from	audit_trail
where	shipper = '30096'

select	*
from	shipper
where	id = 30067

:End Example
*/
as

set nocount on
set	@Result = 999999

--<Tran Required=Yes AutoCreate=Yes>
declare	@TranCount smallint
set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin transaction ProtransProcessASN
end
save transaction ProtransProcessASN
--</Tran>

--<Error Handling>
declare	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,	@RowCount integer
--</Error Handling>

declare	@ShipTo varchar (20)

declare ShipTos cursor local for
select	ProTransASNUnprocessed.OrderNo,
	ProTransASNUnprocessed.ShipTo
from	FT.vwProTransASNUnprocessed ProTransASNUnprocessed
	join order_header on order_header.order_no =
		(	select	max (order_no)
			from	order_header
			where	ProTransASNUnprocessed.InvPart = order_header.blanket_part and
				ProTransASNUnprocessed.ShipTo = order_header.destination)
	join object on order_header.blanket_part = object.part and
		(	ProTransASNUnprocessed.InvSerial = object.serial or
			ProTransASNUnprocessed.InvSerial = object.parent_serial)
where	ProTransASNUnprocessed.OrderNo = isnull (@ProTransOrderNo, ProTransASNUnprocessed.OrderNo)
group by
	ProTransASNUnprocessed.OrderNo,
	ProTransASNUnprocessed.ShipTo

open	ShipTos

fetch	ShipTos
into	@ProTransOrderNo,
	@ShipTo

while	@@fetch_status = 0 begin

	execute	@ProcReturn = FT.ftsp_ProtransProcessASN_Destination
		@Operator = 'Mon',
		@ProTransOrderNo = @ProTransOrderNo,
		@CustomerDestination = @ShipTo,
		@InvoiceShipperID = 0,
		@Result = @ProcResult output

	fetch	ShipTos
	into	@ProTransOrderNo,
		@ShipTo
end

close	ShipTos
deallocate
	ShipTos

--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction ProtransProcessASN
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	III.	Success.
set	@Result = 0
return	@Result


GO
