SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE	procedure [dbo].[ftsp_ShipNotice_VSL]  (@shipper int)
as
begin
--[dbo].[ftsp_ShipNotice_VSL] 55483



set ANSI_Padding on
--ASN Header

declare
	@TradingPartner	char(12),
	@ShipperID char(30),
	@ShipperID2 char(10),
	@PartialComplete char(1),
	@PurposeCode char(2),
	@ASNDate char(6),
	@ASNTime char(8),
	@ShippedDate char(6),
	@ShippedTime char(8),
	@TimeZone char(2),
	@GrossWeightQualifier char(1),
	@GrossWeightLbs char(9),
	@NetWeightQualifier char(1),
	@NetWeightLbs char(9),
	@WeightUM char(2),
	@PackagingCode char(5),
	@PackCount char(6),
	@SCAC char(4),
	@TransMode char(2),
	@LocationQualifier char(2),
	@PPCode char(30),
	@EquipDesc char(2),
	@EquipInit char(4),
	@TrailerNumber char(7),
	@REFBMQual char(3),
	@REFPKQual char(3),
	@REFCNQual char(3),
	@REFBMValue char(20),
	@REFPKValue char(30),
	@REFCNValue char(30),
	@FOB char(2),
	@ProNumber char(16),
	@SealNumber char(8),
	@SupplierSU char(2) = 'SU',
	@ShipToST char(2) = 'ST',
	@ShipFromSF char(2) = 'SF',
	@SupplierName char(35),
	@SupplierCode char(6),
	@ShipToName char(35),
	@ShipToID char(6),	
	@AETCResponsibility char(1),
	@AETC char(8),
	@DockCode char(8),
	@PoolCode char(30),
	@EquipInitial char(4)
	
	select
		@TradingPartner	= es.trading_partner_code ,
		@ShipperID =  s.id,
		@ShipperID2 =  s.id,
		@PartialComplete = '' ,
		@PurposeCode = '00',
		@ASNDate = convert(char, getdate(), 12) ,
		@ASNTime = left(replace(convert(char, getdate(), 108), ':', ''),4),
		@ShippedDate = convert(char, s.date_shipped,12)  ,
		@ShippedTime =  left(replace(convert(char, date_shipped, 108), ':', ''),4),
		@TimeZone = [dbo].[udfGetDSTIndication](date_shipped),
		@GrossWeightLbs = convert(char,convert(int,s.gross_weight)),
		@NetWeightLbs = convert(char,convert(int,s.net_weight)),
		@PackagingCode = 'CTN25' ,
		@PackCount = s.staged_objs,
		@SCAC = s.ship_via,
		@TransMode = s.trans_mode ,
		@TrailerNumber = coalesce(nullif(s.truck_number,''), CONVERT(VARCHAR(25), s.id)),
		@REFBMQual = 'BM' ,
		@REFPKQual = 'PK',
		@REFCNQual = 'CN',
		@REFBMValue = coalesce(bill_of_lading_number, id),
		@REFPKValue = id,
		@REFCNValue = pro_number,
		@FOB = case when freight_type =  'Collect' then 'CC' when freight_type in  ('Consignee Billing', 'Third Party Billing') then 'TP' when freight_type  in ('Prepaid-Billed', 'PREPAY AND ADD') then 'PA' when freight_type = 'Prepaid' then 'PP' else 'CC' end ,
		@SupplierName = 'Empire Electronics, Inc.' ,
		@SupplierCode = left(coalesce(es.supplier_code, '047380894'),6) ,
		@ShipToName =  d.name,
		@ShipToID = left(COALESCE(nullif(es.parent_destination,''),es.destination),6),
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
		@WeightUM = 'LB'
		
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
	

Create	table	#ASNFlatFileHeader (
				LineId	int identity (1,1),
				LineData char(80))

INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('//STX12//856'+  @TradingPartner + @ShipperID+ @PartialComplete )
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('01' + @ShipperID2 + @ASNDate + @ASNTime  )
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('02'  + @ShippedDate + @ShippedTime + @TimeZone + @GrossWeightLbs + @NetWeightLbs+ @PackCount + @SCAC  + @TransMode )
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('03'  + @GrossWeightQualifier + @GrossWeightLbs + @WeightUM  )
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('03'  + @NetWeightQualifier + @NetWeightLbs + @WeightUM  )
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('04' + @PackagingCode + @PackCount)
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('05'  + @SCAC  + @TransMode  )
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('06'  + @EquipDesc + @EquipInitial + @TrailerNumber )
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('07'  + @ShipperID  )
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('08'  + @SupplierSU + @SupplierCode   )
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('08'  + @ShipToST + @ShipToID   )
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('08'  + @ShipFromSF + @SupplierCode   )
	





 --ASN Detail

