SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[vw_eei_visteon_ship_status]

as
select blanket_part,
customer_part,
(select sum(qty_packed) from shipper_detail where order_no = order_header.order_no and date_shipped =(select date_shipped from shipper where shipper.id = order_header.shipper)) as lastshipqty,
order_no,
customer_po,
order_header.destination,
destination.name,
parent_destination,
(select date_shipped from shipper where shipper.id = order_header.shipper) as lastdateshipped,
(CASE WHEN (select status from shipper where id = order_header.shipper)='Z' 
THEN 'ASN Sent'  WHEN (select status from shipper where id = order_header.shipper)='C' 
THEN 'No ASN' ELSE 'Not Shipped' END)  as ASNStatus,
(CASE WHEN Auto_create_ASN = 'Y' THEN 'Y' ELSE 'N' END) as ASNRequirement,
order_header.shipper,
sales_manager_code.description

 from	order_header
		join destination
			on order_header.destination = destination.destination
		join edi_setups
			on destination.destination = edi_setups.destination
		join part_eecustom
			on part_eecustom.part = order_header.blanket_part
		left join sales_manager_code
			on part_eecustom.team_no = sales_manager_code.code
 where  blanket_part not like '%-PT%' and
		(blanket_part like 'VP%' or blanket_part like 'VIS%')



GO
