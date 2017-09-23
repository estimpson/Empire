SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE PROCEDURE [dbo].[cdisp_fordheader] (@shipper INTEGER ) AS
BEGIN 
-- [dbo].[cdisp_fordheader] 84755
/*


    FlatFile Layout for Overlay: FD7_856_D_v2002_CDI^_040116     04-11-14 11:40

    Fixed Record/Fixed Field (FF)        Max Record Length: 080

    Input filename: DX-FX-FF.080         Output filename: DX-XF-FF.080


    Description                                            Type Start Length Element 

    Header Record '//'                                      //   001   002           

       RESERVED (MANDATORY)('STX12//')                      ID   003   007           

       X12 TRANSACTION ID (MANDATORY X12)                   ID   010   003           

       TRADING PARTNER (MANDATORY)                          AN   013   012           

       DOCUMENT NUMBER (MANDATORY)                          AN   025   030           

       FOR PARTIAL TRANSACTION USE A 'P' (OPTIONAL)         ID   055   001           

       EDIFACT(EXTENDED) TRANSACTION ID (MANDATORY EDIFACT) ID   056   010           

       DOCUMENT CLASS CODE (OPTIONAL)                       ID   066   006           

       OVERLAY CODE (OPTIONAL)                              ID   072   003           

       FILLER('      ')                                     AN   075   006           

       Record Length:                                                  080           

    Record '01'                                             01   001   002           

       PURPOSE                                              AN   003   002    1BSN01 

       ASN #                                                AN   005   011    1BSN02 

       ASN DATE                                             DT   016   006    1BSN03 

       ASN TIME                                             TM   022   004    1BSN04 

       SHIPPED DATE/TIME                                    DT   026   006    1DTM02 

       TIME                                                 TM   032   004    1DTM03 

       EXPECTED DELIVERY DATE/TIME                          DT   036   006    2DTM02 

       TIME                                                 TM   042   004    2DTM03 

       ACTUAL DELIVERY DATE/TIME                            DT   046   006    4DTM02 

       TIME                                                 TM   052   004    4DTM03 

       GROSS WEIGHT                                         R    056   012    1MEA03 

       U/M                                                  AN   068   002    1MEA04 

       FILLER('           ')                                AN   070   011           

       Record Length:                                                  080           

    Record '02'                                             02   001   002           

       NET WEIGHT                                           R    003   012    2MEA03 

       U/M                                                  AN   015   002    2MEA04 

       CONTAINER CODE                                       AN   017   005    1TD101 

                                          1
    Description                                            Type Start Length Element 

       LADING QUANTITY                                      N    022   008    1TD102 

       PALLET CODE                                          AN   030   005    3TD101 

       LADING QUANTITY                                      N    035   008    3TD102 

       BIN CODE                                             AN   043   005    2TD101 

       LADING QUANTITY                                      N    048   008    2TD102 

       FILLER('                         ')                  AN   056   025           

       Record Length:                                                  080           

    Record '03' (3 x - End Record '03')                     03   001   002           

       SCAC CODE                                            AN   003   004    1TD503 

       MODE                                                 AN   007   002    1TD504 

       LOCATION TYPE                                        AN   009   002    1TD507 

       LOCATION ID                                          AN   011   005    1TD508 

       ('                                               ... AN   016   065           

       Record Length:                                                  080           

    Record '04'                                             04   001   002           

       EQUIP DESCRIPTION CODE                               AN   003   002    1TD301 

       EQUIP. INITIAL                                       AN   005   004    1TD302 

       EQUIP. NUMBER                                        AN   009   007    1TD303 

       BM                                                   AN   016   002    1REF01 

       BILL OF LADING NUMBER                                AN   018   017    1REF02 

       FR                                                   AN   035   002    3REF01 

       FREIGHT BILL NUMBER                                  AN   037   017    3REF02 

       AW                                                   AN   054   002    6REF01 

       AIR BILL NUMBER                                      AN   056   017    6REF02 

       SN                                                   AN   073   002    4REF01 

       FILLER('      ')                                     AN   075   006           

       Record Length:                                                  080           

    Record '05'                                             05   001   002           

       SEAL NUMBER                                          AN   003   017    4REF02 

       METHOD OF PAYMENT                                    AN   020   002    1FOB01 

       TRANSPORT TERMS                                      AN   022   006    1FOB05 

       LOCATION TYPE                                        AN   028   002    1FOB06 

       RECEIVING PLANT ID                                   AN   030   005    1N104  

       SHIP FROM ID                                         AN   035   005    2N104  

                                          2
    Description                                            Type Start Length Element 

       SUPPLIER ID                                          AN   040   005    3N104  

       INTERMEDIATE CONSIGNEE ID                            AN   045   005    4N104  

       CURRENCY CODE                                        AN   050   003    1CUR02 

       AGENCY TYPE                                          AN   053   002    1ITA02 

       HANDLING CHARGE TOTAL AMT                            N    055   011    1ITA07 

       FILLER('               ')                            AN   066   015           

       Record Length:                                                  080           

    Loop Start (200000 x - End Record '11')                                          

       Record '06'                                          06   001   002           

          PRODUCT/SERVICE ID TYPE                           AN   003   002    1LIN02 

          PRODUCT/SERVICE ID                                AN   005   030    1LIN03 

          UNITS SHIPPED                                     R    035   009    1SN102 

          UNIT OF MEASURE                                   AN   044   002    1SN103 

          QTY SHIPPED TO DATE                               R    046   011    1SN104 

          QUANTITY                                          R    057   012    1SLN04 

          UNIT OF MEASURE                                   AN   069   002    1SLN05 

          FILLER('          ')                              AN   071   010           

          Record Length:                                               080           

       Record '07'                                          07   001   002           

          UNIT PRICE                                        R    003   016    1SLN06 

          PO #                                              AN   019   010    1PRF01 

          GROSS WEIGHT                                      R    029   012    3MEA03 

          UNIT OF MEASURE                                   AN   041   002    3MEA04 

          NET WEIGHT                                        R    043   012    4MEA03 

          UNIT OF MEASURE                                   AN   055   002    4MEA04 

          THEORETICAL WEIGHT                                R    057   012    5MEA03 

          UNIT OF MEASURE                                   AN   069   002    5MEA04 

          FILLER('          ')                              AN   071   010           

          Record Length:                                               080           

       Record '08' (200 x - END Record '08')                08   001   002           

          REFERENCE # TYPE                                  AN   003   002    2REF01 

          REFERENCE #                                       AN   005   017    2REF02 

          ('                                            ... AN   022   059           

          Record Length:                                               080           

                                          3
    Description                                            Type Start Length Element 

       Loop Start (200 x - End Record '10')                                          

          Record '09'                                       09   001   002           

             # OF CONTAINERS                                N    003   006    1CLD01 

             QTY PER LOAD                                   R    009   009    1CLD02 

             PACKAGING CODE                                 AN   018   005    1CLD03 

             ('                                         ... AN   023   058           

             Record Length:                                            080           

          Record '10' (600 x - END Record '10')             10   001   002           

             SHIPPING LABEL SERIAL #                        AN   003   030    5REF02 

             ('                                         ... AN   033   048           

             Record Length:                                            080           

       Record '11'                                          11   001   002           

          ORIGINAL SHIP DATE                                DT   003   006    3DTM02 

          ORIGINAL SHIP TIME                                TM   009   004    3DTM03 

          SHIP FROM ID                                      AN   013   005    5N104  

          ('                                            ... AN   018   063           

          Record Length:                                               080           

*/
	SELECT	'00' AS purpose_code, 
		''AS partial_complete,
		ISNULL(bill_of_lading.scac_transfer, shipper.ship_via) AS bill_of_lading_scac_transfer,
		bill_of_lading.scac_pickup,
		shipper.freight_type,
		shipper.staged_pallets, 
		ISNULL(shipper.aetc_number,''),
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
		COALESCE(shipper.seal_number, CONVERT(VARCHAR(25), shipper.id)), 
		shipper.destination, 
		shipper.bill_of_lading_number, 
		shipper.time_shipped, 
		bill_of_lading.equipment_initial, 
		edi_setups.equipment_description, 
		edi_setups.trading_partner_code, 
		edi_setups.supplier_code, 
		DATEPART(dy,GETDATE()) AS day_of_year,
		(SELECT	MAX(dock_code) 
		FROM	order_header,shipper_detail
		WHERE	order_header.order_no = shipper_detail.order_no AND
			shipper_detail.shipper = @shipper) AS Intermediate_consignee,
		edi_setups.id_code_type AS ford_consignee,
		ISNULL((SELECT	COUNT(DISTINCT Parent_serial) 
			FROM	audit_trail
			WHERE	audit_trail.shipper = CONVERT(VARCHAR(10),@shipper) AND
				audit_trail.type = 'S' AND 
				ISNULL(parent_serial,0) >0 ),0) AS pallets,
		ISNULL((SELECT	COUNT(serial) 
			FROM	audit_trail,
				package_materials
			WHERE	audit_trail.shipper = CONVERT(VARCHAR(10),@shipper) AND
				audit_trail.type = 'S' AND
				part <> 'PALLET' AND 
				parent_serial IS NULL AND
				audit_trail.package_type = package_materials.code AND
				package_materials.type = 'B' ),0) AS loose_ctns,
		ISNULL((SELECT	COUNT(serial) 
			FROM	audit_trail,
				package_materials
			WHERE	audit_trail.shipper =  CONVERT(VARCHAR(10),@shipper) AND
				audit_trail.type = 'S' AND 
				parent_serial IS NULL AND
				audit_trail.package_type = package_materials.code AND
				package_materials.type = 'O' ),0) AS loose_bins,
				CASE WHEN shipper.destination = 'F201C' THEN edi_setups.parent_destination ELSE COALESCE(NULLIF(shipper.shipping_dock,''),edi_setups.parent_destination) END AS fordmotor_consignee,
				edi_setups.parent_destination AS edi_shipto,
				dbo.udfGetDSTIndication(date_shipped) AS DSTIndicator,
				'CN' AS CNQualifier,
				--case when nullif(shipper.seal_number,'') is Null then '' else 'CN' end as CNQualifier,
				edi_setups.material_issuer AS Fordedi_shipto,
				CONVERT(VARCHAR(15), SUBSTRING(tm.description, PATINDEX('%~%', tm.description)+1, 3)) AS AirPortCode
				
	FROM	shipper  
	LEFT JOIN bill_of_lading  ON shipper.bill_of_lading_number = bill_of_lading.bol_number   
		JOIN edi_setups ON edi_setups.destination = shipper.destination
		LEFT JOIN dbo.trans_mode tm ON tm.code = shipper.trans_mode 
	WHERE	( shipper.destination = edi_setups.destination ) AND  
		( ( shipper.id = @shipper ) )
END





GO
