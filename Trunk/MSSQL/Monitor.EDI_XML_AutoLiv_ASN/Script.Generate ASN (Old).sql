begin transaction
go

declare
	@shipper int = 99719
 --EDI.ftsp_DESADV_Autoliv 92558
 

Create	table	#DESADVHeaderFlatFileLines (
				LineId	int identity,
				LineData char(80) )

Select	CONVERT( char(80), '') AS PartialComplete,
		CONVERT( char(80),ISNULL(shipper.ship_via,'')) as bill_of_lading_scac_transfer,
		CONVERT( char(80),ISNULL(bill_of_lading.scac_pickup,'')) AS SCACPickUp,
		CONVERT( char(80),ISNULL(carrier.name,'')) AS CarrierName,
		CONVERT( char(80), ISNULL((case when shipper.freight_type = 'collect' then '1  ' else '2  ' END),'')) AS FreightType,
		convert( char(80), ISNULL(shipper.trans_mode,'')) as TransMode,
		CONVERT( char(80), ISNULL(shipper.staged_pallets,0) ) AS StagedPallets, 
		CONVERT( char(80), ISNULL(shipper.aetc_number,'') ) AS AETCNumber,
		CONVERT( char(80), ISNULL(edi_setups.id_code_type,'')) AS IDCodeType,
		CONVERT( char(80), ISNULL(edi_setups.parent_destination,'')) AS ParentDestination, 
		CONVERT( char(80), ISNULL(edi_setups.material_issuer,'')) AS MaterialIssuer,
		CONVERT( char(80), ISNULL(shipper.id,0)) AS ShipperID,
		CONVERT( char(80), ISNULL([MONITOR].[dbo].[udfGetDSTIndication](shipper.date_shipped),'ET')) as TimeZone,
		CONVERT( char(80), [MONITOR].[FT].[fn_DateTimeToString] ( getdate(),'hh') + [MONITOR].[FT].[fn_DateTimeToString] (getdate(),'nn')) as ASNTime,
		CONVERT( char(80), [MONITOR].[FT].[fn_DateTimeToString] ( shipper.date_shipped,'hh') + [MONITOR].[FT].[fn_DateTimeToString] (shipper.date_shipped,'nn')) as ShippedTime,
		CONVERT( char(80), CONVERT(VARCHAR(25), shipper.date_shipped, 112))/*+LEFT(CONVERT(VARCHAR(25), shipper.date_shipped, 108),2) +SUBSTRING(CONVERT(VARCHAR(25), shipper.date_shipped, 108),4,2))*/ AS DateShipped,
		CONVERT( char(80), CONVERT(VARCHAR(25), DATEADD(dd, ISNULL(CONVERT(INT,id_code_type),0),shipper.date_shipped), 112)+LEFT(CONVERT(VARCHAR(25), DATEADD(dd, ISNULL(CONVERT(INT,id_code_type),0),shipper.date_shipped), 108),2) +SUBSTRING(CONVERT(VARCHAR(25), DATEADD(dd, ISNULL(CONVERT(INT,id_code_type),0),shipper.date_shipped), 108),4,2)) AS ArrivalDate,
		CONVERT( char(80), CONVERT(VARCHAR(25), GETDATE(), 112))/*+LEFT(CONVERT(VARCHAR(25), GETDATE(), 108),2) +SUBSTRING(CONVERT(VARCHAR(25), GETDATE(), 108),4,2))*/ AS ASNDate,
		CONVERT( char(80), ISNULL(edi_setups.pool_code,'')) AS Poolcode,  
		CONVERT( char(80), CONVERT(int, ISNULL(shipper.gross_weight,0) * .45359237)) AS GrossWeightKG, 
		CONVERT( char(80), CONVERT(int, ISNULL(shipper.net_weight,0) * .45359237)) AS NetWeightKG, 
		CONVERT( char(80), CONVERT(int, ISNULL(shipper.gross_weight,0))) AS GrossWeightLBS, 
		CONVERT( char(80), CONVERT(int, ISNULL(shipper.net_weight,0))) AS NetWeightLBS, 
		CONVERT( char(80), CONVERT(int, ISNULL(shipper.staged_objs,0))) AS StagedObjs, 
		CONVERT( char(80), ISNULL(shipper.ship_via,'') ) AS SCAC,
		UPPER(CONVERT( char(80), ISNULL(NULLIF(shipper.truck_number,''), 'TruckNo'))) AS TruckNumber, 
		CONVERT( char(80), ISNULL(shipper.pro_number, '')) AS ProNumber, 
		CONVERT( char(80), ISNULL(shipper.seal_number,'')) AS SealNumber, 
		CONVERT( char(80), COALESCE(NULLIF(edi_setups.parent_destination,''), shipper.destination,'')) AS Destination, 
		CONVERT( char(80), ISNULL(shipper.plant,'')) AS Plant,
		CONVERT( char(80), ISNULL(shipper.shipping_dock,'')) AS ShippingDock,
		CONVERT( char(80), COALESCE(shipper.bill_of_lading_number,shipper.id, 0)) AS BOL, 
		CONVERT( char(80), shipper.date_shipped)AS TimeShipped, 
		CONVERT( char(80), ISNULL(bill_of_lading.equipment_initial,'')) AS EquipInitial, 
		CONVERT( char(80), ISNULL(edi_setups.equipment_description,'')) AS EquipDesription, 
		CONVERT( char(80), COALESCE(edi_setups.trading_partner_code,'Autoliv')) AS TradingPArtnerCode, 
		CONVERT( char(80), ISNULL(edi_setups.supplier_code,'')) AS SupplierCode, 
		CONVERT( char(80), datepart(dy,getdate())) as DayofYr,
		CONVERT( char(80),(isNULL((Select	count(distinct Parent_serial) 
			from	audit_trail
			where	audit_trail.shipper = convert(char(10),@shipper) and
				audit_trail.type = 'S' and 
				isNULL(parent_serial,0) >0 ),0))) as pallets,
		CONVERT( char(80),(isNULL((Select	count(part) 
			from	audit_trail,
				package_materials
			where	audit_trail.shipper = convert(char(10),@shipper) and
				audit_trail.type = 'S' and
				part <> 'PALLET' and 
				parent_serial is NULL and
				audit_trail.package_type = package_materials.code and
				package_materials.type = 'B' ),0))) as loose_ctns,
		CONVERT( char(80),(isNULL((Select	count(part) 
			from	audit_trail,
				package_materials
			where	audit_trail.shipper =  convert(char(10),@shipper) and
				audit_trail.type = 'S' and 
				parent_serial is NULL and
				audit_trail.package_type = package_materials.code and
				package_materials.type = 'O' ),0))) AS loose_bins,
		CONVERT( CHAR(80), ISNULL(edi_setups.parent_destination,'')) AS edishipto,
		CONVERT( CHAR(80), 'DESADV') AS DocumentType,
		CONVERT( CHAR(80), '') AS ASNOverlayGroup,
		CONVERT( CHAR(80), 'LBR') AS LBR,
		CONVERT( CHAR(80), 'C62') AS C62,
		CONVERT( CHAR(80), 'MB') AS QualMB,
		CONVERT( CHAR(80), '16') AS Qual16,
		CONVERT( CHAR(80), '92') AS Qual92,
		CONVERT( CHAR(80), '12') AS TransQual,
		CONVERT( CHAR(80), '182') AS RESPONSIBLEAGENCY,
		CONVERT( CHAR(80), 'TE') AS EQUIPMENTTYPE,
		CONVERT( CHAR(80), '9') AS MESSAGEFUNCTION,
		CONVERT( CHAR(80), 'G') AS G,
		CONVERT( CHAR(80), 'N') AS N,
		CONVERT( CHAR(80), 'SQ') AS SQ,
		CONVERT( CHAR(80), 'MB') AS MB,
		CONVERT( CHAR(80), '182') AS Code182,
		CONVERT( CHAR(80), '11') AS ShipDateQualifier,
		CONVERT( CHAR(80), '137') AS ASNDateQualifier,
		CONVERT( CHAR(80), '132') AS ArrivalDateQualifier,
		CONVERT( CHAR(80), 'MI') AS MI,
		CONVERT( CHAR(80), 'ST') AS ST,
		CONVERT( CHAR(80), 'SU') AS SU,
		CONVERT( CHAR(80), 'LB') AS LB,
		CONVERT( CHAR(80), 'B') AS B,
		CONVERT( CHAR(80), 'AutoLiv ABK') AS SendingFacCode,
		CONVERT( CHAR(80), 'Empire Electronics') AS SupplierName,
		CONVERT( CHAR(80), destination.name) AS DestinationName,
		CONVERT( CHAR(80), 'PD') AS PD
		
		
		
		
		
				
	INTO	#DESADVHeaderRaw
	FROM	shipper
	JOIN	edi_setups ON EDI.shipper.destination = EDI.edi_setups.destination
	JOIN	destination ON edi_setups.destination = destination.destination 
	LEFT OUTER JOIN bill_of_lading  ON shipper.bill_of_lading_number = bill_of_lading.bol_number 
	LEFT OUTER JOIN carrier ON shipper.bol_carrier = carrier.scac  
		 
	WHERE	( ( shipper.id = @shipper ) )

