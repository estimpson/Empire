SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE	procedure [dbo].[eeisp_update_terms] (@newterm varchar(25), @customer varchar(15))
as
Begin

--eeisp_update_terms  '2D 2M' ,'GM OHIO'

declare @Status table
(	RowsUpdated varchar (255) null,
	Errors varchar(255) null)

--Select description from term where description = @newterm
update order_header
set	term = @newTerm
where	customer = @customer
and term not in (Select description from term where description = @newterm)

Insert @Status
Select convert(varchar(25), @@RowCount) + ' '+ 'Order(s) Updated',  (CASE WHEN @@Error != 0 THEN 'Error- Please check Sales Orders' ELSE 'Successful' END)

update shipper
set	terms = @newTerm
where	customer = @customer
and terms not in (Select description from term where description = @newterm) and
	date_shipped is null and status in ( 'o', 's')

Insert @Status
Select convert(varchar(25), @@RowCount) + ' '+ 'Shipper(s) Updated',  (CASE WHEN @@Error != 0 THEN 'Error- Please check Shippers' ELSE 'Successful' END)



update customer
set	terms = @newTerm
where	customer = @customer
and terms not in (Select description from term where description = @newterm) 

Insert @Status
Select convert(varchar(25), @@RowCount) + ' '+ 'Customer(s) Updated',  (CASE WHEN @@Error != 0 THEN 'Error- Please check Customers' ELSE 'Successful' END)

Select *  from @Status

End
GO
