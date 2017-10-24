SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--300084614027147631




CREATE PROCEDURE [dbo].[usp_ShipNotice_Yazaki]  (@shipper INT)
AS
BEGIN

--dbo.usp_ShipNotice_Yazaki 78973


--Using TLW Form YA1_856_D_v5050_YAZAKI NORTH AMERICA SETI_130420

/*  
    FlatFile Layout for Overlay: YA1_856_D_v5050_YAZAKI NORTH AMERICA SETI     06-21-

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

       TRANSACTION SET PURPOSE CODE                         AN   003   002    1BSN01 

       SHIPMENT ID                                          AN   005   030    1BSN02 

       ASN DATE                                             DT   035   008    1BSN03 

       ASN TIME                                             TM   043   008    1BSN04 

       TRANSACTION TYPE CODE                                AN   051   002    1BSN06 

       FILLER('                            ')               AN   053   028           

       Record Length:                                                  080           

    Record '02' (4 x - End Record '02')                     02   001   002           

       DATE/TIME TYPE                                       AN   003   003    1DTM01 

       DATE                                                 DT   006   008    1DTM02 

       TIME                                                 TM   014   008    1DTM03 

       TIME CODE                                            AN   022   002    1DTM04 

       ('                                               ... AN   024   057           

       Record Length:                                                  080           

    Record '03' (40 x - End Record '03')                    03   001   002           

       WEIGHT TYPE                                          AN   003   003    2MEA02 

       WEIGHT                                               R    006   022    2MEA03 

       UNIT OF MEASURE                                      AN   028   002    2MEA040

                                          1
    Description                                            Type Start Length Element 

       ('                                               ... AN   030   051           

       Record Length:                                                  080           

    Record '04' (20 x - End Record '04')                    04   001   002           

       PACKAGING CODE                                       AN   003   005    2TD101 

       LADING QTY                                           N    008   008    2TD102 

       ('                                               ... AN   016   065           

       Record Length:                                                  080           

    Loop Start (12 x - End Record '07')                                              

       Record '05'                                          05   001   002           

          ROUTING SEQUENCE CODE                             AN   003   002    2TD501 

          ID CODE TYPE                                      AN   005   002    2TD502 

          ('                                            ... AN   007   074           

          Record Length:                                               080           

       Record '06'                                          06   001   002           

          ID CODE                                           AN   003   078    2TD503 

          Record Length:                                               080           

       Record '07'                                          07   001   002           

          TRANSPORTATION METHOD CODE                        AN   003   002    2TD504 

          ROUTING                                           AN   005   035    2TD505 

          LOCATION TYPE                                     AN   040   002    2TD507 

          LOCATION IDENTIFIER                               AN   042   030    2TD508 

          FILLER('         ')                               AN   072   009           

          Record Length:                                               080           

    Loop Start (999999 x - End Record '10')                                          

       Record '08'                                          08   001   002           

          REFERENCE ID TYPE                                 AN   003   003    3REF01 

          ('                                            ... AN   006   075           

          Record Length:                                               080           

       Record '09'                                          09   001   002           

          REFERENCE ID                                      AN   003   078    3REF02 

          Record Length:                                               080           

       Record '10'                                          10   001   002           

          ADJUSTMENT EFFECTIVE DATE                         DT   003   008    3DTM02 

          ADJUSTMENT EFFECTIVETIME                          TM   011   008    3DTM03 

                                          2
    Description                                            Type Start Length Element 

          TIME CODE                                         AN   019   002    3DTM04 

          ('                                            ... AN   021   060           

          Record Length:                                               080           

    Record '11'                                             11   001   002           

       SHIPMENT METHOD OF PAYMENT                           AN   003   002    2FOB01 

       LOCATION TYPE                                        AN   005   002    2FOB02 

       ('                                               ... AN   007   074           

       Record Length:                                                  080           

    Record '12'                                             12   001   002           

       LOCATION DESCRIPTION                                 AN   003   078    2FOB03 

       Record Length:                                                  080           

    Record '13'                                             13   001   002           

       TRANSPORTATION TERMS TYPE                            AN   003   002    2FOB04 

       TRANSPORTATION TERMS CODE                            AN   005   003    2FOB05 

       LOCATION TYPE                                        AN   008   002    2FOB06 

       ('                                               ... AN   010   071           

       Record Length:                                                  080           

    Record '14'                                             14   001   002           

       LOCATION DESCRIPTION                                 AN   003   078    2FOB07 

       Record Length:                                                  080           

    Loop Start                                                                       

       Record '15'                                          15   001   002           

          SHIP FROM ID CODE                                 AN   003   078    1N104  

          Record Length:                                               080           

       Record '16'                                          16   001   002           

          SHIP FROM NAME                                    AN   003   060    1N102  

          FILLER('                  ')                      AN   063   018           

          Record Length:                                               080           

    Loop Start                                                                       

       Record '17'                                          17   001   002           

          SHIP TO ID CODE                                   AN   003   078    2N104  

          Record Length:                                               080           

       Record '18'                                          18   001   002           

          SHIP TO NAME                                      AN   003   060    2N102  

                                          3
    Description                                            Type Start Length Element 

          FILLER('                  ')                      AN   063   018           

          Record Length:                                               080           

       Record '19' (12 x - End Record '19')                 19   001   002           

          DOCK #                                            AN   003   078    6REF02 

          Record Length:                                               080           

    Loop Start                                                                       

       Record '20'                                          20   001   002           

          REMIT TO ID CODE                                  AN   003   078    3N104  

          Record Length:                                               080           

       Record '21'                                          21   001   002           

          REMIT TO NAME                                     AN   003   060    3N102  

          FILLER('                  ')                      AN   063   018           

          Record Length:                                               080           

    Loop Start (200000 x - End Record '46')                                          

       Record '22'                                          22   001   002           

          EQUIPMENT DESC CODE                               AN   003   002    1TD301 

          EQUIPMENT INITIAL                                 AN   005   004    1TD302 

          EQUIPMENT #                                       AN   009   015    1TD303 

          GROSS WEIGHT                                      R    024   012    1TD305 

          UNIT OF MEASURE                                   AN   036   002    1TD306 

          SEAL #                                            AN   038   015    1TD309 

          EQUIPMENT TYPE                                    AN   053   004    1TD310 

          FILLER('                        ')                AN   057   024           

          Record Length:                                               080           

       Record '23'                                          23   001   002           

          CONTAINER ID                                      AN   003   078    4N104  

          Record Length:                                               080           

       Record '24'                                          24   001   002           

          CONTAINER LOCATION                                AN   003   060    4N102  

          FILLER('                  ')                      AN   063   018           

          Record Length:                                               080           

       Loop Start (200000 x - End Record '46')                                       

          Record '25'                                       25   001   002           

             BAR-CODED SERIAL #                             AN   003   078    7REF02 

                                          4
    Description                                            Type Start Length Element 

             Record Length:                                            080           

          Record '26'                                       26   001   002           

             PALLET TYPE CODE                               AN   003   002    3PAL01 

             PALLET TIERS                                   N    005   004    3PAL02 

             PALLET BLOCKS                                  N    009   004    3PAL03 

             UNIT WEIGHT                                    R    013   010    3PAL05 

             UNIT OF MEASURE                                AN   023   002    3PAL06 

             LENGTH                                         R    025   010    3PAL07 

             WIDTH                                          R    035   010    3PAL08 

             HEIGHT                                         R    045   010    3PAL09 

             UNIT OF MEASURE                                AN   055   002    3PAL10 

             GROSS WEIGHT PER PACK                          R    057   011    3PAL11 

             UNIT OF MEASURE                                AN   068   002    3PAL12 

             PALLET EXCHANGE CODE                           AN   070   001    3PAL15 

             PALLET STRUCTURE CODE                          AN   071   001    3PAL17 

             FILLER('         ')                            AN   072   009           

             Record Length:                                            080           

          Loop Start (200000 x - End Record '46')                                    

             Record '27'                                    27   001   002           

                PRODUCT/SERVICE ID TYPE                     AN   003   002    4LIN02 

                PRODUCT/SERVICE ID                          AN   005   048    4LIN03 

                PRODUCT/SERVICE ID TYPE                     AN   053   002    4LIN04 

                FILLER('                          ')        AN   055   026           

                Record Length:                                         080           

             Record '28'                                    28   001   002           

                PRODUCT/SERVICE ID                          AN   003   048    4LIN05 

                PRODUCT/SERVICE ID TYPE                     AN   051   002    4LIN06 

                FILLER('                            ')      AN   053   028           

                Record Length:                                         080           

             Record '29'                                    29   001   002           

                PRODUCT/SERVICE ID                          AN   003   048    4LIN07 

                PRODUCT/SERVICE ID TYPE                     AN   051   002    4LIN08 

                FILLER('                            ')      AN   053   028           

                Record Length:                                         080           

                                          5
    Description                                            Type Start Length Element 

             Record '30'                                    30   001   002           

                PRODUCT/SERVICE ID                          AN   003   048    4LIN09 

                PRODUCT/SERVICE ID TYPE                     AN   051   002    4LIN10 

                FILLER('                            ')      AN   053   028           

                Record Length:                                         080           

             Record '31'                                    31   001   002           

                PRODUCT/SERVICE ID                          AN   003   048    4LIN11 

                PRODUCT/SERVICE ID TYPE                     AN   051   002    4LIN12 

                FILLER('                            ')      AN   053   028           

                Record Length:                                         080           

             Record '32'                                    32   001   002           

                PRODUCT/SERVICE ID                          AN   003   048    4LIN13 

                PRODUCT/SERVICE ID TYPE                     AN   051   002    4LIN14 

                FILLER('                            ')      AN   053   028           

                Record Length:                                         080           

             Record '33'                                    33   001   002           

                PRODUCT/SERVICE ID                          AN   003   048    4LIN15 

                PRODUCT/SERVICE ID TYPE                     AN   051   002    4LIN16 

                FILLER('                            ')      AN   053   028           

                Record Length:                                         080           

             Record '34'                                    34   001   002           

                PRODUCT/SERVICE ID                          AN   003   048    4LIN17 

                PRODUCT/SERVICE ID TYPE                     AN   051   002    4LIN18 

                FILLER('                            ')      AN   053   028           

                Record Length:                                         080           

             Record '35'                                    35   001   002           

                PRODUCT/SERVICE ID                          AN   003   048    4LIN19 

                PRODUCT/SERVICE ID TYPE                     AN   051   002    4LIN20 

                FILLER('                            ')      AN   053   028           

                Record Length:                                         080           

             Record '36'                                    36   001   002           

                PRODUCT/SERVICE ID                          AN   003   048    4LIN21 

                # OF UNITS SHIPPED                          R    051   012    4SN102 

                UNIT OF MEASURE                             AN   063   002    4SN103 

                                          6
    Description                                            Type Start Length Element 

                FILLER('                ')                  AN   065   016           

                Record Length:                                         080           

             Record '37'                                    37   001   002           

                QTY SHIPPED TO DATE                         R    003   017    4SN104 

                ('                                      ... AN   020   061           

                Record Length:                                         080           

             Record '38' (1000 x - End Record '38')         38   001   002           

                RELATIONSHIP CODE                           AN   003   001    4SLN03 

                UNIT PRICE                                  R    004   019    4SLN06 

                BASIS OF UNIT PRICE CODE                    AN   023   002    4SLN07 

                ('                                      ... AN   025   056           

                Record Length:                                         080           

             Loop Start (3 x - End Record '41')                                      

                Record '39'                                 39   001   002           

                   REFERENCE ID TYPE                        AN   003   003    1REF01 

                   ('                                   ... AN   006   075           

                   Record Length:                                      080           

                Record '40'                                 40   001   002           

                   REFERENCE ID                             AN   003   078    1REF02 

                   Record Length:                                      080           

                Record '41'                                 41   001   002           

                   DESCRIPTION                              AN   003   078    1REF03 

                   Record Length:                                      080           

             Loop Start (200 x - End Record '45')                                    

                Record '42'                                 42   001   002           

                   # OF LOADS                               N    003   006    4CLD01 

                   # OF UNITS SHIPPED                       R    009   012    4CLD02 

                   PACKAGING CODE                           AN   021   005    4CLD03 

                   SIZE                                     R    026   010    4CLD04 

                   UNIT OF MEASURE                          AN   036   002    4CLD05 

                   ('                                   ... AN   038   043           

                   Record Length:                                      080           

                Loop Start (200 x - End Record '45')                                 

                   Record '43'                              43   001   002           

                                          7
    Description                                            Type Start Length Element 

                     REF TYPE                              AN   003   003    2REF01  

                     ('                                ... AN   006   075            

                     Record Length:                                   080            

                   Record '44'                              44   001   002           

                     SERIAL #                              AN   003   078    2REF02  

                     Record Length:                                   080            

                   Record '45'                              45   001   002           

                     LOT #                                 AN   003   078    2REF0402

                     Record Length:                                   080            

             Record '46'                                    46   001   002           

                SELLER INVOICE DATE                         DT   003   008    2DTM02 

                ('                                      ... AN   011   070           

                Record Length:                                         080           



*/


