SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[eeisp_asnheader] (@shipper integer ) as
begin 
	select	'00' as purpose_code, 
		''as partial_complete,
		isNULL(bill_of_lading.scac_transfer, shipper.ship_via) as bill_of_lading_scac_transfer,
		bill_of_lading.scac_pickup,
		shipper.freight_type,
		shipper.staged_pallets, 
		shipper.aetc_number,
		edi_setups.id_code_type,
		edi_setups.parent_destination, 
		edi_setups.material_issuer,
		shipper.id, 
		shipper.date_shipped,
		edi_setups.pool_code, 
		shipper.gross_weight, 
		shipper.net_weight, 
		shipper.staged_objs, 
		shipper.ship_via, 
		shipper.trans_mode, 
		shipper.truck_number, 
		shipper.pro_number, 
		shipper.seal_number, 
		shipper.destination, 
		shipper.bill_of_lading_number, 
		shipper.time_shipped, 
		bill_of_lading.equipment_initial, 
		edi_setups.equipment_description, 
		edi_setups.trading_partner_code, 
		edi_setups.supplier_code, 
		datepart(dy,getdate()) as day_of_year,
		(select	max(dock_code) 
		from	order_header,shipper_detail
		where	order_header.order_no = shipper_detail.order_no and
			shipper_detail.shipper = @shipper) as Intermediate_consignee,
		edi_setups.id_code_type as ford_consignee,
		isNULL((Select	count(distinct Parent_serial) 
			from	audit_trail
			where	audit_trail.shipper = convert(varchar(10),@shipper) and
				audit_trail.type = 'S' and 
				isNULL(parent_serial,0) >0 ),0) as pallets,
		isNULL((Select	count(serial) 
			from	audit_trail,
				package_materials
			where	audit_trail.shipper = convert(varchar(10),@shipper) and
				audit_trail.type = 'S' and
				part <> 'PALLET' and 
				parent_serial is NULL and
				audit_trail.package_type = package_materials.code and
				package_materials.type = 'B' ),0) as loose_ctns,
		isNULL((Select	count(serial) 
			from	audit_trail,
				package_materials
			where	audit_trail.shipper =  convert(varchar(10),@shipper) and
				audit_trail.type = 'S' and 
				parent_serial is NULL and
				audit_trail.package_type = package_materials.code and
				package_materials.type = 'O' ),0) as loose_bins,
				shipper.shipping_dock as fordmotor_consignee,
				edi_setups.parent_destination as edi_shipto
	from	{oj shipper  LEFT OUTER JOIN bill_of_lading  ON shipper.bill_of_lading_number = bill_of_lading.bol_number},   
		edi_setups  
	where	( shipper.destination = edi_setups.destination ) and  
		( ( shipper.id = @shipper ) )
end

GO
