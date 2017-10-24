SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[ftsp_NALPlexASN]  (@shipper INT)
AS
BEGIN
--[dbo].[ftsp_NALPlexASN] 97739
 
  /*  FlatFile Layout for Overlay: PLX_856_D_v4010_PLEX ONLINE STI_131029     02-06-15 

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

       PURPOSE CODE                                         AN   003   002    1BSN01 

       SHIPMENT ID                                          AN   005   030    1BSN02 

       SHIP NOTICE DATE                                     DT   035   008    1BSN03 

       SHIP NOTICE TIME                                     TM   043   008    1BSN04 

       FILLER('                              ')             AN   051   030           

       Record Length:                                                  080           

    Record '02' (10 x - End Record '02')                    02   001   002           

       SHIPPED DATE                                         DT   003   008    1DTM02 

       SHIPPED TIME                                         TM   011   008    1DTM03 

       TIME CODE                                            AN   019   002    1DTM04 

       ('                                               ... AN   021   060           

       Record Length:                                                  080           

    Record '03' (2 x - End Record '03')                     03   001   002           

       REF ID CODE                                          AN   003   002    1MEA01 

       TYPE                                                 AN   005   003    1MEA02 

       VALUE                                                R    008   022    1MEA03 

       UOM                                                  AN   030   002    1MEA040

       ('                                               ... AN   032   049           

                                          1
    Description                                            Type Start Length Element 

       Record Length:                                                  080           

    Record '04' (20 x - End Record '04')                    04   001   002           

       PACKAGING CODE                                       AN   003   005    1TD101 

       LADING QTY                                           N    008   008    1TD102 

       ('                                               ... AN   016   065           

       Record Length:                                                  080           

    Record '05'                                             05   001   002           

       SCAC CODE                                            AN   003   078    1TD503 

       Record Length:                                                  080           

    Record '06'                                             06   001   002           

       TRANSPORTATION METHOD                                AN   003   002    1TD504 

       ('                                               ... AN   005   076           

       Record Length:                                                  080           

    Record '07' (12 x - End Record '07')                    07   001   002           

       EQUIPMENT DESC CODE                                  AN   003   002    1TD301 

       EQUIPMENT INITIAL                                    AN   005   004    1TD302 

       EQUIPMENT #                                          AN   009   010    1TD303 

       ('                                               ... AN   019   062           

       Record Length:                                                  080           

    Record '08' (3 x - End Record '08')                     08   001   002           

       REF ID TYPE                                          AN   003   003    1REF01 

       REF ID CODE                                          AN   006   030    1REF02 

       ...('                                             ') AN   036   045           

       Record Length:                                                  080           

    Record '09'                                             09   001   002           

       SHIPMENT METHOD OF PAYMENT                           AN   003   002    1FOB01 

       ('                                               ... AN   005   076           

       Record Length:                                                  080           

    Loop Start (200 x - End Record '12')                                             

       Record '10'                                          10   001   002           

          ENTITY ID CODE                                    AN   003   003    1N101  

          ID CODE TYPE                                      AN   006   002    1N103  

          ('                                            ... AN   008   073           

          Record Length:                                               080           

                                          2
    Description                                            Type Start Length Element 

       Record '11'                                          11   001   002           

          ID CODE                                           AN   003   078    1N104  

          Record Length:                                               080           

       Record '12'                                          12   001   002           

          NAME                                              AN   003   060    1N102  

          FILLER('                  ')                      AN   063   018           

          Record Length:                                               080           

    Record '13'                                             13   001   002           

       SELLING PARTY CURRENCY CODE                          AN   003   003    1CUR02 

       ('                                               ... AN   006   075           

       Record Length:                                                  080           

    Loop Start (200000 x - End Record '22')                                          

       Record '14'                                          14   001   002           

          # OF LOADS                                        N    003   006    3CLD01 

          # OF UNITS SHIPPED                                R    009   012    3CLD02 

          PACKAGING CODE                                    AN   021   005    3CLD03 

          ('                                            ... AN   026   055           

          Record Length:                                               080           

       Record '15' (200 x - End Record '15')                15   001   002           

          REFERENCE ID TYPE                                 AN   003   003    4REF01 

          HEAT CODE / MASTER UNIT SERIAL #                  AN   006   030    4REF02 

          ('                                             ') AN   036   045           

          Record Length:                                               080           

       Loop Start (200000 x - End Record '22')                                       

          Record '16'                                       16   001   002           

             PRODUCT/SERVICE ID TYPE                        AN   003   002    1LIN02 

             PRODUCT/SERVICE ID                             AN   005   048    1LIN03 

             PRODUCT/SERVICE ID TYPE                        AN   053   002    1LIN04 

             FILLER('                          ')           AN   055   026           

             Record Length:                                            080           

          Record '17'                                       17   001   002           

             PRODUCT/SERVICE ID                             AN   003   048    1LIN05 

             PRODUCT/SERVICE ID TYPE                        AN   051   002    1LIN06 

             FILLER('                            ')         AN   053   028           

                                          3
    Description                                            Type Start Length Element 

             Record Length:                                            080           

          Record '18'                                       18   001   002           

             PRODUCT/SERVICE ID                             AN   003   048    1LIN07 

             ASSIGNED ID                                    AN   051   020    1SN101 

             FILLER('          ')                           AN   071   010           

             Record Length:                                            080           

          Record '19'                                       19   001   002           

             # OF UNITS SHIPPED                             R    003   012    1SN102 

             UOM CODE                                       AN   015   002    1SN103 

             QTY SHIPPED TO DATE                            R    017   017    1SN104 

             PO #                                           AN   034   022    1PRF01 

             FILLER('                         ')            AN   056   025           

             Record Length:                                            080           

          Record '20'                                       20   001   002           

             RELEASE #                                      AN   003   030    1PRF02 

             ('                                         ... AN   033   048           

             Record Length:                                            080           

          Loop Start (200 x - End Record '22')                                       

             Record '21'                                    21   001   002           

                # OF LOADS                                  N    003   006    1CLD01 

                # OF UNITS SHIPPED                          R    009   012    1CLD02 

                PACKAGING CODE                              AN   021   005    1CLD03 

                UOM CODE                                    AN   026   002    1CLD05 

                ('                                      ... AN   028   053           

                Record Length:                                         080           

             Record '22' (200 x - End Record '22')          22   001   002           

                REF ID TYPE                                 AN   003   003    2REF01 

                REF ID                                      AN   006   025    2REF02 

                ('                                      ... AN   031   050           

                Record Length:                                         080           








                                          4

		*/