set ANSI_Padding on
--ASN Header

declare
	@PurposeCode char(2) = '00',
	@TradingPartner	char(12),
	@ShipperID char(30),
	@ShipperIDHeader char(30),
	@PartialComplete char(1),
	@ASNDate char(8),
	@ASNTime char(8),
	@ASNDateTime char(35),
	@ShippedDateQualifier char(3) = '011',
	@ShippedDate char(8),
	@ShippedTime char(8),
	@ShipDateTimeZone char(2),
	@ShippedDateTime char(35),
	@ArrivalDateQualifier char(3) = '017',
	@ArrivalDate char(8),
	@ArrivalTime char(8),
	@ArrivalDateTimeZone char(2),
	@ArrivalDateTime char(35),
	@GrossWeightQualifier char(3),
	@GrossWeightLbs char(22),
	@NetWeightQualifier char(3),
	@NetWeightLbs char(22),
	@TareWeightQualifier char(3),
	@TareWeightLbs char(22),
	@TD101_PackagingCode char(5),
	@TD102_PackCount char(8),
	@TD501_RoutingSequence char(2) = 'B',
	@TD502_IDCodeType char(2) = '2',
	@TD503_SCAC Char(78),
	@TD504_TransMode char(2),
	@TD507_LocType char(2) = 'OR',
	@TD508_Location char(30) = 'DTW',
	@EQD_01_TrailerNumberQual char(3) = 'TL',	
	@EQD_02_01_TrailerNumber char(17),
	@REFBMQual char(3),
	@REFPKQual char(3),
	@REFCNQual char(3),
	@REFBMValue Char(78),
	@REFPKValue Char(78),
	@REFCNValue Char(78),
	@FOB01_MethodOfPayment char(2),
	@FOB02_LocType char(2) = 'CA',
	@FOB03_LocDescription Char(77) = 'US',
	@FOB04_TransTermsType char(2) = '01',
	@FOB05_TransTermsCode char(3),
	@FOB06_LocationType char(2) = 'AC',
	@FOB07_LocationDesription Char(78) = 'TROY, MICHIGAN',
	@N102_SupplierName char(60) = 'Empire Electronics, Inc.',
	@N104_SupplierCode Char(78),
	@N102_ShipToName char(60),
	@N104_ShipToID Char(78),
	@REF02_DockCode Char(78),
	@N104_RemitToCode Char(78),
	@N102_RemitToName char(60),
	@TD301_EquipmentDesc  char(2) = 'TL' ,
	@TD302_EquipmentIntial char(4),
	@TD303_EquipmentNumber char(15),
	@TD305_GrossWeight char(12),
	@TD305_GrossWeightUM char(2) ='LB',
	@TDT03_1_TransMode char(5),
	@TD309_SealNumber char(15),
	@TD310_EquipmentType char(4),
	@N104_ContainerCode Char(77),
	@N102_ContainerLocation char(60),
	@RoutingCode char(35),
	@BuyerID char(35),
	@BuyerName char(35),
	@SellerID char(35),
	@SellerName char(75),
	@SoldToID char(35),
	@ConsolidationCenterID char(35),
	@SoldToName char(35),
	@ConsolidationCenterName char(35),
	@LOC02_DockCode char(25),
	@MEAVolumeQualifier char(3) = 'VOL',
	@MEAVolume char(22) = '4',
	@MEAVolumeUM char(2) = 'CF',
	@MEAGrossWghtQualfier char(3) = 'G',
	@MEANetWghtQualfier char(3) = 'N',
	@MEATareWghtQualfier char(3) = 'T',
	@MEALadingQtyQualfier char(3) = 'SQ',
	@MEAGrossWghtUMKG char(3) = 'KG',
	@MEANetWghtUMKG char(3) = 'KG',
	@MEALadingQtyUM char(3) = 'C62',
	@MEAGrossWghtKG char(18),
	@MEANetWghtKG  char(18), 
	@MEALadingQty char(18),
	@MEAGrossWghtLBS char(22),
	@MEANetWghtLBS  char(22),
	@MEATareWghtLBS  char(22), 
	@MEAGrossWghtUMLB char(2) = 'LB',
	@MEANetWghtUMLB char(2) = 'LB',
	@MEATareWghtUMLB char(2) = 'LB',
	@REFProNumber char(35),
	@DESADV char(10) = 'DESADV',
	@NADBuyerAdd1 char(35) = 'Yazaki Buyer Street Address' ,
	@NADSupplierAdd1 char(35) = '',
	@NADShipToAdd1 char(35) = '',
	@NADShipToID char(35),
	@SerialPrefix varchar(25)
	
	select
		@TradingPartner	= coalesce(nullif(es.trading_partner_code,''), 'YazakiTest'),
		@ShipperID =  s.id,
		@ShipperIDHeader =  s.id,
		@PartialComplete = '' ,
		@ASNDate = convert(char, getdate(), 112) ,
		@ASNTime = left(replace(convert(char, getdate(), 108), ':', ''),4),
		@ASNDateTime = rtrim(@ASNDate)+rtrim(@ASNTime),
		@ShippedDate = convert(char, s.date_shipped, 112)  ,
		@ShipDateTimeZone = [dbo].[udfGetDSTIndication](s.date_shipped),
		@ShippedTime =  left(replace(convert(char, date_shipped, 108), ':', ''),4),
		@ShippedDateTime = rtrim(@ShippedDate)+rtrim(@ShippedTime),
		@ArrivalDate = convert(char, dateadd(dd,1, s.date_shipped), 112)  ,
		@ArrivalTime =  left(replace(convert(char, date_shipped, 108), ':', ''),4),
		@ArrivalDateTimeZone = [dbo].[udfGetDSTIndication](s.date_shipped),
		@ArrivalDateTime = rtrim(@ArrivalDate)+rtrim(@ArrivalTime),
		--@MEAGrossWghtLBS = convert(char,convert(int,s.gross_weight)),
		@MEAGrossWghtLBS = convert	(char,((s.staged_objs*6 + 
																						coalesce(
																								(Select 
																								count(distinct parent_serial) 
																								from 
																								audit_trail 
																								where 
																								type = 'S' 
																								and 
																								shipper = convert(varchar(25),@shipper)
																								)*10,0)
																								))),
		--@MEANetWghtLBS = convert(char,convert(int,s.net_weight)),
		@MEANetWghtLBS = convert(char,s.staged_objs*6) ,
		@MEATareWghtLBS = convert(int,@MEAGrossWghtLBS)- convert(int,@MEANetWghtLBS),
		@MEAGrossWghtKG = convert(char,convert(int,s.gross_weight/2.2)),
		@MEANetWghtKG = convert(char,convert(int,s.net_weight/2.2)),
		@TD101_PackagingCode = 'CTN90' ,
		@TD102_PackCount = s.staged_objs,
		@TD503_SCAC = s.ship_via,
		@TD504_TransMode = coalesce(case when s.trans_mode like '%E%' then 'E' else 'LT' end,  s.trans_mode,'M'),
		@TD302_EquipmentIntial = left(coalesce('001',NULLIF(s.truck_number,''), Convert(VARCHAR(25),s.id)),3),
		@TD303_EquipmentNumber = coalesce('001', NULLIF(s.truck_number,''), Convert(VARCHAR(25),s.id)),
		@REFBMQual = 'BM' ,
		@REFPKQual = 'PK',
		@REFCNQual = 'CN',
		@REFBMValue = coalesce(bill_of_lading_number, id),
		@REFPKValue = id,
		@REFCNValue = coalesce(pro_number,''),
		@FOB01_MethodOfPayment = case when freight_type =  'Collect' then 'CC' when freight_type in  ('Consignee Billing', 'Third Party Billing') then 'TP' when freight_type  in ('Prepaid-Billed', 'PREPAY AND ADD') then 'PA' when freight_type = 'Prepaid' then 'PP' else '' end ,
		@RoutingCode = 'NA',
		@ConsolidationCenterID  = case when trans_mode like '%A%' then '' else coalesce(pool_code, '') end,
		@ConsolidationCenterName = coalesce((select max(name) from destination where destination = pool_code),''),
		@SoldToID = d.destination,
		@SoldToName =  d.name,
		@N104_ShipToID = coalesce(es.EDIShipToID, es.parent_destination, es.destination) ,
		@REF02_DockCode = coalesce(s.shipping_dock,''),
		@N102_ShipToName =  d.name,
		@SellerID =  coalesce(es.supplier_code,'Empire'),
		@SellerName = 'Empire',
		@N104_SupplierCode =  coalesce(nullif(es.supplier_code,''),'Empire'),	
		@N102_SupplierName = 'Empire',
		@BuyerID = c.customer,
		@BuyerName = 'Yazaki',
		@FOB05_TransTermsCode = case 
						when 1=1 then 'FOB'
						when s.freight_type like '%[*]%' 
						then substring(s.freight_type, patindex('%[*]%',s.freight_type)+1, 3)
						else s.freight_type
						end,
		@TD305_GrossWeight = @MEAGrossWghtLBS,
		@TD305_GrossWeightUM = 'LB',
		@TD309_SealNumber = coalesce(s.seal_number,''),
		@TD310_EquipmentType = 'LTRL',
		@SerialPrefix = coalesce(es.supplier_code,'Empire')+right(convert(varchar(4),datepart(year,getdate())),2)
	from
		Shipper s
	join
		dbo.edi_setups es on s.destination = es.destination
	join
		dbo.destination d on es.destination = d.destination
	join
		dbo.customer c on c.customer = s.customer
	
	where
		s.id = @shipper
	
	Select @TD507_LocType = case When @TD504_TransMode like 'A%' THEN  @TD507_LocType else '' end
	Select @TD508_Location = case When @TD504_TransMode like 'A%' THEN @TD508_Location else '' end

