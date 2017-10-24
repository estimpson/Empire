SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[usp_ShipNotice_Delphi]  (@shipper INT)
AS
BEGIN

--dbo.usp_ShipNotice_Delphi 65169
SET ANSI_PADDING ON
--ASN Header

DECLARE
	@TradingPartner	CHAR(12),
	@ShipperID CHAR(35),
	@MessageFunction CHAR(3),
	@ShipperIDHeader CHAR(30),
	@PartialComplete CHAR(1) ,
	@ASNDate CHAR(8),
	@ASNTime CHAR(4),
	@ASNDateTime CHAR(35),
	@ShippedDate CHAR(8),
	@ShippedTime CHAR(4),
	@ShippedDateTime CHAR(35),
	@ArrivalDate CHAR(35),
	@ArrivalTime CHAR(4),
	@ArrivalDateTime CHAR(35),
	@GrossWeightLbs CHAR(18),
	@NetWeightLbs CHAR(18),
	@PackagingCode CHAR(5),
	@PackCount CHAR(8),
	@TDT03_1_TransMode CHAR(3) = '12',
	@TDT03TransMode CHAR(3),
	@TDT05_1_SCAC CHAR(17),
	@TDT05_3_AgencyCode CHAR(3) = '182',
	@TDT05_4_CarrierName CHAR(35),
	@EQD_01_TrailerNumberQual CHAR(3) = 'TL',	
	@EQD_02_01_TrailerNumber CHAR(17),
	@REFBMQual CHAR(3),
	@REFPKQual CHAR(3),
	@REFCNQual CHAR(3),
	@REFBMValue CHAR(35),
	@REFPKValue CHAR(35),
	@REFCNValue CHAR(35),
	@FOB CHAR(2),
	@SupplierName CHAR(75),
	@SupplierCode CHAR(35),
	@ShipToName CHAR(35),
	@ShipToID CHAR(35),
	@NADShipToID2 CHAR(25),
	@RoutingCode CHAR(35),
	@BuyerID CHAR(35),
	@BuyerName CHAR(35),
	@SellerID CHAR(35),
	@SellerName CHAR(75),
	@SoldToID CHAR(35),
	@ConsolidationCenterID CHAR(35),
	@SoldToName CHAR(35),
	@ConsolidationCenterName CHAR(35),
	@LOC02_DockCode CHAR(25),
	@MEAGrossWghtQualfier CHAR(3) = 'G',
	@MEANetWghtQualfier CHAR(3) = 'N',
	@MEALadingQtyQualfier CHAR(3) = 'SQ',
	@MEAGrossWghtUMKG CHAR(3) = 'KG',
	@MEANetWghtUMKG CHAR(3) = 'KG',
	@MEAGrossWghtUMLBR CHAR(3) = 'LBR',
	@MEANetWghtUMLBR CHAR(3) = 'LBR',
	@MEALadingQtyUM CHAR(3) = 'C62',
	@MEAGrossWghtKG CHAR(18),
	@MEANetWghtLB  CHAR(18), 
	@MEAGrossWghtLB CHAR(18),
	@MEANetWghtKG  CHAR(18),
	@MEALadingQty CHAR(18),
	@REFProNumber CHAR(35),
	@REFCOFQual CHAR(3) = 'COF',
	@REFCOFValue CHAR(35), 
	@DESADV CHAR(10) = 'DESADV',
	@NADBuyerAdd1 CHAR(35) = '' ,
	@NADSupplierAdd1 CHAR(35) = '',
	@NADShipToAdd1 CHAR(35) = '',
	@NADShipToID CHAR(35),
	@NADMaterialIssuerID CHAR(35),
	@NADQual16 CHAR(3) = '16',
	@NADQual92 CHAR(3) = '92',
	@SealNumber CHAR(10)
	
	SELECT
		@TradingPartner	= COALESCE(es.trading_partner_code, 'HBPO'),
		@ShipperID =  s.id,
		@MessageFunction ='9',
		@ShipperIDHeader =  s.id,
		@PartialComplete = '' ,
		@ASNDate = CONVERT(CHAR, GETDATE(), 112) ,
		@ASNTime = LEFT(REPLACE(CONVERT(CHAR, GETDATE(), 108), ':', ''),4),
		@ASNDateTime = RTRIM(@ASNDate)+RTRIM(@ASNTime),
		@ShippedDate = CONVERT(CHAR, s.date_shipped, 112)  ,
		@ShippedTime =  LEFT(REPLACE(CONVERT(CHAR, date_shipped, 108), ':', ''),4),
		@ShippedDateTime = RTRIM(@ShippedDate)+RTRIM(@ShippedTime),
		@ArrivalDate = CONVERT(CHAR, DATEADD(dd,1, s.date_shipped), 112)  ,
		@ArrivalTime =  left(replace(convert(char, date_shipped, 108), ':', ''),4),
		@ArrivalDateTime = rtrim(@ArrivalDate)+rtrim(@ArrivalTime),
		@MEAGrossWghtLB = convert(char,convert(int,s.gross_weight)),
		@MEANetWghtLB = convert(char,convert(int,s.gross_weight)),
		@MEAGrossWghtKG = convert(char,convert(int,s.gross_weight/2.2)),
		@MEANetWghtKG = convert(char,convert(int,s.net_weight/2.2)),
		@PackagingCode = 'CNT71' ,
		@MEALadingQty = s.staged_objs,
		@TDT03TransMode = coalesce(s.trans_mode,''),
		@TDT05_1_SCAC = s.ship_via,
		@TDT05_4_CarrierName = s.ship_via,
		@EQD_02_01_TrailerNumber = coalesce(nullif(s.truck_number,''), s.id),
		@REFBMQual = 'MB' ,
		@REFPKQual = 'PK',
		@REFCNQual = 'CN',
		@REFBMValue = coalesce(bill_of_lading_number, id),
		@REFPKValue = id,
		@REFCNValue = coalesce(nullif(pro_number,''),nullif(s.truck_number,''),'1'),
		@REFCOFValue = coalesce(s.shipping_dock, ''),
		@FOB = case when freight_type =  'Collect' then 'CC' when freight_type in  ('Consignee Billing', 'Third Party Billing') then 'TP' when freight_type  in ('Prepaid-Billed', 'PREPAY AND ADD') then 'PA' when freight_type = 'Prepaid' then 'PP' else '' end ,
		@RoutingCode = 'NA',
		@SealNumber = coalesce(s.seal_number,''),
		@ConsolidationCenterID  = case when trans_mode like '%A%' then '' else coalesce(pool_code, '') end,
		@ConsolidationCenterName = coalesce((select max(name) from destination where destination = pool_code),''),
		@SoldToID = d.destination,
		@SoldToName =  d.name,
		@ShipToID = es.destination,
		@NADShipToID = coalesce(es.parent_destination, es.destination),
		@NADShipToID2 = coalesce(es.parent_destination, es.destination),
		@LOC02_DockCode = coalesce(s.shipping_dock,''),
		@ShipToName =  d.name,
		@SellerID =  coalesce(es.supplier_code,'SUPP'),
		@SellerName = '',
		@SupplierCode =  coalesce(es.supplier_code,'SUPP'),	
		@SupplierName = '',
		@BuyerID = c.customer,
		@NADMaterialIssuerID = coalesce(es.material_issuer,''),
		@BuyerName = 'DELPHI'
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
	

