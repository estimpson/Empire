SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [Quote].[EmpowerCustomers]
as
select
	CustomerCode = ecl.customer
,	BasePartCustomerCodeList =
		(	select
 				Fx.ToList(distinct left(oh.blanket_part, 3))
 			from
 				Quote.MONITOR_order_header oh
			where
				oh.customer = ecl.customer
				and oh.blanket_part like '[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9]%'
		)
,	CustomerName = ecl.customer_name
,	PaymentTerm = ecl.payment_term
,	Territory = ecl.territory
,	BillingAddress1 = ecl.bill_address_1
,	BillingAddress2 = ecl.bill_address_2
,	BillingAddress3 = ecl.bill_address_3
,	BillingCity = ecl.bill_city
,	BillingState = ecl.bill_state
,	BillingPostalCode = ecl.bill_postal_code
,	BillingCityStatePostalCode =  ecl.bill_city_state_postal_code
,	BillingCountry = ecl.bill_country
,	BillingLastName = ecl.bill_last_name
,	BillingFirstName = ecl.bill_first_name
,	BillingTitle = ecl.bill_title
,	BillingPhone = ecl.bill_phone
,	BillingCellPhone = ecl.bill_cell_phone
,	BillingFaxPhone = ecl.bill_fax_phone
,	BillingEmailAddress = ecl.bill_email_address
from
	Quote.Empower_Customer_Listing ecl
	join Quote.MONITOR_customer cExternal
		on cExternal.customer = ecl.customer
		and coalesce(cExternal.region_code, '') != 'INTERNAL'
where
	ecl.inactive = 0
	and ecl.primary_ship_location = 1
GO
