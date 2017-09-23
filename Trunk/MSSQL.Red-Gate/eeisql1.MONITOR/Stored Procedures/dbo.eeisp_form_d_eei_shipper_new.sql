SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[eeisp_form_d_eei_shipper_new]
@shipper varchar(15)
as    
 -- [dbo].[eeisp_form_d_eei_shipper] 73638
 /*if exists (	select	1 
			from		shipper_detail
			join		object on shipper_detail.shipper = object.shipper and shipper_detail.part_original = object.part
			where	shipper_detail.shipper = @shipper and
					shipper_detail.part_original like 'MIT%' and
					object.part <> 'PALLET' and
					isNULL(shipper_detail.customer_po, 'Y') <> isNULL(object.station, 'Z'))
Begin			
	update	shipper
	set		status = 'O', printed = 'N'
	where	shipper.id = @shipper
End*/


select
	shipper.id
,	destination.company
,	destination.destination
,	destination.name
,	destination.address_1
,	destination.address_2
,	destination.address_3
,	destination.address_4
,	customer.customer
,	customer.name
,	customer.address_1
,	customer.address_2
,	customer.address_3
,	customer.address_4
,	edi_setups.supplier_code
,	shipper.aetc_number
,	destination_shipping.fob
,	shipper.freight_type
,	carrier.name
,	shipper_detail.note
,	order_header.customer_po
,	shipper_detail.qty_original
--,	shipper_detail.qty_packed
,	coalesce(uggsps.Quantity, shipper_detail.qty_packed)
,	part.part
,	part.cross_ref
,	staged_objs = coalesce(uggsps.Boxes, shipper.staged_objs)
,	shipper.staged_pallets
,	coalesce(uggsps.GrossWeight, shipper.gross_weight)
,	destination_shipping.note_for_bol
,	destination_shipping.note_for_shipper
,	shipper.notes
,	shipper.date_shipped
,	shipper_detail.customer_part
,	shipper.bill_of_lading_number
,	coalesce(uggsps.TareWeight, shipper.tare_weight)
,	coalesce(uggsps.NetWeight, shipper.net_weight)
,	shipper.pro_number
,	shipper.truck_number
,	part.name
,	boxes_staged = coalesce(uggsps.Boxes, shipper_detail.boxes_staged)
,	edi_setups.prev_cum_in_asn
,	shipper_detail.accum_shipped
,	consignee.name
,	consignee.address_1
,	consignee.address_2
,	consignee.address_3
,	consignee.address_4
,	coalesce((case when product_line like '%EPL%' then 'EMPIRE PRODUCTS, LTD.'
					when shipper.customer = 'ES3GM' then parameters.company_name
					when shipper.customer = 'ES3DRAEXL' then parameters.company_name
					when shipper.customer = 'ES3DUNCANB' then parameters.company_name
					when shipper.customer = 'ES3SUMMIT' then parameters.company_name
					when shipper.customer = 'ES3AUTO' then parameters.company_name
					when product_line like '%ES3%' then 'ES3 COMPONENTS'
					else parameters.company_name
				end), parameters.company_name)
,	coalesce((case when product_line like '%EPL%' then '270 REX BLVD. AUBURN HILLS, MI 48236-2953'
					when product_line like '%ES3%' then parameters.address_1
					else parameters.address_1
				end), parameters.address_1)
,	coalesce((case when product_line like '%EPL%' then ''
					when product_line like '%ES3%' then parameters.address_2
					else parameters.address_2
				end), parameters.address_2)
,	parameters.address_3
,	coalesce((case when product_line like '%EPL%' then '(248)-853-6363'
					when product_line like '%ES3%' then parameters.phone_number
					else parameters.phone_number
				end), parameters.phone_number)
,	shipper.trans_mode
,	part_inventory.standard_pack
,	part_inventory.standard_unit
,	shipper.date_stamp
,	shipper_detail.part_original
,	shipper.staged_pallets
,	shipper_detail.customer_po
,	convert(varchar(50), getdate(), 13) as todaysdate
,	shipper.shipping_dock
,	order_header.engineering_level
,	shipper.terms
,	shipper.location
,	shipper.aetc_number
,	order_header.our_cum
,	(case when shipper.destination like 'VAL%' then '2S' + convert(varchar(15), shipper.id)
			else convert(varchar(15), shipper.id)
		end) as shipper_no
,	order_header.zone_code
,	part.product_line
,	shipper.date_shipped
,	shipper.plant
,	shipper_detail.release_no
,	isnull(nullif(auto_create_asn, ''), 'N') as ASNRequired
,	shipper_detail.order_no
,	upper(coalesce(plant.name, company_name)) as PlantName
,	upper(coalesce(plant.address_1, parameters.address_1)) as PlantAddress1
,	upper(coalesce(plant.address_2, parameters.address_2)) as PlantAddress2
,	upper(coalesce(plant.address_3, parameters.address_3)) as PlantAddress3
,	coalesce
	(	nullif(order_header.line_feed_code, '')
	,	(	select
				max(oh.line_feed_code)
			from
				order_header oh
			where
				oh.customer_part = shipper_detail.customer_part
				and oh.destination = shipper.destination
		)
	, ''
	) as LineFeedCode_SumitronicsPartNumber
,	case
		when coalesce(shipper_detail.customer_po, '') like '%Spot%' then ''
		else shipper_detail.customer_po
	end as CustomerPurchaseOrder
,	case
		when shipper.customer = 'ES3GM' then 0
		when shipper.customer = 'ES3DRAEXL' then 0
		when shipper.customer = 'ES3DUNCANB' then 0
		when shipper.customer = 'ES3SUMMIT' then 0
		when shipper.customer = 'ES3AUTO' then 0
		when part.product_line like '%ES3%' then 1
		when part.product_line like '%EPL%' then 2
		else 0
	end as Logo
,	uggsps.ASN_Number
from
	shipper
	join destination
		on shipper.destination = destination.destination
	left join destination plant
		on shipper.plant = plant.destination
			and plant.plant is not null
	left join destination_shipping
		on destination.destination = destination_shipping.destination
	left join edi_setups
		on shipper.destination = edi_setups.destination
	left join destination consignee
		on shipper.shipping_dock = consignee.destination
	join customer
		on shipper.customer = customer.customer
	join shipper_detail
		on shipper.id = shipper_detail.shipper
	left join order_header
		on shipper_detail.order_no = order_header.order_no
	join part
		on shipper_detail.part_original = part.part
	join part_inventory
		on part.part = part_inventory.part
	left join carrier
		on shipper.ship_via = carrier.scac
	left join dbo.udf_GetGMServicePackingSlips(@shipper) uggsps
		on uggsps.Part = shipper_detail.part_original
	cross join dbo.parameters
where
	convert (varchar(15), id) = @shipper
GO