Create	table	#ASNFlatFile (
				LineId	int identity,
				LineData char(80) )

INSERT	#ASNFlatFile (LineData)
	SELECT	(	--'//STX12//X12'		--EDIFACT
						'//STX12//856'			--x12
				+		@TradingPartner 
				+		@ShipperIDHeader
				+		''--@PartialComplete
			--	+		@DESADV						--Only required for EDIFACT TP
			--	+		left(@DESADV,6) -	-Only required for EDIFACT TP
			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'01'
				+		@PurposeCode 
				+		@ShipperID 
				+		@ASNDate
				+		@ASNTime)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'02'
				+		@ShippedDateQualifier
				+		@ShippedDate
				+		@ShippedTime
				+		@ShipDateTimeZone  )

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'02'
				+		@ArrivalDateQualifier
				+		@ArrivalDate
				+		@ArrivalTime
				+		@ArrivalDateTimeZone  )


INSERT	#ASNFlatFile (LineData)
	SELECT	(	'03'
				+ @MEAGrossWghtQualfier
				+ @MEAGrossWghtLBS
				+ @MEAGrossWghtUMLB			)


INSERT	#ASNFlatFile (LineData)
	SELECT	(	'03'
				+ @MEANetWghtQualfier
				+ @MEANetWghtLBS
				+ @MEANetWghtUMLB			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'03'
				+ @MEATareWghtQualfier
				+ @MEATareWghtLBS
				+ @MEATareWghtUMLB			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'03'
				+ @MEAVolumeQualifier
				+ @MEAVolume
				+ @MEAVolumeUM			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'04'
				+ @TD101_PackagingCode
				+ @TD102_PackCount			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'05'
				+ @TD501_RoutingSequence
				+ @TD502_IDCodeType			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'06'
				+		@TD503_SCAC			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'07'
				+		@TD504_TransMode
				+		space(35) --Not Required
				+		@TD507_LocType
				+		@TD508_Location			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'08'
				+		@REFBMQual			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'09'
				+		@REFBMValue			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'11'
				+		@FOB01_MethodOfPayment
				+		@FOB02_LocType			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'12'
				+		@FOB03_LocDescription		)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'13'
				+		@FOB04_TransTermsType	
				+		@FOB05_TransTermsCode	
				+		@FOB06_LocationType				)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'14'
				+		@FOB07_LocationDesription			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'15'
				+ @N104_SupplierCode			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'16'
				+ @N102_SupplierName		)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'17'
				+ @N104_ShipToID			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'18'
				+ @N102_ShipToName	)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'19'
				+ @REF02_DockCode	)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'20'
				+ @N104_SupplierCode	)


