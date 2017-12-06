SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure 
[dbo].[eei_sales_by_destination_dw] @from_date date, @to_date date
as

-- exec monitor..eei_sales_by_destination_dw '2017-01-01', '2017-11-30'

select	ship_customer_name, ship_location, 
		a1.address_id, a1.address_1, a1.address_2, a1.address_3, a1.city, a1.state, a1.postal_code, a1.country,
		-- ISNULL(a1.address_1,'')+' '+ISNULL(a1.address_2,'')+' '+ISNULL(a1.address_3,'')+' '+ISNULL(a1.city,'')+' '+ISNULL(a1.state,'')+' '+ISNULL(a1.postal_code,'')+' '+ISNULL(a1.country,'') as address_line, 
		a2.address_id, a2.address_1, a2.address_2, a2.address_3, a2.city, a2.state, a2.postal_code, a2.country, 
		ag.latitude, ag.longitude,
		sum(ledger_amount) as amount  from empower..ar_documents ad
join empower..addresses a1
on ad.address_id1 = a1.address_id
join empower..addresses a2
on ad.address_id2 = a2.address_id 
join empower.eei.addresses_geocoded ag
on ad.address_id1 = ag.address_id
where document_date >= '2017-01-01' and document_date <= '2017-11-30'
and bill_customer = 'SUS'
group by ship_customer_name, ship_location, 
		a1.address_id, a1.address_1, a1.address_2, a1.address_3, a1.city, a1.state, a1.postal_code, a1.country, 
		a2.address_id, a2.address_1, a2.address_2, a2.address_3, a2.city, a2.state, a2.postal_code, a2.country,
		ag.latitude, ag.longitude
having sum(ledger_amount) >= .01
order by a1.address_id
GO
