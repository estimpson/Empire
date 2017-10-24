SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE PROCEDURE [dbo].[LearASN]  (@shipper INT)
AS
BEGIN
--[dbo].[LearASN] 105941

--TLW Form LR9_856_D_v3010_LEAR CORP SI ACCUM_100903

/*


    FlatFile Layout for Overlay: LR9_856_D_v3010_LEAR CORP SI ACCUM_100903     05-12-

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

       DATE                                                 DT   035   006    1BSN03 

       TIME                                                 TM   041   004    1BSN04 

       SHIPPED DATE                                         DT   045   006    1DTM02 

       SHIPPED TIME                                         TM   051   006    1DTM03 

       TIME ZONE CODE                                       AN   057   002    1DTM04 

       FILLER('                      ')                     AN   059   022           

       Record Length:                                                  080           

    Record '02' (2 x - End Record '02')                     02   001   002           

       MEASUREMENT TYPE                                     AN   003   003    1MEA02 

       MEASUREMENT VALUE                                    R    006   012    1MEA03 

       UNIT OF MEASURE                                      AN   018   002    1MEA04 

       ('                                               ... AN   020   061           

       Record Length:                                                  080           

    Record '03' (20 x - End Record '03')                    03   001   002           

       PACKAGING CODE                                       AN   003   005    1TD101 

       LADING QUANTITY                                      N    008   008    1TD102 

                                          1
    Description                                            Type Start Length Element 

       ('                                               ... AN   016   065           

       Record Length:                                                  080           

    Record '04'                                             04   001   002           

       ROUTING SEQUENCE CODE                                AN   003   002    1TD501 

       SCAC                                                 AN   005   004    1TD503 

       TRANSPORTATION METHOD                                AN   009   002    1TD504 

       EQUIPMENT DESCRIPTION CODE                           AN   011   002    1TD301 

       TRUCK/TRAILER #                                      AN   013   010    1TD303 

       BILL OF LADING                                       AN   023   030    1REF02 

       FILLER('                            ')               AN   053   028           

       Record Length:                                                  080           

    Record '05'                                             05   001   002           

       PACKING SLIP #                                       AN   003   030    2REF02 

       SHIPMENT METHOD OF PAYMENT                           AN   033   002    1FOB01 

       ID CODE TYPE                                         AN   035   002    2N103  

       SHIP TO CODE                                         AN   037   020    2N104  

       FILLER('                        ')                   AN   057   024           

       Record Length:                                                  080           

    Loop Start (2 x - End Record '06')                                               

       Record '06'                                          06   001   002           

          ENTITY ID TYPE                                    AN   003   002    1N101  

          ID CODE TYPE                                      AN   005   002    1N103  

          SHIP FROM/SUPPLIER CODE                           AN   007   030    1N104  

          .('                                            ') AN   037   044           

          Record Length:                                               080           

    Loop Start (200000 x - End Record '08')                                          

       Record '07'                                          07   001   002           

          PRODUCT ID TYPE                                   AN   003   002    2LIN02 

          PRODUCT/ SERVICE ID                               AN   005   030    2LIN03 

          PRODUCT/SERVICE ID TYPE                           AN   035   002    2LIN04 

          PRODUCT/SERVICE ID                                AN   037   030    2LIN05 

          PRODUCT/SERVICE ID TYPE                           AN   067   002    2LIN06 

          # OF UNITS SHIPPED                                R    069   012    2SN102 

          Record Length:                                               080           

                                          2
    Description                                            Type Start Length Element 

       Record '08'                                          08   001   002           

          UNIT OF MEASURE                                   AN   003   002    2SN103 

          QUANTITY SHIPPED TO DATE                          R    005   011    2SN104 

          LEAR PO #                                         AN   016   022    2PRF01 

          ..('                                           ') AN   038   043           

          Record Length:                                               080           




*/

set ANSI_Padding on
--ASN Header