Create	table	#ASNFlatFile (
				LineId	int identity,
				LineData char(79) )

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'//STX12//X12'
				+ @TradingPartner 
				+ @ShipperIDHeader
				+ @PartialComplete
				+ @DESADV 
				+ left(@DESADV,6)
			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'01'
				+	@ShipperID
				+	@MessageFunction
				+	@ASNDateTime  )

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'02'
				+	@ShippedDateTime 
				+	@ArrivalDateTime  )

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'03'
				+ @MEAGrossWghtQualfier
				+ @MEAGrossWghtUMLBR
				+ @MEAGrossWghtLB
				
			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'03'
				+ @MEANetWghtQualfier
				+ @MEANetWghtUMLBR
				+ @MEANetWghtLB
				
			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'03'
				+ @MEALadingQtyQualfier
				+ @MEALadingQtyUM
				+ @MEALadingQty				
			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'04'
				+ @REFCNQual
				+ @REFCNValue
				
			)
			
INSERT	#ASNFlatFile (LineData)
	SELECT	(	'04'
				+ @REFBMQual
				+ @REFBMValue
				
			)
			
INSERT	#ASNFlatFile (LineData)
	SELECT	(	'04'
				+ @REFCOFQual
				+ @REFCOFValue
				
			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'05'
				+ @NADMaterialIssuerID
				+ @NADQual16
			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'06'
				+ @NADShipToID
				+ @NADQual92
				+ @NADShipToID2
			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'07'
				+ @SupplierCode
				+ @NADQual16
				+ @SupplierCode
				+ @NADQual16	
			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'11'
				+ @TDT03_1_TransMode
				+ @TDT03TransMode
				+ @TDT05_1_SCAC
				+ @TDT05_3_AgencyCode
			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'12'
				+ @EQD_01_TrailerNumberQual
				+ @EQD_02_01_TrailerNumber
			)
			
