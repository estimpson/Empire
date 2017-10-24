SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[vw_eei_edisetups]
as

select destination.destination,
			destination.name destname,
			destination.customer,
			customer.name custname,
			destination.address_1 dadd1,
			destination.address_2 dadd2,
			destination.address_3 dadd3,
			destination.address_4 dadd4,
			customer.address_1 cadd1,
			customer.address_2 cadd2,
			customer.address_3 cadd3,
			customer.address_4 cadd4,
			order_header.customer_part,
			order_header.customer_po,
			order_header.blanket_part,
			edi_setups.trading_partner_code,
			edi_setups.auto_create_asn,
			edi_setups.parent_destination,
			edi_setups.asn_overlay_group,
			edi_setups.supplier_code
from	destination,
			order_header,
			edi_setups,
			customer
where	 order_header.destination = destination.destination and
			edi_setups.destination = destination.destination and
			order_header.customer = customer.customer
GO