INSERT	#ASNFlatFile (LineData)
	SELECT	(	'22'
				+ @TD301_EquipmentDesc
				+ @TD302_EquipmentIntial
				+ @TD303_EquipmentNumber
				+ @TD305_GrossWeight
				+ @TD305_GrossWeightUM
				+ @TD309_SealNumber
				+ @TD310_EquipmentType	)

--INSERT	#ASNFlatFile (LineData) Not Used
	--SELECT	(	'23'
	--			 +	@N104_ContainerCode 
	--			 +	@N102_ContainerLocation)

 --ASN Detail

declare	@ShipperDetail table (
	ID int identity(1,1),
	Part varchar(25),
	PartDescription varchar(100),
	PartUnitWeight numeric(20,6),
	CustomerPart varchar(35),
	CustomerPO varchar(35),
	CustomerECL varchar(35),
	DockCode varchar(35),
	QtyShipped int,
	Price numeric(20,6),
	AccumShipped int primary key (ID))
	
insert	@ShipperDetail 
(	Part,
	PartDescription,
	PartUnitWeight,
	CustomerPart,
	CustomerPO,
	CustomerECL,
	DockCode,
	QtyShipped,
	Price,
	AccumShipped
	)
	
select
	part_original,
	p.name,
	pinv.unit_weight,
	replace(sd.customer_part,'-',''),
	sd.customer_po,
	coalesce(oh.engineering_level,''),
	shipping_dock,
	qty_packed,
	round(sd.alternate_price,2),
	sd.accum_shipped