INSERT	#ASNFlatFile (LineData)
	SELECT	(	'13'
				+ @SealNumber	
			)


 --ASN Detail

declare	@ShipperDetail table (
	ID int identity(1,1),
	Part varchar(25),
	CustomerPart varchar(35),
	CustomerPO varchar(35),
	CustomerECL varchar(35),
	DockCode varchar(35),
	StorageLocation varchar(50),
	Qty int,
	AccumShipped int primary key (ID))
	
insert	@ShipperDetail 
(	Part,
	CustomerPart,
	CustomerPO,
	CustomerECL,
	DockCode,
	StorageLocation,
	Qty,
	AccumShipped
	)
	
select
	part_original,
	sd.customer_part,
	sd.customer_po,
	coalesce(oh.engineering_level,oh.customer_part,''),
	coalesce(s.shipping_dock,''),
	coalesce(oh.line11,'0001'),
	qty_packed,
	sd.accum_shipped
from
	shipper_detail sd
join
	order_header oh on oh.order_no = sd.order_no
join
	shipper s on s.id = @shipper
Where
	sd.shipper = @shipper
	
	
declare	@AuditTrailLooseSerial table (
Part varchar(25),
PackageType varchar(35),
PartPackCount int,
SerialQuantity int,
ParentSerial int,
Serial int, 
id int identity primary key (id))
	
insert	@AuditTrailLooseSerial 
(	Part,
	PackageType,
	PartPackCount,
	SerialQuantity,
	ParentSerial,
	Serial 
)
	
select
	part,
	coalesce(pm.name,'CTN90') ,
	1,
	quantity,
	0,
	serial
from
	dbo.audit_trail at
left join
	dbo.package_materials pm on pm.code = at.package_type
Where
	at.shipper = convert(varchar(15),@shipper) and
	at.type = 'S' and
	--nullif(at.parent_serial,0) is null and
	part != 'Pallet'
order by serial	

declare	@AuditTrailPartPackGroup table (
Part varchar(25),
PackageType varchar(35),
PartPackQty int, 
PartPackCount int, primary key (Part, PackageType, PartPackQty))


insert	@AuditTrailPartPackGroup
(	Part,
	PackageType,
	PartPackQty,
	PartPackCount
)

Select 
	part,
	PackageType,
	SerialQuantity,
	sum(PartPackCount)