set ANSI_Padding on
--ASN Header

declare
	@TradingPartner	char(12),
	@ShipperID char(30),
	@ShipperID2 char(8),
	--@PartialComplete char(1) = 'P',
	@PartialComplete char(1) = '',
	@PurposeCode char(2) ='00',
	@ASNDate char(8),
	@ASNTime char(8),
	@ShippedDateQual char(3),
	@ShippedDate char(8),
	@ShippedTime char(8),
	@EstArrivalDateQual char(3),
	@EstArrivalDate char(8),
	@EstArrivalTime char(8),
	@TimeZone char(2),
	@WeightRefIDCode CHAR(2) = 'WT',
	@GrossWeightQualifier char(3) = 'G',
	@GrossWeightLbs char(22),
	@NetWeightQualifier char(3) = 'N',
	@NetWeightLbs char(22),
	@WeightUM char(2) = 'LB',
	@CompositeUM char(78),
	@PackagingCode char(5) = 'CTN90',
	@PackCount char(8),
	@SCAC char(78),
	@TransMode char(2),
	@LocationQualifier char(2),
	@PPCode char(30),
	@EquipDesc char(2),
	@EquipInit char(4),
	@TrailerNumber char(10),
	@REFBMQual char(3) = 'BM',
	@REFPKQual char(3) = 'PK',
	@REFPKQual2 char(3),
	@REFCNQual char(3) = 'CN',
	@REFBMValue char(30),
	@REFPKValue char(30),
	@REFCNValue char(30),
	@FOB char(2),
	@ProNumber char(16),
	@SealNumber char(8),
	@SupplierName char(35),
	@SupplierCode char(17),
	@ShipToName char(35),
	@ShipToID char(17),
	@ShipToQualifier char(3) = 'ST',
	@ShipFromQualifier char(3) = 'SF',
	@SupplierQualifier char(3) ='SU',	
	@ShipToIDType char(2) ='92',	
	@ShipFromIDType char(2) = '92',
	@SupplierIDType char(2) = '92',
	@AETCResponsibility char(1),
	@AETC char(8),
	@DockCode char(8),
	@PoolCode char(30),
	@EquipInitial char(4),
	@TransitDays int,
	@SCACQualifier char(2)
	
	select
		@TradingPartner	= es.trading_partner_code ,
		@ShipperID =  s.id,
		@ShipperID2 =  s.id,
		--@PartialComplete = '' ,
		@PurposeCode = '00',
		@ASNDate = convert(char, getdate(), 112) ,
		@ASNTime = left(replace(convert(char, getdate(), 108), ':', ''),4),
		@ShippedDateQual = '011',
		@ShippedDate = convert(char, s.date_shipped, 112)  ,
		@ShippedTime =  left(replace(convert(char, date_shipped, 108), ':', ''),4),
		@TimeZone = [dbo].[udfGetDSTIndication](date_shipped),
		@EstArrivalDateQual = '017',
		@GrossWeightLbs = convert(char,convert(int,s.gross_weight)),
		@NetWeightLbs = convert(char,convert(int,s.net_weight)),
		@PackagingCode = 'CTN90' ,
		@PackCount = s.staged_objs,
		@SCAC = s.ship_via,
		@SCACQualifier = '2',
		@TransMode = s.trans_mode ,
		@TrailerNumber = coalesce(nullif(s.truck_number,''), convert(varchar(25),s.id)),
		@REFBMQual = 'BM' ,
		@REFPKQual = 'PK',
		@REFPKQual2 = 'PK',
		@REFCNQual = 'CN',
		@REFBMValue = coalesce(bill_of_lading_number, id),
		@REFPKValue = id,
		@REFCNValue = COALESCE(nullif(pro_number,''),  convert(varchar(25), s.id)),
		@FOB = case when freight_type =  'Collect' then 'CC' when freight_type in  ('Consignee Billing', 'Third Party Billing') then 'TP' when freight_type  in ('Prepaid-Billed', 'PREPAY AND ADD') then 'PA' when freight_type = 'Prepaid' then 'PP' else 'CC' end ,
		@SupplierName = 'Empire Electronics, Inc.' ,
		@SupplierCode = coalesce(es.supplier_code, 'US0811') ,
		@SupplierIDtype = case when datalength(es.supplier_code) =  9 then 1 else 92 end, 
		@ShipFromIDtype = case when datalength(es.supplier_code) =  9 then 1 else 92 end, 
		@ShipToName =  d.name,
		@ShipToID = COALESCE(nullif(es.EDIShipToID,''),nullif(es.parent_destination,''),es.destination),
		@ShipToIDtype = case when datalength(COALESCE(nullif(es.parent_destination,''),es.destination)) =  9 then 1 else 92 end, 
		@SupplierQualifier = 'SU',
		@ShipFromQualifier = 'SF',
		@ShipToQualifier = 'ST',		
		@AETCResponsibility = case when upper(left(aetc_number,2)) = 'CE' then 'A' when upper(left(aetc_number,2)) = 'SR' then 'S' when upper(left(aetc_number,2)) = 'CR' then 'Z' else '' end,
		@AETC =coalesce(s.aetc_number,''),
		@LocationQualifier =case when s.trans_mode in ('A', 'AC','AE') then 'OR'  when isNull(nullif(pool_code,''),'-1') = '-1' then '' else 'PP' end,
		@PoolCode = case when s.trans_mode in ('A', 'AC','AE') then Left(s.pro_number,3)  when s.trans_mode in ('E', 'U') then '' else coalesce(pool_code,'') end,
		@EquipDesc = coalesce( es.equipment_description, 'TL' ),
		@EquipInitial = coalesce( bol.equipment_initial, s.ship_via ),
		@SealNumber = coalesce(s.seal_number,''),
		@Pronumber = coalesce(s.pro_number,''),
		@DockCode = coalesce(s.shipping_dock, ''),
		@GrossWeightQualifier = 'G',
		@NetWeightQualifier = 'N',
		@WeightUM = 'LB',
		@CompositeUM = 'LB',
		@TransitDays = case when id_code_type like '%[A-Z]%' then 0 else convert(int, isNull(nullif(id_code_type,''),0)) end 
		
	from
		Shipper s
	join
		dbo.edi_setups es on s.destination = es.destination
	join
		dbo.destination d on es.destination = d.destination
	left join
		dbo.bill_of_lading bol on s.bill_of_lading_number = bol_number
	where
		s.id = @shipper
	
	