from
	shipper_detail sd
left join
	order_header oh on oh.order_no = sd.order_no
join
	shipper s on s.id = @shipper
join
	part p on sd.part_original = p.part
join
	part_inventory pinv on pinv.part = p.part
Where
	sd.shipper = @shipper
	
	
declare	@AuditTrailSerial table (
Part varchar(25),
PackageType varchar(35),
PartPackCount int,
SerialQuantity int,
ParentSerial int,
Serial int,
GrossWeight int, 
id int identity primary key (id))
	
insert	@AuditTrailSerial 
(	Part,
	PackageType,
	PartPackCount,
	SerialQuantity,
	ParentSerial,
	GrossWeight,
	Serial 
)
	
select
	part,
	--coalesce(pm.name,'CTN71') ,
	'CTN90',
	1,
	quantity,
	isNull(at.parent_serial,0),
	.1*quantity,
	serial
from
	dbo.audit_trail at
left join
	dbo.package_materials pm on pm.code = at.package_type
Where
	at.shipper = convert(varchar(15),@shipper) and
	at.type = 'S' and
	part != 'Pallet'
order by		isNull(at.parent_serial,0), 
						part, 
						serial


declare	@AuditTrailParentSerial table (
ParentSerial int, 
id int identity primary key (id))

INSERT @AuditTrailParentSerial
        ( ParentSerial )

