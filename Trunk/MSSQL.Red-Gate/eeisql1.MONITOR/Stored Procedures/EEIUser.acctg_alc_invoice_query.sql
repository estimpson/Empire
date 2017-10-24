SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[acctg_alc_invoice_query]
		@beg_date datetime,
		@end_date datetime
as
select	'2203' as 'SUPPLIER #', 
		shipper.invoice_number as 'INVOICE #', 
		shipper.date_shipped as 'INVOICE DATE', 
		shipper.id as 'SHIPPER #', 
		'' as 'Mat. Doc.', 
		'' as 'YEAR', 
		customer_po as 'PO NUMBER', 
		customer_part as 'ALC PART #', 
		qty_packed as 'INV QTY', 
		alternative_unit as 'QTY UOM', 
		alternate_price as 'UNIT PRICE', 
		qty_packed*alternate_price as 'TOTAL AMOUNT',
		currency_unit as 'CURRENCY',
		shipper.pro_number as 'PROTRANS NUMBER',
		shipper_detail.part_original as 'EMPIRE PART #'
from	shipper 
		left join shipper_detail on shipper.id = shipper_detail.shipper 
where	shipper.date_shipped >= @beg_date 
		and shipper.date_shipped <= @end_date 
		and customer = 'ALC'
		and part_original IS NOT NULL
order by shipper.id,
		 shipper_detail.part_original
		
GO
