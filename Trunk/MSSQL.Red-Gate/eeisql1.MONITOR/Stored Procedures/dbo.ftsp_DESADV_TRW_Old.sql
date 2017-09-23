SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[ftsp_DESADV_TRW_Old] (@shipper integer )
AS
BEGIN
SET ANSI_PADDING ON

 --[dbo].[ftsp_DESADV_TRW] 51564
 

Create	table	#ASNHeaderFlatFileLines (
				LineId	int identity,
				LineData char(80) )

select
		CONVERT( char(80), '') AS PartialComplete,
		CONVERT( char(80), '') AS ASNOverlayGroup,
		CONVERT( char(80), COALESCE(edi_setups.trading_partner_code,'TRW')) AS TradingPartnerCode, 
		CONVERT( char(80), 'DESADV') AS DocumentType,
		CONVERT( char(80), ISNULL(shipper.id,0)) AS ShipperID,
		CONVERT( char(80), '9') AS MESSAGEFUNCTION,
		CONVERT( char(80), CONVERT(VARCHAR(25), GETDATE(), 112))/*+LEFT(CONVERT(VARCHAR(25), GETDATE(), 108),2) +SUBSTRING(CONVERT(VARCHAR(25), GETDATE(), 108),4,2))*/ AS ASNDate,
		CONVERT( char(80), [MONITOR].[FT].[fn_DateTimeToString] ( getdate(),'hh') + [MONITOR].[FT].[fn_DateTimeToString] (getdate(),'nn')) as ASNTime,
		CONVERT( char(80), CONVERT(VARCHAR(25), shipper.date_shipped, 112))/*+LEFT(CONVERT(VARCHAR(25), shipper.date_shipped, 108),2) +SUBSTRING(CONVERT(VARCHAR(25), shipper.date_shipped, 108),4,2))*/ AS ShippedDate,
		CONVERT( char(80), [MONITOR].[FT].[fn_DateTimeToString] ( shipper.date_shipped,'hh') + [MONITOR].[FT].[fn_DateTimeToString] (shipper.date_shipped,'nn')) as ShippedTime,
		CONVERT( char(80), '10') AS DTMQualifier_10,
		CONVERT( char(80), '97') AS DTMQualifier_97,
		CONVERT( char(80), 'EGW') AS MEAQualifier_EGW,
		CONVERT( char(80), 'WT') AS MEAQualifier_WT,
		CONVERT( char(80), 'AAW') AS MEAQualifier_AAW,
		CONVERT( char(80), 'KG') AS MEAUM_KG,
		CONVERT( char(80), 'EA') AS MEAUM_EA,
		CONVERT( char(80), CONVERT(int, ISNULL(shipper.gross_weight,0) * .45359237)) AS GrossWeightKG, 
		CONVERT( char(80), CONVERT(int, ISNULL(shipper.net_weight,0) * .45359237)) AS NetWeightKG,
			CONVERT( char(80),(isNULL((Select	count(distinct Parent_serial) 
			from	audit_trail
			where	audit_trail.shipper = convert(char(10),@shipper) and
				audit_trail.type = 'S' and 
				isNULL(parent_serial,0) >0 ),0))+
		(isNULL((Select	count(serial) 
			from	audit_trail,
				package_materials
			where	audit_trail.shipper = convert(char(10),@shipper) and
				audit_trail.type = 'S' and
				part <> 'PALLET' and 
				parent_serial is NULL and
				audit_trail.package_type = package_materials.code and
				package_materials.type = 'B' ),0)) +
		(isNULL((Select	count(serial) 
			from	audit_trail,
				package_materials
			where	audit_trail.shipper =  convert(char(10),@shipper) and
				audit_trail.type = 'S' and 
				parent_serial is NULL and
				audit_trail.package_type = package_materials.code and
				package_materials.type = 'O' ),0))) as lifts,
			CONVERT( char(80), 'PK') AS REF01_PK,
			CONVERT( char(80), 'BM') AS REF01_BM, 
			CONVERT( char(80), COALESCE(shipper.bill_of_lading_number,shipper.id, 0)) AS BOL, 
			CONVERT( char(80), COALESCE(edi_setups.parent_destination,edi_setups.destination, '')) as edishipto,
			CONVERT( char(80), ISNULL(edi_setups.supplier_code,'')) AS SupplierCode, 
			UPPER(CONVERT( char(80), ISNULL(NULLIF(shipper.truck_number,''), 'TruckNo'))) AS TruckNumber, 
			CONVERT (char(80), case shipper.trans_mode when 'A' then '40' else '30' end ) as TransModeCoded,
			CONVERT( char(80), ISNULL(shipper.ship_via,'')) as SCAC
			
			
		--CONVERT( char(80),ISNULL(shipper.ship_via,'')) as bill_of_lading_scac_transfer,
		--CONVERT( char(80),ISNULL(bill_of_lading.scac_pickup,'')) AS SCACPickUp,
		--CONVERT( char(80), CONVERT(VARCHAR(25), DATEADD(dd, ISNULL(CONVERT(INT,id_code_type),0),shipper.date_shipped), 112)+LEFT(CONVERT(VARCHAR(25), DATEADD(dd, ISNULL(CONVERT(INT,id_code_type),0),shipper.date_shipped), 108),2) +SUBSTRING(CONVERT(VARCHAR(25), DATEADD(dd, ISNULL(CONVERT(INT,id_code_type),0),shipper.date_shipped), 108),4,2)) AS ArrivalDate,
		--CONVERT( char(80),ISNULL(carrier.name,'')) AS CarrierName,
		--CONVERT( char(80), ISNULL((case when shipper.freight_type = 'collect' then '1  ' else '2  ' END),'')) AS FreightType,
		--convert( char(80), ISNULL(shipper.trans_mode,'')) as TransMode,
		--CONVERT( char(80), ISNULL(shipper.staged_pallets,0) ) AS StagedPallets, 
		--CONVERT( char(80), ISNULL(shipper.aetc_number,'') ) AS AETCNumber,
		--CONVERT( char(80), ISNULL(edi_setups.id_code_type,'')) AS IDCodeType,
		--CONVERT( char(80), ISNULL(edi_setups.parent_destination,'')) AS ParentDestination, 
		--CONVERT( char(80), ISNULL(edi_setups.material_issuer,'')) AS MaterialIssuer,
		--CONVERT( char(80), ISNULL([MONITOR].[dbo].[udfGetDSTIndication](shipper.date_shipped),'ET')) as TimeZone,
		--CONVERT( char(80), ISNULL(edi_setups.pool_code,'')) AS Poolcode,  
		--CONVERT( char(80), CONVERT(int, ISNULL(shipper.gross_weight,0))) AS GrossWeightLBS, 
		--CONVERT( char(80), CONVERT(int, ISNULL(shipper.net_weight,0))) AS NetWeightLBS, 
		--CONVERT( char(80), CONVERT(int, ISNULL(shipper.staged_objs,0))) AS StagedObjs, 
		--CONVERT( char(80), ISNULL(shipper.ship_via,'') ) AS SCAC,
		--CONVERT( char(80), ISNULL(shipper.pro_number, '')) AS ProNumber, 
		--CONVERT( char(80), ISNULL(shipper.seal_number,'')) AS SealNumber, 
		--CONVERT( char(80), COALESCE(NULLIF(edi_setups.parent_destination,''), shipper.destination,'')) AS Destination, 
		--CONVERT( char(80), ISNULL(shipper.plant,'')) AS Plant,
		--CONVERT( char(80), ISNULL(shipper.shipping_dock,'')) AS ShippingDock,
		--CONVERT( char(80), shipper.date_shipped)AS TimeShipped, 
		--CONVERT( char(80), ISNULL(bill_of_lading.equipment_initial,'')) AS EquipInitial, 
		--CONVERT( char(80), ISNULL(edi_setups.equipment_description,'')) AS EquipDesription, 
		--CONVERT( char(80), datepart(dy,getdate())) as DayofYr,
		--CONVERT( char(80), ISNULL(edi_setups.parent_destination,'')) as edishipto,
		--CONVERT( char(80), 'DESADV') AS DocumentType,
		--CONVERT( char(80), '') AS ASNOverlayGroup,
		--CONVERT( char(80), 'LBR') AS LBR,
		--CONVERT( char(80), 'C62') AS C62,
		--CONVERT( char(80), 'MB') AS QualMB,
		--CONVERT( char(80), '16') AS Qual16,
		--CONVERT( char(80), '92') AS Qual92,
		--CONVERT( char(80), '12') AS TransQual,
		--CONVERT( char(80), '182') AS RESPONSIBLEAGENCY,
		--CONVERT( char(80), 'TE') AS EQUIPMENTTYPE,
		--CONVERT( char(80), 'G') AS G,
		--CONVERT( char(80), 'N') AS N,
		--CONVERT( char(80), 'SQ') AS SQ,
		--CONVERT( char(80), 'MB') AS MB,
		--CONVERT( char(80), '182') AS Code182,
		--CONVERT( char(80), '11') AS ShipDateQualifier,
		--CONVERT( char(80), '137') AS ASNDateQualifier,
		--CONVERT( char(80), '132') AS ArrivalDateQualifier,
		--CONVERT( char(80), 'MI') AS MI,
		--CONVERT( char(80), 'ST') AS ST,
		--CONVERT( char(80), 'SU') AS SU,
		--CONVERT( char(80), 'SF') AS SF,
		--CONVERT( char(80), 'LB') AS LB,
		--CONVERT( char(80), 'B') AS B,
		--Convert( char(80), 'EMPIRE ELECTRONICS,INC.') as SupplierName,
		--Convert( char(80), destination.name) as DestinationName,
		--CONVERT( char(80), 'PD') AS PD,
		--CONVERT( char(80), 'CTN90') AS CTN90,
		--CONVERT( char(80), '2') AS TD502_2,
		--CONVERT( char(80), 'TL') AS TD301_TL,
			
		
		
		
		
				
	Into	#ASNHeaderRaw
	from	shipper
	JOIN	edi_setups ON dbo.shipper.destination = dbo.edi_setups.destination
	JOIN	destination ON edi_setups.destination = destination.destination 
	LEFT OUTER JOIN bill_of_lading  ON shipper.bill_of_lading_number = bill_of_lading.bol_number 
	left outer join carrier on shipper.bol_carrier = carrier.scac  
		 
	where	( ( shipper.id = @shipper ) )