SELECT	DISTINCT ParentSerial 
FROM	@AuditTrailSerial ats
WHERE	EXISTS ( SELECT 1 FROM audit_trail at2 WHERE at2.shipper = @shipper AND at2.type = 'S' AND at2.serial = ats.ParentSerial)

UPDATE @AuditTrailSerial
SET ParentSerial =  0
WHERE parentSerial NOT IN (
SELECT parentSerial FROM @AuditTrailParentSerial) 

declare	@AuditTrailPartPackGroup table (
Part varchar(25),
PackageType varchar(35),
PartPackQty int,
PartPackWeight int, 
PartPackCount int, primary key (Part, PackageType, PartPackQty))


insert	@AuditTrailPartPackGroup
(	Part,
	PackageType,
	PartPackQty,
	PartPackWeight,
	PartPackCount
)

Select 
	at.part,
	PackageType,
	SerialQuantity,
	max(SerialQuantity*PartUnitWeight),
	sum(PartPackCount)
From
	@AuditTrailSerial at
join
	@ShipperDetail sd on sd.Part = at.Part
group by
	at.part,
	at.PackageType,
	at.SerialQuantity


--declare	@AuditTrailPartPackGroupRangeID table (
--Part varchar(25),
--PackageType varchar(35),
--PartPackQty int,
--Serial int,
--RangeID int, primary key (Serial))


--insert	@AuditTrailPartPackGroupRangeID
--(	Part,
--	PackageType,
--	PartPackQty,
--	Serial,
--	RangeID
--)

--Select 
--	atl.part,
--	atl.PackageType,
--	SerialQuantity,
--	Serial,
--	Serial-id
	
--From
--	@AuditTrailSerial atL
--join
--	@AuditTrailPartPackGroup atG on
--	atG.part = atl.part and
--	atg.packageType = atl.PackageType and
--	atg.partPackQty = atl.SerialQuantity



--declare	@AuditTrailPartPackGroupSerialRange table (
--Part varchar(25),
--PackageType varchar(35),
--PartPackQty int,
--SerialRange varchar(50), primary key (SerialRange))


--insert	@AuditTrailPartPackGroupSerialRange
--(	Part,
--	PackageType,
--	PartPackQty,
--	SerialRange
--)

--Select 
--	part,
--	PackageType,
--	PartPackQty,
--	Case when min(serial) = max(serial) 
--		then convert(varchar(15), max(serial)) 
--		else convert(varchar(15), min(serial)) + ':' + convert(varchar(15), max(serial)) end
--From
--	@AuditTrailPartPackGroupRangeID atR

--group by
--	part,
--	PackageType,
--	PartPackQty,
--	RangeID


/*	Select * From @ShipperDetail
	Select * From @AuditTrailLooseSerial
	Select * From @AuditTrailPartPackGroupRangeID
	Select * From @AuditTrailPartPackGroup
	Select * From @AuditTrailPartPackGroupSerialRange
*/


--Delcare Variables for ASN Details		