From
	@AuditTrailLooseSerial
group by
	part,
	PackageType,
	SerialQuantity



declare	@AuditTrailPartPackGroupRangeID table (
Part varchar(25),
PackageType varchar(35),
PartPackQty int,
Serial int,
RangeID int, primary key (Serial))


insert	@AuditTrailPartPackGroupRangeID
(	Part,
	PackageType,
	PartPackQty,
	Serial,
	RangeID
)

Select 
	atl.part,
	atl.PackageType,
	SerialQuantity,
	Serial,
	Serial-id
	
From
	@AuditTrailLooseSerial atL
join
	@AuditTrailPartPackGroup atG on
	atG.part = atl.part and
	atg.packageType = atl.PackageType and
	atg.partPackQty = atl.SerialQuantity



declare	@AuditTrailPartPackGroupSerialRange table (
Part varchar(25),
PackageType varchar(35),
PartPackQty int,
SerialRange varchar(50), primary key (SerialRange))


insert	@AuditTrailPartPackGroupSerialRange
(	Part,
	PackageType,
	PartPackQty,
	SerialRange
)

Select 
	part,
	PackageType,
	PartPackQty,
	Case when min(serial) = max(serial) 
		THEN CONVERT(varchar(15), MAX(serial)) 
		ELSE CONVERT(VARCHAR(15), MIN(serial)) + ':' + CONVERT(VARCHAR(15), MAX(serial)) END
FROM
	@AuditTrailPartPackGroupRangeID atR

GROUP BY
	part,
	PackageType,
	PartPackQty,
	RangeID


/*	Select * From @ShipperDetail
	Select * From @AuditTrailLooseSerial
	Select * From @AuditTrailPartPackGroupRangeID
	Select * From @AuditTrailPartPackGroup
	Select * From @AuditTrailPartPackGroupSerialRange
*/


--Delcare Variables for ASN Details		
DECLARE	
	@LineItemID CHAR(6),
	@CustomerPart CHAR(35) ,
	@Part VARCHAR(50),
	@SupplierPart CHAR(35),
	@SupplierPartQual CHAR(3),
	@CountryOfOrigin CHAR(3),
	@PartQty CHAR(14),
	@PartAccum CHAR(14),
	@PartUM CHAR(3),
	@CustomerPO CHAR(35),
	@CustomerECL CHAR(35),
	@CustomerECLQual CHAR(3),
	@PackageType CHAR(17),
	@DunnagePackType CHAR(17),
	@DunnageCount CHAR(10),
	@DunnageIdentifier CHAR(3),
	@PartPackQty CHAR(14),
	@PartPackCount CHAR(10),
	@PCIQualifier CHAR(3),
	@PCIStorage CHAR(35) ,
	@Serial CHAR(20),
	@DockCode CHAR(25),
	@PCI_S CHAR(3),
	@PCI_M CHAR(3),
	@SupplierSerial CHAR(35),
	@CPS03 CHAR(3),
	@UM CHAR(3),
	@Kanban CHAR(35) = '0000000',
	@KanbanQual CHAR(3)= 'AL',
	@ModelYear CHAR(35) = '0'
	 
--Populate Static Variables
SELECT	@CountryOfOrigin = 'US'
SELECT	@PartUM = 'EA'	
SELECT	@PCI_S = 'S'
SELECT	@PCI_M = 'M'
SELECT	@DunnageIdentifier = '37'
SELECT	@DunnagePackType = ''
SELECT	@UM = 'C62'
SELECT  @PCIQualifier = '17'
SELECT 	@CPS03 = 4
SELECT	@SupplierPartQual = 'SA'
SELECT	@CustomerECLQual = 'DR'
 			
DECLARE
	PartPOLine CURSOR LOCAL FOR
