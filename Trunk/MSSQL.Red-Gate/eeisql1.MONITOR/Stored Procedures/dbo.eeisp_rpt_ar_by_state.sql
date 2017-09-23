SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE Procedure [dbo].[eeisp_rpt_ar_by_state] (@begindate datetime, @enddate datetime)
as
--[dbo].[eeisp_rpt_sales_by_state] '2007-01-01', '2009-11-30'
Begin
Select	ar_headers.document_type,
		ar_headers.document,
		gl_date,
		FT.fn_TruncDate ('wk', gl_date) WeeklofSales,
		FT.fn_TruncDate ('m', gl_date) MonthofSales,
		terms,
		ar_headers.amount,
		ar_headers.applied_amount,
		ar_headers.amount-ar_headers.applied_amount as open_amount,
		ship_customer,		
		addresses_clean.Address_1,
		addresses_clean.Address_2,
        addresses_clean.Address_3,
		isNULL(addresses_clean.state, 'No State Defined')
from		ar_headers
left join	ar_customer_ship_locations on ar_headers.ship_to_location = ar_customer_ship_locations.ship_location and ar_customer_ship_locations.customer = ar_headers.ship_customer
left join	addresses_clean on ar_customer_ship_locations.ship_address_id = addresses_clean.address_id
where	ar_headers.gl_date >= FT.fn_TruncDate ('dd', @begindate) and  ar_headers.gl_date < dateadd(dd,1,FT.fn_TruncDate ('dd', @enddate)) and ((ar_headers.amount-ar_headers.applied_amount) <> 0)
		and ar_headers.ship_unit != '10'
end



GO