declare	@ShipperDetail table (
	Part varchar(25),
	PackingSlip varchar(25),
	ShipperID int,
	CustomerPart varchar(35),
	CustomerPO varchar(35),
	ShippingDock varchar(25),
	SDQty int,
	SDAccum int,
	EngLevel varchar(25),
	PRIMARY KEY (Part, CustomerPart, PackingSlip)
	)

INSERT @ShipperDetail
			( Part ,
			PackingSlip ,
			ShipperID,
			CustomerPart ,
			CustomerPO ,
			ShippingDock,
			SDQty ,
			SDAccum ,
			EngLevel 
          
        )	
SELECT
	LEFT(sd.part_original,7),
	sd.shipper,
	sd.shipper,
	sd.Customer_Part,
	MAX(sd.Customer_PO),
	MAX(oh.dock_code),
	SUM(sd.alternative_qty),	
	MAX(sd.Accum_Shipped),
	MAX(COALESCE(oh.engineering_level,''))
	
FROM
	shipper s
JOIN
	dbo.shipper_detail sd ON s.id  = sd.shipper AND sd.shipper =  @shipper
JOIN
	order_header oh ON sd.order_no = oh.order_no
GROUP BY
	LEFT(sd.part_original,7),
	sd.shipper,
	sd.shipper,
	sd.Customer_Part

	
	
	
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
	LEFT(at.part,7),
	'CTN90',
	1,
	quantity,
	at.serial 
	
FROM
	audit_trail at
WHERE
	at.type ='S'  AND at.shipper =  CONVERT(VARCHAR(10), @shipper)
AND 
	at.part != 'PALLET' 

	
ORDER BY 1 ASC, 2 DESC, 3 ASC, 4 ASC

--Select		*	from		@shipperDetail order by packingslip
--Select		*	from		@shipperserials

--Delcare Variables for ASN Details		
DECLARE	
	@CustomerPartBP CHAR(2) = 'BP',
	@CustomerPartEC CHAR(2) = 'EC',
	@CustomerPOPO CHAR(2) = 'PO',
	@CustomerPart CHAR(15) ,
	@CustomerPO CHAR(15) ,
	@CustomerECL CHAR(15),
	@Part VARCHAR(25),
	@QtyPacked CHAR(9),
	@UM CHAR(2) ,
	@AccumShipped CHAR(11),
	@DockCodeDetail CHAR(30),
	@ContainerCount CHAR(6),
	@PackageType CHAR(5),
	@PackQty CHAR(9),
	@SerialQualifier CHAR(2) = 'LS',
	@SerialNumber CHAR(30)
	
	
CREATE	TABLE	#FlatFileLines (
				LineId	INT IDENTITY(200,1),
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
	        ShippingDock,
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
		@CustomerPO,
		@QtyPacked,
		@UM,
		@DockCodeDetail,
		@AccumShipped,
		@CustomerECL 
			
	IF	@@FETCH_STATUS != 0 BEGIN
		BREAK
	END
	
	--print @ASNOverlayGroup
	
	INSERT	#FlatFileLines (LineData)
		SELECT	('09'+ @CustomerPartBP +  @CustomerPart + @CustomerPOPO + @CustomerPO + @CustomerPartEC + @CustomerECL + @QtyPacked + @UM+ @AccumShipped  )
		
		INSERT	#FlatFileLines (LineData)
		SELECT	('10' +  @DockCodeDetail   )
		
				
				DECLARE PackType CURSOR LOCAL FOR
				SELECT
						DISTINCT
							Part ,
							PackageType ,
							PackQty
				FROM
					@ShipperSerials
				WHERE					
					part = @Part 
									
					OPEN	PackType

					WHILE	1 = 1 
					BEGIN
					FETCH	PackType	INTO
					@Part,
					@PackageType,
					@PackQty					
					
					IF	@@FETCH_STATUS != 0 BEGIN
					BREAK
					END
									
					INSERT	#FlatFileLines (LineData)
					SELECT	('11'+ @PackQty +  @UM )
					
									
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
									
									INSERT	#FlatFileLines (LineData)
									SELECT	('12'+ @SerialQualifier + @SerialNumber   )
					
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
	#ASNResultSet (FFdata  CHAR(80), LineID INT)

INSERT #ASNResultSet
        ( FFdata, LineID )

SELECT
	CONVERT(CHAR(80), LineData), LineID
FROM	
	#ASNFlatFileHeader
INSERT
	#ASNResultSet (FFdata, LineID)
SELECT
	CONVERT(CHAR(77), LineData) + CONVERT(CHAR(3), LineID),LineID
FROM	
	#FlatFileLines
	
SELECT	FFdata
FROM		#ASNResultSet
ORDER BY LineID ASC

      
SET ANSI_PADDING OFF	
END
         






GO
