SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[eeisp_edi_asnheader]

as




SELECT '00' as purpose_code, 
''as partial_complete,
isNULL(bill_of_lading.scac_transfer, shipper.ship_via) as bill_of_lading_scac_transfer,
bill_of_lading.scac_pickup as bill_of_lading_scac_pickup,
shipper.freight_type as shipper_freight_type,
SHIPPER.STAGED_PALLETS as SHIPPER_STAGED_PALLETS, 
shipper.aetc_number as shipper_aetc_number,
edi_setups.id_code_type as edi_setups_id_code_type,
edi_setups.parent_destination as edi_setups_parent_destination, 
edi_setups.material_issuer as edi_setups_material_issuer,
shipper.id as shipper_id, 
shipper.date_shipped as shipper_date_shipped,
edi_setups.pool_code as edi_setups_pool_code, 
shipper.gross_weight as shipper_gross_weight, 
shipper.net_weight as shipper_net_weight, 
shipper.staged_objs as shipper_staged_objs, 
shipper.ship_via as shipper_ship_via, 
shipper.trans_mode as shipper_trans_mode, 
shipper.truck_number as shipper_truck_number, 
shipper.pro_number as shipper_pro_number, 
shipper.seal_number as shipper_seal_number, 
shipper.destination as shipper_destination, 
shipper.bill_of_lading_number as shipper_bill_of_lading_number, 
shipper.time_shipped as shipper_time_shipped, 
bill_of_lading.equipment_initial as bill_of_lading_equipment_initial, 
edi_setups.equipment_description as edi_setups_equipment_description, 
edi_setups.trading_partner_code as edi_setups_trading_partner_code, 
edi_setups.supplier_code as edi_setups_supplier_code, 

DATEPART(dy,getdate()) as day_of_year,
(SELECT max(dock_code) FROM order_header,shipper_detail
            WHERE order_header.order_no = shipper_detail.order_no and
			         shipper_detail.shipper = shipper.id) as Intermediate_consignee,
edi_setups.id_code_type as ford_consignee,
(Select count(distinct Parent_serial) from audit_trail
			where audit_trail.shipper =  convert(varchar (15),shipper.id) and
			audit_trail.type = 'S' and 
			isNULL(parent_serial,0) >0 ) as pallets,

(Select count(serial) from audit_trail
			where audit_trail.shipper = convert(varchar(15),shipper.id) and
			audit_trail.type = 'S' and 
			isNULL(parent_serial,0) = 0  ) as loose_ctns,

(Select count(serial) from audit_trail
			where audit_trail.shipper =  convert(varchar(15),shipper.id) and
			audit_trail.type = 'S' and 
			parent_serial is NULL ) as loose_bins,
shipper.shipping_dock as fordmotor_consignee
   
    FROM	shipper
    		left join bill_of_lading
    			on shipper.bill_of_lading_number = bill_of_lading.bol_number
         	join edi_setups
         		on shipper.destination = edi_setups.destination
GO
