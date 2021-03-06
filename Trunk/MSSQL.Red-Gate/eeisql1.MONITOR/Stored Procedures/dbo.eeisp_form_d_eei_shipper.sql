SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





--SELECT * FROM shipper WHERE Status = 'S'





CREATE PROCEDURE [dbo].[eeisp_form_d_eei_shipper] ( @shipper VARCHAR(15) )
AS 
    BEGIN
    
 -- [dbo].[eeisp_form_d_eei_shipper] 126808 

 -- 02/05/2019 ASB : Added last column to get palnt code for packing slip ; requested bt FedMogul Lighting Juarez. Added additional conditions to case staements for company name and log to mirror invoice form
 -- 03/15/2019 ASB : left join  destination_a1 to get destination contact information for packing slip
 
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


        SELECT  shipper.id ,
                destination.company ,
                destination.destination ,
                destination.name ,
                destination.address_1 ,
                destination.address_2 ,
                destination.address_3 ,
                destination.address_4 ,
                customer.customer ,
                customer.name ,
                customer.address_1 ,
                customer.address_2 ,
                customer.address_3 ,
                customer.address_4 ,
                edi_setups.supplier_code ,
                shipper.aetc_number ,
                destination_shipping.fob ,
                shipper.freight_type ,
                carrier.name ,
                shipper_detail.note ,
                order_header.customer_po ,
                shipper_detail.qty_original ,
                shipper_detail.qty_packed ,
                part.part ,
                part.cross_ref ,
                shipper.staged_objs ,
                shipper.staged_pallets ,
                shipper.gross_weight ,
                destination_shipping.note_for_bol ,
                destination_shipping.note_for_shipper ,
                shipper.notes ,
                shipper.date_shipped ,
                shipper_detail.customer_part ,
                shipper.bill_of_lading_number ,
                shipper.tare_weight ,
                shipper.net_weight ,
                shipper.pro_number ,
                shipper.truck_number ,
                part.NAME ,
                shipper_detail.boxes_staged ,
                edi_setups.prev_cum_in_asn ,
                shipper_detail.accum_shipped ,
                consignee.NAME ,
                consignee.address_1 ,
                consignee.address_2 ,
                consignee.address_3 ,
                consignee.address_4 ,
                COALESCE((CASE WHEN product_line LIKE '%EPL%' THEN 'EMPIRE PRODUCTS, LTD.' 
							WHEN Shipper.customer = 'ES3GM' THEN parameters.company_name
							WHEN Shipper.customer = 'ES3DRAEXL' THEN parameters.company_name
							WHEN Shipper.customer = 'ES3DUNCANB' THEN parameters.company_name
							WHEN Shipper.customer = 'ES3SUMMIT' THEN parameters.company_name
							WHEN Shipper.customer = 'ES3AUTO' THEN parameters.company_name
							WHEN Shipper.customer = 'ES3HELLA' THEN parameters.company_name
							WHEN Shipper.customer = 'MOLEX' THEN parameters.company_name
							WHEN Shipper.customer = 'APTIV' THEN parameters.company_name
							WHEN product_line LIKE '%ES3%' THEN 'ES3 COMPONENTS' ELSE parameters.company_name END),
							parameters.company_name) ,
                COALESCE((	CASE WHEN product_line LIKE '%EPL%' 
							THEN '270 REX BLVD. AUBURN HILLS, MI 48236-2953' 
							WHEN product_line LIKE '%ES3%' 
							THEN parameters.address_1 
							ELSE parameters.address_1 END),
							parameters.address_1) ,
                 COALESCE((CASE WHEN product_line LIKE '%EPL%' 
							THEN '' 
							WHEN product_line LIKE '%ES3%' 
							THEN parameters.address_2 
							ELSE parameters.address_2 END),parameters.address_2) ,
                parameters.address_3 ,
                COALESCE((CASE WHEN product_line LIKE '%EPL%' 
							THEN '(248)-853-6363' 
							WHEN product_line LIKE '%ES3%' 
							THEN parameters.phone_number 
							ELSE parameters.phone_number END),parameters.phone_number) ,
                shipper.trans_mode ,
                part_inventory.standard_pack ,
                part_inventory.standard_unit ,
                shipper.date_stamp ,
                shipper_detail.part_original ,
                shipper.staged_pallets ,
                shipper_detail.customer_po ,
                CONVERT(VARCHAR(50), GETDATE(), 13) AS todaysdate ,
                shipper.shipping_dock ,
                order_header.engineering_level ,
                shipper.terms ,
                shipper.location ,
                shipper.aetc_number ,
                order_header.our_cum ,
                shipper.staged_objs ,
                ( CASE WHEN shipper.destination LIKE 'VAL%'
                       THEN '2S' + CONVERT(VARCHAR(15), shipper.id)
                       ELSE CONVERT(VARCHAR(15), shipper.id)
                  END ) AS shipper_no ,
                order_header.zone_code ,
                part.product_line ,
                shipper.date_shipped ,
                shipper.plant ,
                shipper_detail.release_no ,
                ISNULL(NULLIF(auto_create_asn, ''), 'N') AS ASNRequired ,
                shipper_detail.order_no,
               UPPER(COALESCE( plant.name, company_name)) AS PlantName,
               UPPER(COALESCE(plant.address_1, parameters.address_1)) AS PlantAddress1,
               UPPER(COALESCE(plant.address_2, parameters.address_2))AS PlantAddress2,
               UPPER(COALESCE(plant.address_3, parameters.address_3)) AS PlantAddress3,
               COALESCE(NULLIF(order_header.line_feed_code,''),(SELECT MAX(oh.line_feed_code) FROM order_header oh WHERE oh.customer_part = shipper_detail.customer_part AND oh.destination = shipper.destination ),'') AS LineFeedCode_SumitronicsPartNumber,
				CASE WHEN COALESCE(AutoSystemsEDIRelease.AutoSystemsPO, shipper_detail.customer_po,'') LIKE '%Spot%' THEN '' ELSE COALESCE(AutoSystemsEDIRelease.AutoSystemsPO, shipper_detail.customer_po) END  AS CustomerPurchaseOrder,
				CASE
					WHEN Shipper.customer = 'ES3GM' THEN 0
					WHEN Shipper.customer = 'ES3DRAEXL' THEN 0
					WHEN Shipper.customer = 'ES3DUNCANB' THEN 0
					WHEN Shipper.customer = 'ES3SUMMIT' THEN 0
					WHEN Shipper.customer = 'ES3AUTO' THEN 0
					WHEN Shipper.customer = 'ES3HELLA' THEN 0
					WHEN Shipper.customer = 'MOLEX' THEN 0
					WHEN Shipper.customer = 'APTIV' THEN 0
					WHEN part.product_line LIKE '%ES3%' THEN 1
					WHEN part.product_line LIKE '%EPL%' THEN 2
				ELSE 0
				END AS Logo,
				StagedObjects = StagedSerials.SerialCount,
				EDIPlantCode = coalesce(nullif(edi_setups.edishiptoID,''), edi_setups.parent_destination),
				CustomerContact = customer.contact,
				CustomerPhone = customer.phone,
				DestinationContact = rtrim(da1.field_desc10),
				DestinationPhone = rtrim(da1.field_desc11),
                DestinationEmail = rtrim(da1.field_desc12)
        FROM    shipper
                JOIN 
					destination ON shipper.destination = destination.destination
                LEFT JOIN 
					destination plant ON shipper.plant = plant.destination AND plant.plant IS NOT NULL
                LEFT JOIN 
					destination_shipping ON destination.destination = destination_shipping.destination
                LEFT JOIN 
					edi_setups ON shipper.destination = edi_setups.destination
                LEFT JOIN 
					destination consignee ON shipper.shipping_dock = consignee.destination
				 LEFT JOIN 
					destination_a1 da1 ON da1.destination = destination.destination
                JOIN 
					customer ON shipper.customer = customer.customer
                JOIN 
					shipper_detail ON shipper.id = shipper_detail.shipper
                LEFT JOIN 
					order_header ON shipper_detail.order_no = order_header.order_no
                JOIN
					part ON shipper_detail.part_original = part.part
                JOIN 
					part_inventory ON part.part = part_inventory.part
                LEFT JOIN 
					carrier ON shipper.ship_via = carrier.scac
				LEFT JOIN
					EDIAutoSystems.BlanketOrders bo ON bo.BlanketOrderNo = shipper_detail.order_no
				OUTER APPLY
					( SELECT TOP 1 cpr.CustomerPO AutoSystemsPO
						FROM 
							EDI4010.CurrentPlanningReleases() cpr
						JOIN
						EDI4010.PlanningHeaders ph ON ph.RawDocumentGUID = cpr.RawDocumentGUID
						WHERE 
							ShipFromCode = 'US0842' AND
							cpr.ShipToCode = bo.EDIShipToCode AND
							cpr.CustomerPart = bo.CustomerPart
                        
						ORDER BY ph.DocumentDT DESC	
					) AutoSystemsEDIRelease
					OUTER APPLY
					( SELECT Count(object.serial) SerialCount
						FROM 
							object
						 WHERE 
							Object.shipper = shipper.id
							AND part ! = 'PALLET'
						
                
					) StagedSerials
				 
                CROSS JOIN dbo.parameters
        WHERE   ( ( CONVERT (VARCHAR(15), id) = @shipper  ) )    
		

    END












GO