select  @EstArrivalDate = dateadd(dd, @TransitDays, @shippedDate)
select	@EstArrivalTime = @ShippedTime


Create	table	#ASNFlatFile (
				LineId	int identity (1,1),
				LineData char(79))

INSERT	#ASNFlatFile (LineData)
	SELECT	('//STX12//856'+  @TradingPartner + @ShipperID+ @PartialComplete )
INSERT	#ASNFlatFile (LineData)
	SELECT	('01'+  @PurposeCode + @ShipperID + @ASNDate + @ASNTime   )
INSERT	#ASNFlatFile (LineData)
	SELECT	('02' +  @ShippedDate + @ShippedTime + @TimeZone)
INSERT	#ASNFlatFile (LineData)
	SELECT	('03' + @WeightRefIDCode + @GrossWeightQualifier + @GrossWeightLbs + @WeightUM )
INSERT	#ASNFlatFile (LineData)
	SELECT	('03' + @WeightRefIDCode + @NetWeightQualifier + @NetWeightLbs + @WeightUM )
INSERT	#ASNFlatFile (LineData)
	SELECT	('04' + @PackagingCode + @PackCount  )	
INSERT	#ASNFlatFile (LineData)
	SELECT	('05' + @SCAC  )
INSERT	#ASNFlatFile (LineData)
	SELECT	('06' + @TransMode )
