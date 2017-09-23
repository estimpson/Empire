SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[eeisp_rpt_planning_pre_shipper] (@shipper int)
as
begin


select	shipper.id,   
	destination.company,   
	destination.destination,   
	destination.name,   
	destination.address_1,   
	destination.address_2,   
	destination.address_3,   
	destination.address_4,   
	customer.customer,   
	customer.name,   
	customer.address_1,   
	customer.address_2,   
	customer.address_3,   
	customer.address_4,
	edi_setups.supplier_code,   
	shipper.aetc_number,   
	destination_shipping.fob,   
	shipper.freight_type,   
	carrier.name,   
	shipper_detail.note,   
	order_header.customer_po,   
	shipper_detail.qty_original,   
	shipper_detail.qty_packed,   
	part.part,
	part.cross_ref,   
	shipper.staged_objs,   
	shipper.staged_pallets,   
	shipper.gross_weight,
	destination_shipping.note_for_bol,
	destination_shipping.note_for_shipper,
	shipper.notes,
	shipper.date_shipped,
	shipper_detail.customer_part,
	shipper.bill_of_lading_number,
	shipper.tare_weight,
	shipper.net_weight,
	shipper.pro_number,
	shipper.truck_number,
	part.name,
	shipper_detail.boxes_staged,
	edi_setups.prev_cum_in_asn,
	shipper_detail.accum_shipped,
	consignee.name,
	consignee.address_1,
	consignee.address_2,
	consignee.address_3,
	consignee.address_4,
	parameters.company_name,
	parameters.address_1,
	parameters.address_2,
	parameters.address_3,
	parameters.phone_number,
	shipper.trans_mode,
	part_inventory.standard_pack,
	part_inventory.standard_unit,
	shipper.date_stamp,
	shipper_detail.part_original,
		
		shipper.staged_pallets,
		shipper_detail.customer_po,
		convert(varchar(50),getdate(),13) as todaysdate,
		shipper.shipping_dock,
		order_header.engineering_level,
		shipper.terms,
		shipper.location,
		shipper.aetc_number,
		order_header.our_cum,
		shipper.staged_objs,
      (CASE WHEN shipper.destination like 'VAL%' THEN '2S'+ convert(varchar(15), shipper.id) ELSE convert(varchar(15), shipper.id) END) as shipper_no,
		order_header.zone_code,
		part.product_line,
		shipper.date_shipped,
		shipper.plant,
		shipper_detail.release_no,
		isNULL(nullif(auto_create_asn,''),'N') as ASNRequired,
		shipper_detail.alternate_price,
		 shipper_detail.alternate_price*qty_packed as ExtendedStaged,
		 shipper_detail.alternate_price*qty_original as ExtendedScheduled
		
from	shipper
		join destination
			on shipper.destination = destination.destination
		left join destination_shipping
			on destination.destination = destination_shipping.destination
		left join edi_setups
			on destination.destination = edi_setups.destination
		left join carrier
			on shipper.ship_via = carrier.scac
		join customer
			on customer.customer = destination.customer
		left join destination as consignee
			on shipper.shipping_dock = consignee.destination
		join shipper_detail
			on shipper.id = shipper_detail.shipper
		left join order_header
			on order_header.order_no = shipper_detail.order_no
		join part
			on part.part = shipper_detail.part_original
		join part_inventory
			on part_inventory.part = shipper_detail.part_original
		cross join parameters
where	(shipper.id = @shipper)  
end
GO
