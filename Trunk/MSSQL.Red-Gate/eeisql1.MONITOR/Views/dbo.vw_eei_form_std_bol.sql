SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE	VIEW [dbo].[vw_eei_form_std_bol]
AS
SELECT		
			destination.address_1 destination_address_1, 
			destination.address_2 destination_address_2,
 			destination.address_3 destination_address_3, 
			destination.address_4 destination_address_4,
			destination.address_5 destination_address_5,   	
			carrier.name carrier_name, 
			carrier.scac carrier_scac, 
			edi_setups.supplier_code edi_setups_supplier_code, 
			SUM(shipper.net_weight) shipper_net_weight, 
			SUM(shipper.tare_weight) shipper_tare_weight, 
			SUM(shipper.gross_weight) shipper_gross_weight, 
			destination.name destination_name, 
			bill_of_lading.bol_number bill_of_lading_bol_number, 
			destination_shipping.note_for_bol destination_shipping_note_for_bol, 
			SUM(shipper.staged_pallets) shipper_staged_pallets,
			SUM(COALESCE(StagedSerials.SerialCount, shipper.staged_objs)) shipper_staged_objs, 
			parameters.company_name parameters_company_name, 
			COALESCE(PlantAdd1, parameters.address_1) parameters_address_1, 
			COALESCE(PlantAdd2, parameters.address_2 ) parameters_address_2, 
			COALESCE(PlantAdd3, parameters.address_3 ) parameters_address_3,
			parameters.phone_number parameters_phone_number,
			MAX(shipper.freight_type) shipper_freight_type,
			MAX(c2.name) AS tpb_name,
			MAX(c2.address_1) AS tpb_add1,
			MAX(c2.address_2) AS tpb_add2,
			MAX(c2.address_3) AS tpb_add3,
			MAX(c2.address_4) AS tpb_add4,
			MAX(c2.address_5) AS tpb_add5,
			MIN(shipper.id) AS shipper_id	 
FROM 	bill_of_lading
JOIN		shipper ON bill_of_lading.bol_number = CONVERT (INT,shipper.bill_of_lading_number)
LEFT JOIN	carrier ON   bill_of_lading.scac_pickup = carrier.scac
JOIN		destination ON bill_of_lading.destination = destination.destination
JOIN		edi_setups ON destination.destination = edi_setups.destination 
JOIN		destination_shipping ON destination.destination = destination_shipping.destination
JOIN		customer ON destination.customer = customer.customer
LEFT JOIN	customer c2 ON customer.custom5 = c2.customer 
OUTER APPLY  ( SELECT TOP 1  dest.address_1 AS PlantAdd1,
											dest.address_2 AS PlantAdd2,
											dest.address_3 AS PlantAdd3
						 FROM  destination dest WHERE  dest.plant = shipper.plant
						 )  ShipFrom
OUTER APPLY
					( SELECT Count(object.serial) SerialCount
						FROM 
							object
						 WHERE 
							Object.shipper = shipper.id
							AND part ! = 'PALLET'
						
                
					) StagedSerials
CROSS JOIN parameters
GROUP BY		destination.address_1, 
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
			COALESCE(PlantAdd1, parameters.address_1) , 
			COALESCE(PlantAdd2, parameters.address_2 ) , 
			COALESCE(PlantAdd3, parameters.address_3 ) ,
			parameters.phone_number

GO
