SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	procedure [dbo].[ftsp_ModifyCustomerCode] (@OldCustomerCode varchar(15), @OldDestinationCode varchar(15), @NewCustomerCode varchar(15), @NewDestinationCode varchar(15), @FirstInvoiceNumber Int)
as
begin

/* begin transaction 
	
	exec dbo.ftsp_ModifyCustomerCode 'ALCES3', 'ALCES3' , 'ES3ALCBRZ', 'ES3ALCBRZ', 53049 
	
	rollback transaction
*/

if exists ( select 1 from customer where customer = @NewCustomerCode) and exists (select 1 from dbo.destination where destination = @NewDestinationCode and customer = @NewCustomerCode)


Begin
--Get List of Orders to Update

declare	@ShippersToUpdate table
			( shipperID Int )

declare	@OrdersToUpdate table
			( OrderNo Int )
			
insert	
	@ShippersToUpdate
select
	id 
from
	dbo.shipper
where
	invoice_number>= @FirstInvoiceNumber and
	customer = @OldCustomerCode


insert
	@OrdersToUpdate
select
	order_no
from
	dbo.shipper_detail
where
	shipper in ( select ShipperID from @ShippersToUpdate )

--Update Sales Orders


Update		
	order_header
set
	customer = @NewCustomerCode
where
	customer = @OldCustomerCode
and
	order_no in (select OrderNo from @OrdersToUpdate)
	
Update		
	order_header
set
	destination = @NewDestinationCode
where
	destination = @OldDestinationCode
and
	order_no in (select OrderNo from @OrdersToUpdate)

	
update
	order_detail
set	
	destination = @NewDestinationCode
where
	destination = @OldDestinationCode
and
	order_no in (select OrderNo from @OrdersToUpdate)	
	
	
--Update Sales History

update
	dbo.shipper
set
	customer = @NewCustomerCode
where
	id in (select shipperId from @ShippersToUpdate)


update
	dbo.shipper
set
	destination = @NewDestinationCode
where
	id in (select shipperId from @ShippersToUpdate)


--Update Inventory Staged To shipper

update
	dbo.object
set
	destination = @NewDestinationCode
where
	object.shipper in (select shipperId from @ShippersToUpdate)
	


--update Inventory History
update
	dbo.audit_trail
set
	customer = @NewCustomerCode,
	destination = @NewDestinationCode,
	to_loc = @NewDestinationCode,
	gl_account = (select min(right(hdr_ledger_account_code,2)) from dbo.ar_customers where bill_customer = @NewCustomerCode and status = 'A')
where
	shipper in (select convert(varchar(15), ShipperID) from @ShippersToUpdate) and
type = 'S'
	
	
End

End
GO
