SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO












CREATE PROCEDURE [dbo].[ftsp_ShipNotice_v4010_STOI_VALEO_SAP]  (@shipper INT)
AS
BEGIN
--[dbo].[ftsp_ShipNotice_v4010_STOI_VALEO_SAP] 106152
 
  /*  
    FlatFile Layout for Overlay: IT0_856_D_v4010_VALEO STOI_141124     01-07-16 11:40

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

       SHIPMENT ID                                          AN   003   010    1BSN02 

       ASN DATE                                             DT   013   008    1BSN03 

       ASN TIME                                             TM   021   008    1BSN04 

       ('                                               ... AN   029   052           

       Record Length:                                                  080           

    Record '02' (10 x - End Record '02')                    02   001   002           

       SHIPPED DATE                                         DT   003   008    1DTM02 

       SHIPPED TIME                                         TM   011   008    1DTM03 

       TIME CODE                                            AN   019   002    1DTM04 

       ('                                               ... AN   021   060           

       Record Length:                                                  080           

    Record '03' (40 x - End Record '03')                    03   001   002           

       MEASUREMENT ID CODE                                  AN   003   002    3MEA01 

       MEASUREMENT TYPE                                     AN   005   001    3MEA02 

       MEASUREMENT VALUE                                    R    006   009    3MEA03 

       UOM                                                  AN   015   002    3MEA040

       ('                                               ... AN   017   064           

       Record Length:                                                  080           

                                          1
    Description                                            Type Start Length Element 

    Record '04' (20 x - End Record '04')                    04   001   002           

       PACKAGING CODE                                       AN   003   005    3TD101 

       LADING QUANTITY                                      N    008   008    3TD102 

       ('                                               ... AN   016   065           

       Record Length:                                                  080           

    Record '05' (12 x - End Record '05')                    05   001   002           

       CARRIER SCAC CODE                                    AN   003   004    3TD503 

       TRANSPORTATION METHOD/TYPE CODE                      AN   007   002    3TD504 

       ('                                               ... AN   009   072           

       Record Length:                                                  080           

    Record '06' (12 x - End Record '06')                    06   001   002           

       EQUIPMENT DESCRIPTION CODE                           AN   003   002    3TD301 

       EQUIPMENT INITIAL                                    AN   005   004    3TD302 

       EQUIPMENT NUMBER                                     AN   009   007    3TD303 

       ('                                               ... AN   016   065           

       Record Length:                                                  080           

    Record '07' (12 x - End Record '07')                    07   001   002           

       BILL OF LADING                                       AN   003   030    3REF02 

       ('                                                ') AN   033   048           

       Record Length:                                                  080           

    Record '08' (200 x - End Record '08')                   08   001   002           

       ENTITY ID                                            AN   003   002    3N101  

       BUYER ASSIGNED ID                                    AN   005   006    3N104  

       NAME                                                 AN   011   060    3N102  

       FILLER('          ')                                 AN   071   010           

       Record Length:                                                  080           

    Loop Start (200000 x - End Record '14')                                          

       Record '09'                                          09   001   002           

          PRODUCT/SERVICE ID TYPE                           AN   003   002    1LIN02 

          PRODUCT/SERVICE ID                                AN   005   015    1LIN03 

          PRODUCT/SERVICE ID QUALIFIER                      AN   020   002    1LIN04 

          PRODUCT/SERVICE ID                                AN   022   015    1LIN05 

          PRODUCT/SERVICE ID QUALIFIER                      AN   037   002    1LIN06 

          PRODUCT/SERVICE ID                                AN   039   015    1LIN07 

                                          2
    Description                                            Type Start Length Element 

          NO. OF UNITS SHIPPED                              R    054   009    1SN102 

          UOM                                               AN   063   002    1SN103 

          QUANTITY SHIPPED TO DATE                          R    065   011    1SN104 

          FILLER('     ')                                   AN   076   005           

          Record Length:                                               080           

       Record '10' (200 x - End Record '10')                10   001   002           

          DOCK CODE                                         AN   003   030    1REF02 

          ('                                            ... AN   033   048           

          Record Length:                                               080           

       Loop Start (200000 x - End Record '14')                                       

          Record '11'                                       11   001   002           

             HIERARCHICAL LEVEL CODE                        AN   003   002    2HL03  

             ('                                         ... AN   005   076           

             Record Length:                                            080           

          Record '12' (200 x - End Record '12')             12   001   002           

             MASTER LABEL SERIAL #                          AN   003   030    2REF02 

             ('                                         ... AN   033   048           

             Record Length:                                            080           

          Loop Start (200000 x - End Record '14')                                    

             Record '13'                                    13   001   002           

                NO. OF UNITS SHIPPED                        R    003   009    2SN102 

                UOM                                         AN   012   002    2SN103 

                ('                                      ... AN   014   067           

                Record Length:                                         080           

             Record '14' (200 x - End Record '14')          14   001   002           

                REF ID TYPE                                 AN   003   002    4REF01 

                REF ID                                      AN   005   030    4REF02 

                ('                                      ... AN   035   046           

                Record Length:                                         080           










                                          3

		*/