--SELECT	*	FROM	#ASNHeaderRaw
								
	INSERT	#ASNHeaderFlatFileLines (LineData)
	SELECT	('//STX12//X12'+ LEFT(TradingPArtnerCode,12)+LEFT(ShipperID,30)+ LEFT(PartialComplete,1) +LEFT(DocumentType,10) + LEFT(DocumentType,6)+ LEFT(ASNOverlayGroup,3)) FROM #ASNHeaderRaw
	
	INSERT	#ASNHeaderFlatFileLines (LineData)
	Select	('01'+ LEFT(ShipperID,35)+ LEFT(MESSAGEFUNCTION,3) ) FROM #ASNHeaderRaw
	
	INSERT	#ASNHeaderFlatFileLines (LineData)
	Select	('02'+ LEFT(DTMQualifier_10, 3)+ left(ShippedDate,35) ) FROM #ASNHeaderRaw
	
	INSERT	#ASNHeaderFlatFileLines (LineData)
	Select	('02'+ LEFT(DTMQualifier_97, 3)+ left(ASNDate,35) ) FROM #ASNHeaderRaw
	
	
	INSERT	#ASNHeaderFlatFileLines (LineData)
	Select	('03'+ left(MEAQualifier_EGW,3) +Left(MEAUM_KG,3) + left(GrossWeightKG,22) ) FROM #ASNHeaderRaw
	
	INSERT	#ASNHeaderFlatFileLines (LineData)
	Select	('03' + left(MEAQualifier_WT,3) +Left(MEAUM_KG,3) + left(NetWeightKG,22) ) FROM #ASNHeaderRaw
	
	INSERT	#ASNHeaderFlatFileLines (LineData)
	Select	('03' + left(MEAQualifier_AAW,3) +Left(MEAUM_EA,3) + left(lifts,22) ) FROM #ASNHeaderRaw
	
	INSERT	#ASNHeaderFlatFileLines (LineData)
	Select	('04'+ LEFT(REF01_PK,3)+ LEFT(ShipperID,10)) FROM #ASNHeaderRaw
	
	INSERT	#ASNHeaderFlatFileLines (LineData)
	Select	('04'+ LEFT(REF01_BM,3)+ LEFT(BOL,10)) FROM #ASNHeaderRaw
	
	INSERT	#ASNHeaderFlatFileLines (LineData)
	Select	('05'+ Left(edishipto,35) ) FROM #ASNHeaderRaw
	
	INSERT	#ASNHeaderFlatFileLines (LineData)
	Select	('08'+ space(6)+ Left(suppliercode,35) ) FROM #ASNHeaderRaw
	
	INSERT	#ASNHeaderFlatFileLines (LineData)
	Select	('11'+ Left(TruckNumber,78) ) FROM #ASNHeaderRaw
	
	INSERT	#ASNHeaderFlatFileLines (LineData)
	Select	('12'+ Left(TransModeCoded,3) + LEFT(scac, 17)) FROM #ASNHeaderRaw
	