declare	
	@LineItemID char(6),
	@REF02_PalletSerial Char(78),
	@PAL01_PalletPackType char(2) = 0,
	@PAL02_PalletTiers char(4),
	@PAL03_PalletBlocks char(4),
	@PAL05_PalletTareWeight char(10) = 10,
	@PAL06_PalletTareWeightUM char(2) = 'LB',
	@PAL07_Length char(10),
	@PAL08_Width char(10),
	@PAL09_Height char(10),
	@PAL10_DimUM char(2),
	@PAL11_PalletGrossWeight char(11),
	@PAL12_PalletGrossWeightUM char(2) = 'LB',
	@LIN02_BPIDtype char(2) = 'BP',
	@LIN02_CustomerPart char(48) ,
	@LIN02_VPIDtype char(2) = 'VP',
	@LIN02_VendorPart char(48) ,
	@LIN02_PDIDtype char(2) = 'PD',
	@LIN02_PartDescription char(48) ,
	@LIN02_POIDtype char(2) = 'PO',
	@LIN02_CustomerPO char(48) ,
	@LIN02_CHIDtype char(2) = 'CH',
	@LIN02_CountryOfOrigin char(48) = 'HN' ,
	@SN102_QuantityShipped char(12),
	@SN103_QuantityShippedUM char(2) = 'PC',
	@SN104_AccumQuantityShipped char(17),
	@SLN01_AssignedID char(20) = '001',
	@SLN03_RelationshipCode char(1) = 'I',
	@SLN06_UnitPrice char(19),
	@SLN07_UnitPriceCode char(2) = 'PE',
	@REF02_PackingSlipID Char(77) = @shipper,
	@REF03_PackingSlipDescription Char(78),
	@REF01_IVIDType char(3) = 'IV',
	@REF01_PKIDType char(3) = 'PK',
	@REF02_InvoiceIDID Char(78),
	@CLD01_LoadCount char(6),
	@CLD02_PackQuantity char(12),
	@CLD03_PackCode char(5),
	@CLD04_PackGrossWeight char(10),
	@CLD05_PackGrossWeightUM char(2) = 'LB',
	@REF02_ObjectSerial Char(78) ,
	@REF02_ObjectSerialQual Char(3) = 'SE',
	@REF04_ObjectLot Char(78) ,
	@DTM02_InvoiceDate char(8) ,
	@Part varchar(50),
	@SupplierPart char(35),
	@SupplierPartQual char(3),
	@CountryOfOrigin char(3),
	@PartQty char(12),
	@PartAccum char(12),
	@PartUM char(3),
	@CustomerPO char(35),
	@CustomerECL char(35),
	@CustomerECLQual char(3),
	@PackageType varchar(15),
	@DunnagePackType char(17),
	@DunnageCount char(10),
	@DunnageIdentifier char(3),
	@PartPackQty char(17),
	@PartPackCount char(10),
	@PCIQualifier char(3),
	@Serial char(20),
	@DockCode char(25),
	@PCI_S char(3),
	@PCI_M char(3),
	@SupplierSerial char(35),
	@CPS03 Char(3),
	@UM char(3),
	@PalletSerial int,
	@InternalPart varchar(25),
	@PackQty int
	 
--Populate Static Variables
select	@CountryOfOrigin = 'HN'
select	@PartUM = 'PC'	
select	@PCI_S = 'S'
select	@PCI_M = 'M'
Select	@DunnageIdentifier = '37'
Select	@DunnagePackType = 'YazakiDunnage'
Select	@UM = 'C62'
Select  @PCIQualifier = '17'
Select 	@CPS03 = 1
Select	@SupplierPartQual = 'SA'
Select	@CustomerECLQual = 'DR'
Select	@REF02_InvoiceIDID = @shipper
Select	@REF02_PackingSlipID = @shipper
 			
declare
	PalletSerial cursor local for

SELECT
	DISTINCT
	CASE WHEN ATPS.ParentSerial > 0 THEN ATPS.ParentSerial ELSE 0 END
FROM
	@AuditTrailSerial ATS
LEFT JOIN
	@AuditTrailParentSerial ATPS ON ATPS.parentSerial = ATS.parentSerial

open
	PalletSerial

