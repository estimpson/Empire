SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_eei_ar_addresses_clean_recent_activity]
as
Select	Customer,
		Customer_name,
		address_1,
		address_2,
		address_3,
		city,
		state,
		postal_code,
		country
		
from		ar_customers
join		[dbo].[addresses_clean] addresses on  ar_customers.bill_address_id = addresses.address_id
where	customer in (
Select distinct bill_customer from ar_headers where document_type = 'I' and  changed_date >= dateadd(m,-3,getdate())) or
		customer in (
Select distinct ship_customer from ar_headers where document_type = 'I' and  changed_date >= dateadd(m,-3,getdate())) 
GO
