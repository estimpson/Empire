SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







--exec eeisp_rpt_sales_by_state '2016-01-01', '2016-12-31'


CREATE Procedure [dbo].[eeisp_rpt_sales_by_state] (@begindate datetime, @enddate datetime)
as

Begin

--declare @begindate datetime
--declare @enddate datetime

--select @begindate = '2016-01-01', @enddate = '2016-12-31'

Select	ad.document_type,
		ad.ar_document,
		ad.gl_date,
		FT.fn_TruncDate ('wk', gl_date) WeeklofSales,
		FT.fn_TruncDate ('m', gl_date) MonthofSales,
		ad.bill_customer,
		ad.ship_customer,
		adi.customer_po,
		ad.sales_term as [sales_terms],
		shipper.location as [title_passes_at],
		adi.item,
		adi.quantity,
		adi.unit_cost,
		ad.multiplier*adi.document_amount as document_amount,
		adi.posting_account,
		shipper.plant,
		a.address_id as empower_address_id,
		a.address_1 as empower_address_1,
		a.address_2 as empower_address_2,
		a.address_3 as empower_address_3,
		a.city as empower_city,
		a.state as empower_state,
		a.postal_code as empower_postal_code,
		a.country as empower_country,
		shipper.destination as monitor_destination,
		destination.address_1 as shipper_address_1,
		destination.address_2 as monitor_address_2,
		destination.address_3 as monitor_address_3,
		destination.State as monitor_state, 
		destination.Country as Monitor_country
from		empower..ar_documents ad
join		empower..ar_document_items adi on ad.ar_document = adi.ar_document and ad.document_type = adi.document_type
left join	empower..customer_ship_locations csl on ad.ship_location = csl.ship_location and ad.ship_customer = csl.customer
left join	empower..addresses a on csl.address_id = a.address_id
left join	shipper on ad.ar_document = convert(varchar(30),shipper.id) and ad.bill_customer = shipper.customer
left join	destination on destination.destination = shipper.destination 
where	ad.gl_date >= FT.fn_TruncDate ('dd', @begindate) and  ad.gl_date < dateadd(dd,1,FT.fn_TruncDate ('dd', @enddate))
		and ad.ship_unit != '10'
		
order by ship_customer
end


--select * from		empower..ar_documents ad
--join		empower..ar_document_items adi on ad.ar_document = adi.ar_document and ad.document_type = adi.document_type
--where fiscal_year = '2016'

GO