--Select CONVERT(char(78),LineData)+CONVERT(char(2), LINEID) From 	#ASNHeaderFlatFileLines	order by LineID


SELECT		
			'1' as CPS,
			( select count(1) from shipper_detail sd2 where sd2.part_original<=sd.part_original and sd2.shipper = @shipper) as ShipperLine,
			COALESCE(part_original,'') AS PartOriginal,
			COALESCE(sd.Customer_part,'') AS CustomerPart,
			CONVERT(VARCHAR(10),CONVERT(INT, sd.alternative_qty)) AS QtyShipped,
			CONVERT(VARCHAR(10),CONVERT(INT, sd.accum_shipped)) AS AccumShipped,
			COALESCE(sd.alternative_unit,'PCE') AS UM,
			COALESCE(sd.customer_po,'') AS CustomerPO
			
			
			
INTO		#ShipperDetail
			
			
FROM		shipper_detail sd
join			order_header oh on sd.order_no = oh.order_no
WHERE		sd.shipper = @shipper


--SELECT	* FROM	#ShipperDetail

declare
	@Part VARCHAR(35) ; set @Part = ''
	

	
declare
	Parts cursor local for
select
	partoriginal
From	
	#ShipperDetail
	

open
	Parts

while
	1 = 1 begin
	
	fetch
		Parts
	into
		@Part
			
	if	@@FETCH_STATUS != 0 begin
		break
	end
	
		Insert	#ASNHeaderFlatFileLines (LineData)
		Select	'13' +( convert(char(2), CPS) )   from #ShipperDetail	where partoriginal = @part
	
		Insert	#ASNHeaderFlatFileLines (LineData)
		Select	'14' +( convert(char(6), ShipperLine) + convert(char(35), CustomerPart))   from #ShipperDetail	where partoriginal = @part
		
		Insert	#ASNHeaderFlatFileLines (LineData)
		Select	'15' +  (convert(char(35), CustomerPO ) )  from  #ShipperDetail	where partoriginal = @part
		
		Insert	#ASNHeaderFlatFileLines (LineData)
		Select	'17' + ( convert(char(17), QtyShipped) + convert(char(3), UM) + convert(char(17), AccumShipped) + convert(char(3), UM)  ) from  #ShipperDetail	where partoriginal = @part
		
		
		
 
		
		

end	
	
	
close
	parts
 
deallocate
	parts
	
Select	CONVERT(char(80),LineData)
	From	#ASNHeaderFlatFileLines
	order BY LineID
	
SET ANSI_PADDING OFF

END







GO
