SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE	view [dbo].[vw_eei_form_std_bol]
as
SELECT		
			destination.address_1 destination_address_1, 
			destination.address_2 destination_address_2,
 			destination.address_3 destination_address_3, 
			destination.address_4 destination_address_4,
			destination.address_5 destination_address_5,   	
			carrier.name carrier_name, 
			carrier.scac carrier_scac, 
			edi_setups.supplier_code edi_setups_supplier_code, 
			sum(shipper.net_weight) shipper_net_weight, 
			sum(shipper.tare_weight) shipper_tare_weight, 
			sum(shipper.gross_weight) shipper_gross_weight, 
			destination.name destination_name, 
			bill_of_lading.bol_number bill_of_lading_bol_number, 
			destination_shipping.note_for_bol destination_shipping_note_for_bol, 
			sum(shipper.staged_pallets) shipper_staged_pallets,
			sum(shipper.staged_objs) shipper_staged_objs, 
			parameters.company_name parameters_company_name, 
			Coalesce(PlantAdd1, parameters.address_1) parameters_address_1, 
			Coalesce(PlantAdd2, parameters.address_2 ) parameters_address_2, 
			Coalesce(PlantAdd3, parameters.address_3 ) parameters_address_3,
			parameters.phone_number parameters_phone_number,
			max(shipper.freight_type) shipper_freight_type,
			max(c2.name) as tpb_name,
			max(c2.address_1) as tpb_add1,
			max(c2.address_2) as tpb_add2,
			max(c2.address_3) as tpb_add3,
			max(c2.address_4) as tpb_add4,
			max(c2.address_5) as tpb_add5,
			min(shipper.id) as shipper_id	 
FROM 	bill_of_lading
join		shipper on bill_of_lading.bol_number = CONVERT (int,shipper.bill_of_lading_number)
left join	carrier on   bill_of_lading.scac_pickup = carrier.scac
join		destination on bill_of_lading.destination = destination.destination
join		edi_setups on destination.destination = edi_setups.destination 
join		destination_shipping on destination.destination = destination_shipping.destination
join		customer on destination.customer = customer.customer
left join	customer c2 on customer.custom5 = c2.customer 
outer apply  ( Select Top 1  dest.address_1 as PlantAdd1,
											dest.address_2 as PlantAdd2,
											dest.address_3 aS PlantAdd3
						 From  destination dest where  dest.plant = shipper.plant
						 )  ShipFrom
Cross Join parameters
group by		destination.address_1, 
			destination.address_2,
 			destination.address_3, 
			destination.address_4,
			destination.address_5,   	
			carrier.name, 
			carrier.scac, 
			edi_setups.supplier_code, 
			destination.name, 
			bill_of_lading.bol_number, 
			destination_shipping.note_for_bol, 
			parameters.company_name, 
			Coalesce(PlantAdd1, parameters.address_1) , 
			Coalesce(PlantAdd2, parameters.address_2 ) , 
			Coalesce(PlantAdd3, parameters.address_3 ) ,
			parameters.phone_number
GO