INSERT	#ASNFlatFile (LineData)
	SELECT	('07' + @EquipDesc + @EquipInitial + @TrailerNumber )
INSERT	#ASNFlatFile (LineData)
	SELECT	('08' + @REFPKQual + @REFPKValue   )
INSERT	#ASNFlatFile (LineData)
	SELECT	('08' + @REFBMQual + @REFBMValue   )
INSERT	#ASNFlatFile (LineData)
	SELECT	('08' + @REFCNQual + @REFCNValue   )
INSERT	#ASNFlatFile (LineData)
	SELECT	('09' + @FOB   )
INSERT	#ASNFlatFile (LineData)
	SELECT	('10' + @ShipToQualifier  + @ShipToIDType  )
INSERT	#ASNFlatFile (LineData)
	SELECT	('11' + @ShipToID  )
INSERT	#ASNFlatFile (LineData)
	SELECT	('12' + @ShipToName  )
INSERT	#ASNFlatFile (LineData)
	SELECT	('10' + @SupplierQualifier  + @SupplierIDType  )
INSERT	#ASNFlatFile (LineData)
	SELECT	('11' + @SupplierCode  )
INSERT	#ASNFlatFile (LineData)
	SELECT	('12' + @SupplierName  )


 --ASN Detail

DECLARE	@ShipperDetail TABLE (
	Part VARCHAR(25),
	PackingSlip VARCHAR(25),
	ShipperID INT,
	CustomerPart VARCHAR(35),
	CustomerPart_loop VARCHAR(35),
	CustomerPO VARCHAR(35),
	SDQty INT,
	SDAccum INT,
	EngLevel VARCHAR(25),
	PRIMARY KEY (Part, PackingSlip, CustomerPart)
	)

INSERT @ShipperDetail
			( Part ,
			PackingSlip ,
			ShipperID,
			CustomerPart ,
			CustomerPart_loop,
			CustomerPO ,
			SDQty ,
			SDAccum ,
			EngLevel 
          
        )	
SELECT
	LEFT(sd.part_original,7),
	sd.shipper,
	sd.shipper,
	sd.Customer_Part,
	sd.customer_part,
	Max(COALESCE(sd.Customer_PO,'')),
	SUM(sd.alternative_qty),	
	MAX(sd.Accum_Shipped),
	COALESCE(oh.engineering_level,'')
	
FROM
	shipper s
JOIN
	dbo.shipper_detail sd ON s.id  = sd.shipper AND sd.shipper =  @shipper
LEFT JOIN
	order_header oh ON sd.order_no = oh.order_no
WHERE part NOT LIKE 'CUM%'
GROUP BY
	LEFT(sd.part_original,7),
	sd.shipper,
	sd.shipper,
	sd.Customer_Part,
	COALESCE(oh.engineering_level,'')

	
	
	
DECLARE	@ShipperSerials TABLE (
	Part VARCHAR(25),
	CustomerPart varchar(50),
	PackageType VARCHAR(25),
	PackQty INT,
	Serial INT
	PRIMARY KEY (Part, Serial)
	)

INSERT @ShipperSerials          
        	
SELECT
	LEFT(at.part,7),
	sd.customer_part,
	'CTN90',
	quantity,
	at.serial
	
FROM
	audit_trail at
Join
	shipper_detail sd on convert(varchar(15), sd.shipper ) = at. shipper and sd.part_original = at.part
WHERE
	at.type ='S'  AND at.shipper =  CONVERT(VARCHAR(15), @shipper)
AND 
	at.part != 'PALLET' 

	


--Select		*	from		@shipperDetail order by packingslip
--Select		*	from		@shipperserials