--SELECT	*	FROM	#DESADVHeaderRaw
								
	INSERT	#DESADVHeaderFlatFileLines (LineData)
	SELECT	('//STX12//856'+ LEFT(TradingPArtnerCode,12)+LEFT(ShipperID,30)+ LEFT(PartialComplete,1)) FROM #DESADVHeaderRaw
	INSERT	#DESADVHeaderFlatFileLines (LineData)
	SELECT	('01'+ LEFT(ShipperID,20)+ LEFT(ASNDate,8)+ LEFT(ASNTime,8)+ LEFT(dateshipped,8)+LEFT(shippedtime,8)+LEFT(timeZone,2)+ LEFT(PD,2)+ LEFT(GrossWeightLBS,22) ) FROM #DESADVHeaderRaw
	INSERT	#DESADVHeaderFlatFileLines (LineData)
	SELECT	('02'+ +LEFT(LB,2)+ LEFT(PD,2)+LEFT(NetWeightLBS,22)+LEFT(LB,2)+ LEFT(B,2)+LEFT(SCAC,4)+LEFT(TransMode,2)+LEFT(TruckNumber,10)+LEFT(ShipperID,30) ) FROM #DESADVHeaderRaw
	INSERT	#DESADVHeaderFlatFileLines (LineData)
	SELECT	('03'+ LEFT(ProNumber,30)+ LEFT(MaterialIssuer,8)) FROM #DESADVHeaderRaw
	INSERT	#DESADVHeaderFlatFileLines (LineData)
	SELECT	('04'+ LEFT(SendingFacCode,60)+ LEFT(SupplierCode,8)) FROM #DESADVHeaderRaw
	INSERT	#DESADVHeaderFlatFileLines (LineData)
	SELECT	('05'+ LEFT(SupplierName,35)+ LEFT(edishipto,8)) FROM #DESADVHeaderRaw
	INSERT	#DESADVHeaderFlatFileLines (LineData)
	SELECT	('06'+ LEFT(DestinationName,60)) FROM #DESADVHeaderRaw
	