set ANSI_Padding on
--ASN Header

declare
	@TradingPartner	char(12),
	@ShipperID char(30),
	@ShipperID2 char(10),
	@PartialComplete char(1),
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
	@WeightRefIDCode CHAR(2) = 'PD',
	@GrossWeightQualifier char(1) = 'G',
	@GrossWeightLbs char(9),
	@NetWeightQualifier char(1) = 'N',
	@NetWeightLbs char(9),
	@WeightUM char(2) = 'LB',
	@CompositeUM char(78),
	@PackagingCode char(5) = 'CTN90',
	@PackCount char(8),
	@SCAC char(4),
	@TransMode char(2),
	@LocationQualifier char(2),
	@PPCode char(30),
	@EquipDesc char(2),
	@EquipInit char(4),
	@TrailerNumber char(7),
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
	@SupplierName char(60),
	@SupplierCode char(6),
	@VarSupplierCode varchar(6),
	@ShipToName char(60),
	@ShipToID char(6),
	@ShipToQualifier char(2) = 'ST',
	@ShipFromQualifier char(2) = 'SF',
	@SupplierQualifier char(2) ='SU',	
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
		@PartialComplete = '' ,
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
		@PackagingCode = 'PLT71' ,
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
		@SupplierCode = LEFT(coalesce(es.supplier_code, '834'),6) ,
		@VarSupplierCode = LEFT(coalesce(es.supplier_code, '834'),6) ,
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
	SELECT	('01'+  @ShipperID2 + @ASNDate + @ASNTime   )
INSERT	#ASNFlatFile (LineData)
	SELECT	('02' +  @ShippedDate + @ShippedTime + @TimeZone)
INSERT	#ASNFlatFile (LineData)
	SELECT	('03' + @WeightRefIDCode + @GrossWeightQualifier + @GrossWeightLbs + @WeightUM )
INSERT	#ASNFlatFile (LineData)
	SELECT	('03' + @WeightRefIDCode + @NetWeightQualifier + @NetWeightLbs + @WeightUM )
INSERT	#ASNFlatFile (LineData)
	SELECT	('04' + @PackagingCode + @PackCount  )	
INSERT	#ASNFlatFile (LineData)
	SELECT	('05' + @SCAC + @TransMode )
INSERT	#ASNFlatFile (LineData)
	SELECT	('06' + @EquipDesc + @EquipInitial + @TrailerNumber )
INSERT	#ASNFlatFile (LineData)
	SELECT	('07'  + @REFBMValue   )
INSERT	#ASNFlatFile (LineData)
	SELECT	('08' + @ShipToQualifier +  @ShipToID +   @ShipToName )
INSERT	#ASNFlatFile (LineData)
	SELECT	('08' + @SupplierQualifier +  @SupplierCode +  @SupplierName )


 --ASN Detail

DECLARE	@ShipperDetail TABLE (
	Part VARCHAR(25),
	PackingSlip VARCHAR(25),
	ShipperID INT,
	CustomerPart VARCHAR(35),
	CustomerPO VARCHAR(35),
	SDQty INT,
	SDAccum INT,
	EngLevel VARCHAR(25),
	DockCode varchar(30),
	PRIMARY KEY (Part, PackingSlip)
	)

INSERT @ShipperDetail
			( Part ,
			PackingSlip ,
			ShipperID,
			CustomerPart ,
			CustomerPO ,
			SDQty ,
			SDAccum ,
			EngLevel ,
			DockCode
          
        )	
SELECT
	LEFT(sd.part_original,7),
	sd.shipper,
	sd.shipper,
	sd.Customer_Part,
	Max(COALESCE(sd.Customer_PO,'')),
	SUM(sd.alternative_qty),	
	MAX(sd.Accum_Shipped),
	max(COALESCE(oh.engineering_level,'')),
	MAX(COALESCE(oh.dock_code,''))
	
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
	sd.Customer_Part
	--,COALESCE(oh.engineering_level,'')

	
	
	
DECLARE	@ShipperSerials TABLE (
	Part VARCHAR(25),
	PackageType VARCHAR(25),
	PackQty INT,
	Serial INT,
	ParentSerial INT,
	MasterSerial INT,
	PRIMARY KEY (Part, Serial)
	)

INSERT @ShipperSerials          
        	
SELECT
	LEFT(at.part,7),
	'PLT71',
	quantity,
	at.serial,
	coalesce(nullif(at.parent_serial,0),0),
	FirstSerial
	
FROM
	audit_trail at
OUTER APPLY
	( Select top 1 serial*10 as FirstSerial from audit_trail at2 where left(at2.part,7) =  left(at.part,7) and coalesce(nullif(at2.parent_serial,0),0) = coalesce(nullif(at.parent_serial,0),0) and at2.shipper = at.shipper and at2.type = 'S' order by at2.serial)  FirstPartSerialPerPallet
WHERE
	at.type ='S'  AND at.shipper =  CONVERT(VARCHAR(10), @shipper)
AND 
	at.part != 'PALLET' 

	


--Select		*	from		@shipperDetail order by packingslip
--Select		*	from		@shipperserials