--Delcare Variables for ASN Details		
DECLARE	
	@CustomerPartBP CHAR(2),
	@CustomerPartEC CHAR(2),
	@CustomerPOPO CHAR(2),
	@CustomerPart CHAR(48) ,
	@CustomerECL CHAR(48),
	@Part VARCHAR(25),
	@CustomerPart_Loop VARCHAR(35),
	@QtyPacked CHAR(12),
	@UM CHAR(2),
	@AccumShipped CHAR(17),
	@CustomerPO CHAR(48),
	@CustomerPOPRF CHAR(22),
	@ContainerCount CHAR(6),
	@PackageType CHAR(5),
	@PackQty CHAR(12),
	@SerialNumber CHAR(25),
	@SerialNumberLS CHAR(3) ='LS'
	
SELECT @CustomerPartEC = 'EC'
SELECT @CustomerPartBP = 'BP'
SELECT @CustomerPOPO = 'PO'
SELECT @UM = 'EA'
	

DECLARE
	PartPOLine CURSOR LOCAL FOR
SELECT
			Part ,
	        CustomerPart ,
	        CustomerPart_loop,
	        CustomerPO ,
			CustomerPO,
	        SDQty ,
	        'EA',
	        SDAccum ,
	        EngLevel
FROM
	@ShipperDetail SD
	ORDER BY
		CustomerPart

OPEN
	PartPOLine
WHILE
	1 = 1 BEGIN
	
	FETCH
		PartPOLine
	INTO
		@Part ,
		@CustomerPart ,
		@CustomerPart_Loop,
		@CustomerPO,
		@CustomerPOPRF,
		@QtyPacked,
		@UM,
		@AccumShipped,
		@CustomerECL 
			
	IF	@@FETCH_STATUS != 0 BEGIN
		BREAK
	END
	
	--print @ASNOverlayGroup
	
		INSERT	#ASNFlatFile (LineData)
		SELECT	('16'+ @CustomerpartBP + @CustomerPart + @CustomerPOPO  )
		
		INSERT	#ASNFlatFile (LineData)
		SELECT	('17' +  @CustomerPO + @CustomerPartEC    )

		INSERT	#ASNFlatFile (LineData)
		SELECT	('18' +  @CustomerECL    )

		INSERT	#ASNFlatFile (LineData)
		SELECT	('19' +  @QtyPacked  + @UM + @AccumShipped + @CustomerPOPRF  )
		
		
				
				DECLARE PackType CURSOR LOCAL FOR
				SELECT	
							Part,
							PackageType ,
							SUM(1) ,
							PackQty
				FROM
					@ShipperSerials
				WHERE					
					part = @Part and
					customerPart =  @CustomerPart_Loop
					
				GROUP BY
					part,
					PackageType,
					PackQty
							
					OPEN	PackType

					WHILE	1 = 1 
					BEGIN
					FETCH	PackType	INTO
					@Part,
					@PackageType,
					@ContainerCount,
					@PackQty					
					
					IF	@@FETCH_STATUS != 0 BEGIN
					BREAK
					END
									
					INSERT	#ASNFlatFile (LineData)
					SELECT	('21'+ @ContainerCount +   @PackQty +  @PackageType )
					
					
					
									DECLARE PackSerial CURSOR LOCAL FOR
									SELECT	
										'AAV'+ CONVERT(VARCHAR(25),Serial)
									FROM
										@ShipperSerials
									WHERE					
										part = @Part AND
										PackageType = @PackageType AND
										PackQty = @PackQty AND
										CustomerPart = @Customerpart_Loop
									
									OPEN	PackSerial
									WHILE	1 = 1 
									BEGIN
									FETCH	PackSerial	INTO
									@SerialNumber
					
									IF	@@FETCH_STATUS != 0 BEGIN
									BREAK
									END
									
									INSERT	#ASNFlatFile (LineData)
									SELECT	('22'+ @SerialNumberLS +  @SerialNumber   )
					
									END
									CLOSE PackSerial
									DEALLOCATE PackSerial
										
						
					END
					CLOSE PackType
					DEALLOCATE PackType
				
		
						
END
CLOSE	PartPOLine 
DEALLOCATE	PartPOLine
	


CREATE	TABLE
	#ASNResultSet (FFdata  CHAR(80))


INSERT
	#ASNResultSet (FFdata)
SELECT
	CONVERT(CHAR(80), LineData) 
FROM	
  #ASNFlatFile
	
SELECT	FFdata
FROM	#ASNResultSet


      
SET ANSI_PADDING OFF	
END
         
















GO