declare
	@TradingPartner	char(12), --Lear
	@ShipperID char(30), --Lear
	@ShipperID2 char(8),
	@PartialComplete char(1),
	@PurposeCode char(2),
	@ASNDate char(6), --Lear
	@ASNTime char(4), --Lear
	@ShippedDateQual char(3),
	@ShippedDate char(6), --Lear
	@ShippedTime char(4), --Lear
	@EstArrivalDateQual char(3),
	@EstArrivalDate char(8),
	@EstArrivalTime char(8),
	@TimeZone char(2), --Lear
	@GrossWeightQualifier char(3), --Lear
	@GrossWeightLbs char(12), --Lear
	@NetWeightQualifier char(3), --Lear
	@NetWeightLbs char(12), --Lear
	@WeightUM char(2),
	@CompositeUM char(78),
	@PackagingCode char(5), --Lear
	@PackCount char(8), --Lear
	@RoutingSequenceCode char(2) = 'B', --Lear
	@SCAC char(4), --Lear
	@TransMode char(2), --Lear
	@LocationQualifier char(2),
	@PPCode char(30),
	@EquipDesc char(2) = 'TL', --Lear
	@EquipInit char(4),
	@TrailerNumber char(10), --Lear (Had to modify TLW form to adhere to Lear spec; inovis had max datalength of 4 chars...spec states 10 chars)
	@REFBMQual char(2),
	@REFPKQual char(2),
	@REFPKQual2 char(3),
	@REFCNQual char(2),
	@REFBMValue char(30), --Lear
	@REFPKValue char(30), --Lear
	@REFCNValue char(30),
	@FOB01 char(2), --Lear >>>Shipper.freight_type
	@ProNumber char(16),
	@SealNumber char(8),
	@SupplierName char(35),
	@SupplierCode char(17),
	@ShipToName char(35),
	@ShipToID char(20), --Lear
	@ShipFromID char(20), --Lear
	@ShipToQualifier char(2), --Lear
	@ShipFromQualifier char(2) , --Lear
	@SupplierQualifier char(2),	
	@ShipToIDType char(2),	
	@ShipFromIDType char(2), --Lear
	@SupplierIDType char(2),
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
		@ASNDate = convert(char, getdate(), 12) ,
		@ASNTime = left(replace(convert(char, getdate(), 108), ':', ''),4),
		@ShippedDateQual = '011',
		@ShippedDate = convert(char, s.date_shipped, 12)  ,
		@ShippedTime =  left(replace(convert(char, date_shipped, 108), ':', ''),4),
		@TimeZone = [dbo].[udfGetDSTIndication](date_shipped),
		@EstArrivalDateQual = '017',
		@GrossWeightLbs = CASE WHEN convert(int,coalesce(s.gross_weight,1)) <= convert(int,coalesce(s.net_weight,1)) THEN  convert(char,convert(int,coalesce(s.gross_weight,1))+convert(int,coalesce(s.net_weight,1))) ElsE convert(char,convert(int,coalesce(s.gross_weight,1)))END,
		@NetWeightLbs = convert(char,convert(int,coalesce(s.net_weight,1))),
		@PackagingCode = 'CTN25' ,
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
		@REFCNValue = pro_number,
		@FOB01 = case when freight_type =  'Collect' then 'CC' when freight_type in  ('Consignee Billing', 'Third Party Billing') then 'TP' when freight_type  in ('Prepaid-Billed', 'PREPAY AND ADD') then 'PA' when freight_type = 'Prepaid' then 'PP' else 'CC' end ,
		@SupplierName = 'Empire Electronics, Inc.' ,
		@SupplierCode = coalesce(es.supplier_code, 'US0811') ,
		@ShipFromID = coalesce(es.supplier_code, '047380894') ,
		@SupplierIDtype = case when datalength(es.supplier_code) =  9 then 1 else 92 end, 
		@ShipFromIDtype = case when datalength(es.supplier_code) =  9 then 1 else 92 end, 
		@ShipToName =  d.name,
		@ShipToID = COALESCE(nullif(es.parent_destination,''),es.destination),
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


Create	table	#ASNFlatFileHeader (
				LineId	int identity (1,1),
				DetailLineID int,
				LineData char(80))

--INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
--SELECT	('//STX12//856'+  @TradingPartner + @ShipperID + @PartialComplete ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('01'+  @PurposeCode + @ShipperID + @ASNDate + @ASNTime + @ShippedDate + @ShippedTime + @TimeZone  ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('02' + @GrossWeightQualifier + @GrossWeightLbs + @WeightUM ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('02' + @NetWeightQualifier + @NetWeightLbs + @WeightUM  ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('03' + @PackagingCode + @PackCount ),1	
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('04' + @RoutingSequenceCode + @SCAC + @TransMode +   @EquipDesc +  @TrailerNumber + @REFBMValue ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('05' +  @REFPKValue + @FOB01 + @ShipToQualifier + @ShiptoID ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('06' + @ShipFromQualifier + @ShipFromIDType + @ShipFromID ),1



 --ASN Detail

declare	@ShipperDetail table (
	Part varchar(25),
	PackingSlip varchar(25),
	ShipperID int,
	CustomerPart varchar(35),
	CustomerPO varchar(35),
	SDQty int,
	SDAccum int,
	EngLevel varchar(25),
	primary key (Part, PackingSlip)
	)

INSERT @ShipperDetail
			( Part ,
			PackingSlip ,
			ShipperID,
			CustomerPart ,
			CustomerPO ,
			SDQty ,
			SDAccum ,
			EngLevel 
          
        )	
SELECT
	sd.part_original,
	sd.shipper,
	sd.shipper,
	sd.Customer_Part,
	COALESCE(sd.Customer_PO,''),
	sd.alternative_qty,	
	sd.Accum_Shipped,
	COALESCE(oh.engineering_level,'')
	
FROM
	shipper s
JOIN
	dbo.shipper_detail sd ON s.id  = sd.shipper AND sd.shipper =  @shipper
LEFT JOIN
	order_header oh ON sd.order_no = oh.order_no
WHERE part NOT LIKE 'CUM%'

	
	
	
DECLARE	@ShipperSerials TABLE (
	Part VARCHAR(25),
	PackageType VARCHAR(25),
	PackCount INT,
	PackQty INT,
	Serial INT
	PRIMARY KEY (Part, Serial)
	)

INSERT @ShipperSerials          
        	
SELECT
	at.part,
	'PLT71',
	COUNT(DISTINCT parent_serial),
	SUM(quantity),
	at.parent_serial
	
FROM
	audit_trail at
WHERE
	at.type ='S'  AND at.shipper =  CONVERT(VARCHAR(10), @shipper)
AND 
	at.part != 'PALLET' 
AND
	NULLIF(at.parent_serial,0) IS NOT NULL
AND NOT EXISTS 
	(SELECT 1 FROM audit_trail at2 WHERE at2.type = 'S'  AND at2.shipper = CONVERT(VARCHAR(10), @shipper) AND at2.parent_serial = at.parent_serial AND at2.part!=at.part)
GROUP BY 
	at.part,
	at.parent_serial
	
UNION        
        	
SELECT
	at.part,
	'CTN90',
	COUNT(1),
	MAX(quantity),
	at.serial 
	
FROM
	audit_trail at
WHERE
	at.type ='S'  AND at.shipper =  CONVERT(VARCHAR(10), @shipper)
AND 
	at.part != 'PALLET' 
AND
	NULLIF(at.parent_serial,0) IS NULL
GROUP BY
	at.part,
	at.serial
	
ORDER BY 1 ASC, 2 DESC, 3 ASC, 4 ASC

--Select		*	from		@shipperDetail order by packingslip
--Select		*	from		@shipperserials

--Delcare Variables for ASN Details		
DECLARE	
	@CustomerPartBP CHAR(2),
	@VendorPartVP CHAR(2),
	@CustomerPart CHAR(30) ,
	@VendorPart CHAR(30),
	@CustomerECL CHAR(40),
	@Part VARCHAR(25),
	@QtyPacked CHAR(12),
	@UM CHAR(2),
	@AccumShipped CHAR(11),
	@CustomerPO CHAR(22),
	@ContainerCount CHAR(6),
	@PackageType CHAR(5),
	@PackQty CHAR(12),
	@SerialNumber CHAR(30)
	
SELECT @VendorPartVP = 'VP'
SELECT @CustomerPartBP = 'BP'
SELECT @UM = 'EA'
	
CREATE	TABLE	#FlatFileLines (
				LineId	INT IDENTITY(1,1),
				DetailLineID INT,
				LineData CHAR(80)
				 )

DECLARE
	PartPOLine CURSOR LOCAL FOR
SELECT
			Part ,
	        CustomerPart ,
	        CustomerPO ,
	        SDQty ,
	        'EA',
	        SDAccum ,
			part
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
		@QtyPacked,
		@UM,
		@AccumShipped,
		@VendorPart 
			
	IF	@@FETCH_STATUS != 0 BEGIN
		BREAK
	END
	
	--print @ASNOverlayGroup
	
	INSERT	#FlatFileLines (LineData, DetailLineID)
		SELECT	('07'+ @CustomerpartBP + @CustomerPart + +@VendorPartVP + @VendorPart+ SPACE(2) + @QtyPacked   ),2
		
		INSERT	#FlatFileLines (LineData, DetailLineID)
		SELECT	('08' +   @UM + @AccumShipped + @CustomerPO     ),2
		
		
				
				DECLARE PackType CURSOR LOCAL FOR
				SELECT	Part ,
							PackageType ,
							SUM(PackCount) ,
							PackQty
				FROM
					@ShipperSerials
				WHERE					
					part = @Part 
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
									
					--INSERT	#FlatFileLines (LineData)
					--SELECT	('09'+ @ContainerCount +   @PackQty +  @PackageType )
					
					
					
									DECLARE PackSerial CURSOR LOCAL FOR
									SELECT	
										Serial
									FROM
										@ShipperSerials
									WHERE					
										part = @Part AND
										PackageType = @PackageType AND
										PackQty = @PackQty
									
									OPEN	PackSerial
									WHILE	1 = 1 
									BEGIN
									FETCH	PackSerial	INTO
									@SerialNumber
					
									IF	@@FETCH_STATUS != 0 BEGIN
									BREAK
									END
									
									--INSERT	#FlatFileLines (LineData)
									--SELECT	('15'+  @SerialNumber   )
					
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
	#ASNResultSet (FFdata  CHAR(80), DetailLineID INT, LineID INT)

INSERT #ASNResultSet
        ( FFdata, DetailLIneID, LineID )

SELECT
	CONVERT(CHAR(80), LineData), DetailLineID, LineID
FROM	
	#ASNFlatFileHeader

INSERT
	#ASNResultSet (FFdata, DetailLineID, LineID)
SELECT
	CONVERT(CHAR(79), LineData) +  CONVERT(CHAR(1), LineID) , DetailLineID, LineID
FROM	
	#FlatFileLines
	
SELECT	FFdata
FROM		#ASNResultSet
ORDER BY DetailLineID, LineID ASC

      
SET ANSI_PADDING OFF	
END
         












GO