--Select CONVERT(char(78),LineData)+CONVERT(char(2), LINEID) From 	#DESADVHeaderFlatFileLines	order by LineID


SELECT		COALESCE(max(part_original),'') AS PartOriginal,
				COALESCE(Customer_part,'') AS CustomerPart,
				CONVERT(INT, SUM(rans.Qty)) AS QtyShipped,
				COALESCE(max(sd.alternative_unit),'') AS UM,
				COALESCE(sd.customer_po,'') AS CustomerPO,
				COALESCE (rans.RanNumber,'') AS RANNumber,
				CONVERT(VARCHAR(10), sd.shipper) AS PackingSlip,
				COALESCE( PackType, 'BOX341' ) AS PackagingCode,
				CONVERT(VARCHAR(10),CONVERT(INT, Sum(sd.boxes_staged))) AS ObjectsShipped
INTO		#ShipperDetail
			
			
FROM		shipper_detail sd
LEFT JOIN		AutoLivRanNumbersShipped rans ON Rans.shipper =  sd.shipper AND rans.Orderno= sd.order_no
OUTER APPLY
				( Select MAX(package_type) PackType
					From 
						audit_trail at
					Where
						at.shipper =  CONVERT(varchar(25), @Shipper ) and
						at.type = 'S' and
						at.part = sd.part_original and
						nullif(at.package_type,'') is not Null ) ATpackageType
WHERE		sd.shipper = @shipper
GROUP BY
	COALESCE(Customer_part,''),
	COALESCE(sd.customer_po,''),
	COALESCE (rans.RanNumber,'') ,
	CONVERT(VARCHAR(10), sd.shipper),
	COALESCE( PackType, 'BOX341' )
	
	
	
	
	

--SELECT	* FROM	#ShipperDetail

DECLARE
	@RAN VARCHAR(35) ; SET @RAN = ''
	

	
DECLARE
	RANs CURSOR LOCAL FOR
SELECT
	RANNumber
FROM	
	#ShipperDetail
	

OPEN
	RANs

WHILE
	1 = 1 BEGIN
	
	FETCH
		RANs
	INTO
		@RAN
			
	IF	@@FETCH_STATUS != 0 BEGIN
		BREAK
	END
	
	
	
		INSERT	#DESADVHeaderFlatFileLines (LineData)
		SELECT	'07' + (CONVERT(CHAR(25), MAX(CustomerPart)) + CONVERT(CHAR(12), SUM(QtyShipped)) + CONVERT(CHAR(2), MAX(UM))+ CONVERT(CHAR(22), MAX(CustomerPO) )  )  FROM #ShipperDetail 	WHERE RANNumber = @RAN GROUP BY RANNumber
		
		INSERT	#DESADVHeaderFlatFileLines (LineData)
		SELECT	'08' +( CONVERT(CHAR(30), RANNumber ) + CONVERT(CHAR(30), MAX(PackingSlip)) + CONVERT(CHAR(5), MAX(PackagingCode)) + CONVERT(CHAR(8), COUNT(ObjectsShipped)) )  FROM #ShipperDetail	WHERE RANNumber = @RAN GROUP BY RANNumber
		
		

END	
	
	
CLOSE
	RANs
 
DEALLOCATE
	RANs
	
SELECT	CASE WHEN LEFT(linedata,2) NOT IN ('07','08') THEN CONVERT(CHAR(80),LineData) ELSE CONVERT(CHAR(75),LineData)+ CONVERT(CHAR(5),LineID)END
	FROM	#DESADVHeaderFlatFileLines
	ORDER BY LineID
go

rollback
go