while
	1 = 1 begin
	
	fetch
		PalletSerial
	into
		@PalletSerial
			
	if	@@FETCH_STATUS != 0 begin
		break
	end

		If @PalletSerial > 0 begin

		Select @PAL11_PalletGrossWeight = (count(Serial)*6)+10 From @AuditTrailSerial where ParentSerial = @PalletSerial
		Select @PAL05_PalletTareWeight =  10 From @AuditTrailSerial where ParentSerial = @PalletSerial
		Select @REF02_PalletSerial = @SerialPrefix + convert(varchar(25),[FT].[fn_ZeroPad](@PalletSerial,9))
		

		Insert	#ASNFlatFile (LineData)
		Select '25'
				+		@REF02_PalletSerial 
				
		Insert	#ASNFlatFile (LineData)
		Select '26'
				+		@PAL01_PalletPackType
				+		space(8)
				+		@PAL05_PalletTareWeight
				+		@PAL06_PalletTareWeightUM
				+		space(32)
				+		@PAL11_PalletGrossWeight
				+		@PAL12_PalletGrossWeightUM
		End
				

		declare Part cursor local for
			select
				Distinct
				sd.Part,
				sd.Part,
				sd.PartDescription,
				sd.CustomerPart,
				sd.CustomerPO				
			From
				@ShipperDetail sd
			Join
				@AuditTrailSerial at on at.Part = sd.part
			where
				at.ParentSerial = @PalletSerial
												
			open
				Part

			while
				1 = 1 begin
							
				fetch
					Part
				into
					@LIN02_VendorPart,
					@InternalPart,
					@LIN02_PartDescription,
					@LIN02_CustomerPart,
					@LIN02_CustomerPO
								
																								
				IF	@@FETCH_STATUS != 0 BEGIN
					BREAK
				END

						SELECT
								@SN102_QuantityShipped = SUM(at.SerialQuantity)
							FROM
								@AuditTrailSerial at
						WHERE
								at.ParentSerial = @PalletSerial AND
								at.Part = @InternalPart

						SELECT @SLN06_UnitPrice = MAX(Price) 
								FROM 
									@ShipperDetail sd
						WHERE 
								sd.part = @InternalPart
																										
					INSERT	#ASNFlatFile (LineData)
					SELECT  '27' 									
							+ @LIN02_BPIDtype
							+ @LIN02_CustomerPart
							+ @LIN02_VPIDtype
							
					INSERT	#ASNFlatFile (LineData)
					SELECT  '28' 									
							+ @LIN02_VendorPart
							+ @LIN02_PDIDtype
							
					INSERT	#ASNFlatFile (LineData)
					SELECT  '29' 									
							+ @LIN02_PartDescription
							+ @LIN02_POIDtype

					INSERT	#ASNFlatFile (LineData)
					SELECT  '30' 									
							+ @LIN02_CustomerPO
		
					INSERT	#ASNFlatFile (LineData)
					SELECT  '36'
							+	SPACE(48)								
							+ @SN102_QuantityShipped
							+ @SN103_QuantityShippedUM

				INSERT	#ASNFlatFile (LineData)
					SELECT  '38'
							+	@SLN03_RelationshipCode							
							+   @SLN06_UnitPrice
							+	@SLN07_UnitPriceCode

				
				INSERT	#ASNFlatFile (LineData)
					SELECT  '39'
							+	@REF01_IVIDType						
							
				INSERT	#ASNFlatFile (LineData)
					SELECT  '40'
							+	@REF02_PackingSlipID	
							
					INSERT	#ASNFlatFile (LineData)
					SELECT  '39'
							+	@REF01_PKIDType						
							
				INSERT	#ASNFlatFile (LineData)
					SELECT  '40'
							+	@REF02_PackingSlipID		
						
							DECLARE PartPack CURSOR LOCAL FOR

							SELECT	
								DISTINCT
										PackageType,
										SerialQuantity
								FROM
									@AuditTrailSerial
								WHERE
									Part = @InternalPart AND
									ParentSerial = @PalletSerial
		
								OPEN
									PartPack

								WHILE
									1 = 1 BEGIN
																					
									FETCH
										PartPack
									INTO
										@PackageType,
										@PackQty
																							
									IF	@@FETCH_STATUS != 0 BEGIN
										BREAK
									END
										
										SELECT	@CLD01_LoadCount = COUNT(serial),
														@CLD02_PackQuantity = MAX(SerialQuantity),
														@CLD03_PackCode = MAX(PackageType),
														@CLD04_PackGrossWeight = 6,
														@CLD05_PackGrossWeightUM = 'LB'
												FROM
														@AuditTrailSerial
												WHERE
														Part = @InternalPart AND
														ParentSerial = @PalletSerial AND
														SerialQuantity = @PackQty AND
														PackageType = @PackageType

															
																									
										INSERT	#ASNFlatFile (LineData)
										SELECT  '42' 
														+		@CLD01_LoadCount
														+		@CLD02_PackQuantity
														+		@CLD03_PackCode
														+		@CLD04_PackGrossWeight
														+		@CLD05_PackGrossWeightUM

													DECLARE PartPackSerial CURSOR LOCAL FOR

												SELECT	
														@SerialPrefix + CONVERT(VARCHAR(25),[FT].[fn_ZeroPad](Serial,9))
														FROM
																@AuditTrailSerial
														WHERE
																Part = @InternalPart AND
																ParentSerial = @PalletSerial AND
																SerialQuantity = @PackQty AND
																PackageType = @PackageType
		
												OPEN
												PartPackSerial

												WHILE
												1 = 1 BEGIN
																					
												FETCH
												PartPackSerial
												INTO
												@REF02_ObjectSerial
																							
												IF	@@FETCH_STATUS != 0 BEGIN
												BREAK
											END
																		
												INSERT	#ASNFlatFile (LineData)
												SELECT  '43' 
														+		@REF02_ObjectSerialQual	+ SPACE(10)												
												INSERT	#ASNFlatFile (LineData)
												SELECT  '44' 
														+		@REF02_ObjectSerial
													

												END
												CLOSE		
												PartPackSerial
												DEALLOCATE	
												PartPackSerial

																	
									END																					
									CLOSE
										PartPack
									DEALLOCATE
										PartPack
							
						SELECT @DTM02_InvoiceDate = RTRIM(@ShippedDate)	
						INSERT	#ASNFlatFile (LineData)
						SELECT		'46' 
						+				@DTM02_InvoiceDate
																						
					END							
					CLOSE
						Part
					DEALLOCATE
						Part
		
	
END		
CLOSE
	PalletSerial 
DEALLOCATE
	PalletSerial


SELECT 
	CASE 
	WHEN LEFT(lineData,2) = '43'
	THEN
	LEFT(LineData,77) + CONVERT(CHAR(3), (lineID ))
	ELSE 
	LEFT(LineData,80)  END
	
FROM 
	#ASNFlatFile
ORDER BY 
	LineID

	
	      
SET ANSI_PADDING OFF	
END
         
















GO