SELECT
	ID = ID,
	InternalPart = Part,
	CustomerPart = customerpart,
	CustomerPO = customerpo,
	CustomerECL = customerECL,
	DockCode = DockCode,
	StorageLocation = StorageLocation,
	QtyShipped = CONVERT(INT, Qty),
	AccumShipped = CONVERT(INT, AccumShipped)
FROM
	@ShipperDetail SD

OPEN
	PartPOLine

WHILE
	1 = 1 BEGIN
	
	FETCH
		PartPOLine
	INTO
		@LineItemID,
		@Part,
		@CustomerPart,
		@CustomerPO,
		@CustomerECL,
		@DockCode,
		@PCIStorage,
		@PartQty,
		@PartAccum
			
	IF	@@FETCH_STATUS != 0 BEGIN
		BREAK
	END

		

		INSERT	#ASNFlatFile (LineData)
		SELECT '14'
				+ @CPS03


		DECLARE PartPack CURSOR LOCAL FOR
			SELECT
				*
			FROM
				@AuditTrailPartPackGroup
			WHERE
				part = @Part
												
			OPEN
				PartPack

			WHILE
				1 = 1 BEGIN
							
				FETCH
					PartPack
				INTO
					@Part,
					@PackageType,
					@PartPackQty,
					@PartPackCount
								
																								
				IF	@@FETCH_STATUS != 0 BEGIN
					BREAK
				END
					SELECT @DunnageCount = FLOOR((CONVERT(INT,@PartPackQty) -.1)/6)+1
																					
					INSERT	#ASNFlatFile (LineData)
					SELECT  '15' 
							--+ @DunnageCount 
							--+ @DunnageIdentifier 
							--+ @DunnagePackType										
							+ @PartPackCount
							+ @PackageType
					
					INSERT	#ASNFlatFile (LineData)		
					SELECT  '16' 
							--+ @DunnageCount 
							--+ @DunnageIdentifier 
							--+ @DunnagePackType										
							+ @PartPackQty
							+ @UM
							
							
								
					INSERT	#ASNFlatFile (LineData)
					SELECT  '17' 
							+ @PCIStorage
							
					INSERT	#ASNFlatFile (LineData)
					SELECT  '18' 
							+ @Kanban
							+ @KanbanQual
							
										
																	
							/*declare PartPackSerialRange cursor local for

							Select	
								SerialRange
								From
									@AuditTrailPartPackGroupSerialRange
								Where
									part = @part and
									PackageType = @PackageType and
									PartPackQty = @PartPackQty													

							open
								PartPackSerialRange

							while
								1 = 1 begin
																				
								fetch
									PartPackSerialRange
								into
									@SupplierSerial
																						
								if	@@FETCH_STATUS != 0 begin
									break
								end
																								
									Insert	#ASNFlatFile (LineData)
									Select  '36' +  @SupplierSerial
																
								End
																				
							close
								PartPackSerialRange
							deallocate
								PartPackSerialRange
							*/												
														
																					
					END
							
					CLOSE
						PartPack
					DEALLOCATE
						PartPack
	

		SELECT @SupplierPart = @Part
		INSERT	#ASNFlatFile (LineData)
		SELECT  '20' 
				+ @LineItemID 
				+ @CustomerPart
				+ @ModelYear
		
		INSERT	#ASNFlatFile (LineData)
		SELECT  '21' 
				+ @CustomerECL
		
		INSERT	#ASNFlatFile (LineData)
		SELECT  '23' 
				+ @PartAccum
				+ @UM
				+ @PartQty 
				+ @UM 
		
		INSERT	#ASNFlatFile (LineData)
		SELECT  '26' 
				+ @CustomerPO 
				
	END	
	
	
CLOSE
	PartPOLine	
 
DEALLOCATE
	PartPOLine


SELECT 
	LineData +CONVERT(CHAR(1), (lineID % 2 ))
FROM 
	#ASNFlatFile
ORDER BY 
	LineID

	
	      
SET ANSI_PADDING OFF

END

GO