--Delcare Variables for ASN Details		
DECLARE	
	@CustomerPartBP CHAR(2),
	@CustomerPartEC CHAR(2),
	@CustomerPOPO CHAR(2),
	@CustomerPart CHAR(15) ,
	@CustomerECL CHAR(15),
	@Part VARCHAR(25),
	@QtyPacked CHAR(9),
	@UM CHAR(2),
	@AccumShipped CHAR(11),
	@CustomerPO CHAR(15),
	@CustomerPOPRF CHAR(22),
	@ContainerCount CHAR(6),
	@PackageType CHAR(5),
	@PackQty CHAR(9),
	@ParentSerialNumber int,
	@PalletSerialNumber CHAR(30),
	@FirstSerialNumber VARCHAR(30),
	@SerialNumber VARCHAR(30),
	@SupFirstSerialNumber CHAR(30),
	@SupSerialNumber CHAR(30),
	@SerialNumberLS CHAR(2) ='LS',
	@LineItemDockCode CHAR(30)
	
SELECT @CustomerPartEC = 'EC'
SELECT @CustomerPartBP = 'BP'
SELECT @CustomerPOPO = 'PO'
SELECT @UM = 'EA'
	

DECLARE
	PartPOLine CURSOR LOCAL FOR
SELECT
			Part ,
	        CustomerPart ,
	        CustomerPO ,
			CustomerPO,
	        SDQty ,
	        'EA',
	        SDAccum ,
	        EngLevel,
	        DockCode
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
		@CustomerPO,
		@CustomerPOPRF,
		@QtyPacked,
		@UM,
		@AccumShipped,
		@CustomerECL,
		@LineItemDockCode
			
	IF	@@FETCH_STATUS != 0 BEGIN
		BREAK
	END
	
	--print @ASNOverlayGroup
	
		INSERT	#ASNFlatFile (LineData)
		SELECT	('09'+ @CustomerpartBP + @CustomerPart + @CustomerPOPO + @CustomerPO + @CustomerPartEC + @CustomerECL  + @QtyPacked  + @UM + @AccumShipped )
		
		INSERT	#ASNFlatFile (LineData)
		SELECT	('10' +  @LineItemDockCode )
		
		
			DECLARE PalletSerials CURSOR LOCAL FOR
				SELECT DISTINCT
				ParentSerial,
				MasterSerial
				FROM
					@ShipperSerials
				WHERE					
					part = @Part 
					
				OPEN	PalletSerials

					WHILE	1 = 1 
					BEGIN
					FETCH	PalletSerials	INTO
					@ParentSerialNumber,
					@FirstSerialNumber

					Select @SupFirstSerialNumber = @VarSupplierCode + @FirstSerialNumber
					
					IF	@@FETCH_STATUS != 0 BEGIN
					BREAK
					END
					

					INSERT	#ASNFlatFile (LineData)
					SELECT	('11'+ 'O ')
									
					INSERT	#ASNFlatFile (LineData)
					SELECT	('12'+ @SupFirstSerialNumber)
		
				
				DECLARE PackType CURSOR LOCAL FOR
				SELECT	Part ,
							PackageType ,
							SUM(1) ,
							PackQty
				FROM
					@ShipperSerials
				WHERE					
					part = @Part and
					parentSerial = @ParentSerialNumber
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
					SELECT	('13'+  @PackQty +  'PC' )
					
					
					
									DECLARE PackSerial CURSOR LOCAL FOR
									SELECT	
										CONVERT(VARCHAR(25),Serial)
									FROM
										@ShipperSerials
									WHERE					
										part = @Part AND
										PackageType = @PackageType AND
										PackQty = convert(int, @PackQty) AND
										ParentSerial = @ParentSerialNumber
									
									OPEN	PackSerial
									WHILE	1 = 1 
									BEGIN
									FETCH	PackSerial	INTO
									@SerialNumber

									Select @SupSerialNumber = right( ((@VarSupplierCode+@SerialNumber)) , 14 )
					
									IF	@@FETCH_STATUS != 0 BEGIN
									BREAK
									END
									
									
									
									INSERT	#ASNFlatFile (LineData)
									SELECT	('14'+ @SerialNumberLS +  @SupSerialNumber   )
									
									Select @SupSerialNumber = ''
									END
									CLOSE PackSerial
									DEALLOCATE PackSerial
										
						
					END
					CLOSE PackType
					DEALLOCATE PackType

			Select @SupFirstSerialNumber = ''		
			
			END
			CLOSE PalletSerials
			DEALLOCATE PalletSerials			
		
						
END
CLOSE	PartPOLine 
DEALLOCATE	PartPOLine
	


CREATE	TABLE
	#ASNResultSet (FFdata  CHAR(77),
								FFID INT IDENTITY(1,1))


INSERT
	#ASNResultSet (FFdata)
SELECT
	CONVERT(CHAR(77), LineData) 
FROM	
  #ASNFlatFile
	
SELECT 	FFdata + CONVERT(CHAR(3), FFID) 
FROM	#ASNResultSet


      
SET ANSI_PADDING OFF	
END
         




















GO
