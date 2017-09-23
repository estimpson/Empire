SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [FT].[usp_DESADV_Delphi_Header] (@shipper integer )
AS
SET ANSI_PADDING ON
BEGIN

 --FT.usp_DESADV_Delphi_HEADER 3077084
 

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
		CONVERT( char(80), ISNULL(edi_setups.material_issuer,'987654321')) AS MaterialIssuer,
		CONVERT( char(80), ISNULL(shipper.id,0)) AS ShipperID, 
		CONVERT( char(80), shipper.date_shipped,112) AS DateShipped,
		CONVERT( char(80), DATEADD(dd,2,shipper.date_shipped), 112) AS ArrivalDate,
		CONVERT( char(80), GETDATE(),112) AS ASNDate,
		CONVERT( char(80), ISNULL(edi_setups.pool_code,'')) AS Poolcode, 
		CONVERT( char(80), CONVERT(int, ISNULL(shipper.gross_weight,0) * .45359237)) AS GrossWeightKG, 
		CONVERT( char(80), CONVERT(int, ISNULL(shipper.net_weight,0) * .45359237)) AS NetWeightKG, 
		CONVERT( char(80), CONVERT(int, ISNULL(shipper.gross_weight,0))) AS GrossWeightLBS, 
		CONVERT( char(80), CONVERT(int, ISNULL(shipper.net_weight,0))) AS NetWeightLBS, 
		CONVERT( char(80), CONVERT(int, ISNULL(shipper.staged_objs,0))) AS StagedObjs, 
		CONVERT( char(80), ISNULL(shipper.ship_via,'') ) AS SCAC,
		UPPER(CONVERT( char(80), ISNULL(NULLIF(shipper.truck_number,''), 'TruckNo'))) AS TruckNumber, 
		CONVERT( char(80), coalesce(nullif(shipper.pro_number,''), shipper.aetc_number, convert(varchar(80),shipper.id), '')) AS ProNumber, 
		CONVERT( char(80), ISNULL(shipper.seal_number,'')) AS SealNumber, 
		CONVERT( char(80), COALESCE(edi_setups.parent_destination,shipper.destination,'')) AS Destination, 
		CONVERT( char(80), ISNULL(shipper.plant,'')) AS Plant,
		CONVERT( char(80), ISNULL(shipper.shipping_dock,'')) AS ShippingDock,
		CONVERT( char(80), COALESCE(shipper.bill_of_lading_number,shipper.id, 0)) AS BOL, 
		CONVERT( char(80), shipper.date_shipped)AS TimeShipped, 
		CONVERT( char(80), ISNULL(bill_of_lading.equipment_initial,'')) AS EquipInitial, 
		CONVERT( char(80), ISNULL(edi_setups.equipment_description,'')) AS EquipDesription, 
		CONVERT( char(80), COALESCE(edi_setups.trading_partner_code,'DELPHITEST')) AS TradingPArtnerCode, 
		--CONVERT( char(80), ISNULL(NULLIF(edi_setups.trading_partner_code,''),'DELPHITEST')) AS TradingPArtnerCode, 
		CONVERT( char(80), ISNULL(edi_setups.supplier_code,'')) AS SupplierCode, 
		CONVERT( char(80), datepart(dy,getdate())) as DayofYr,
		CONVERT( char(80),(isNULL((Select	count(distinct Parent_serial) 
			from	audit_trail
			where	audit_trail.shipper = convert(char(10),@shipper) and
				audit_trail.type = 'S' and 
				isNULL(parent_serial,0) >0 ),0))) as pallets,
		CONVERT( char(80),(isNULL((Select	count(serial) 
			from	audit_trail,
				package_materials
			where	audit_trail.shipper = convert(char(10),@shipper) and
				audit_trail.type = 'S' and
				part <> 'PALLET' and 
				parent_serial is NULL and
				audit_trail.package_type = package_materials.code and
				package_materials.type = 'B' ),0))) as loose_ctns,
		CONVERT( char(80),(isNULL((Select	count(serial) 
			from	audit_trail,
				package_materials
			where	audit_trail.shipper =  convert(char(10),@shipper) and
				audit_trail.type = 'S' and 
				parent_serial is NULL and
				audit_trail.package_type = package_materials.code and
				package_materials.type = 'O' ),0))) as loose_bins,
		CONVERT( char(80), ISNULL(edi_setups.parent_destination,'')) as edi_shipto,
		CONVERT( char(80), 'DESADV') AS DocumentType,
		CONVERT( char(80), '') AS ASNOverlayGroup,
		CONVERT( char(80), 'LBR') AS LBR,
		CONVERT( char(80), 'C62') AS C62,
		CONVERT( char(80), 'MB') AS QualMB,
		CONVERT( char(80), '16') AS Qual16,
		CONVERT( char(80), '92') AS Qual92,
		CONVERT( char(80), '12') AS TransQual,
		CONVERT( char(80), '182') AS RESPONSIBLEAGENCY,
		CONVERT( char(80), 'TE') AS EQUIPMENTTYPE,
		CONVERT( char(80), '9') AS MESSAGEFUNCTION,
		CONVERT( char(80), 'G') AS G,
		CONVERT( char(80), 'N') AS N,
		CONVERT( char(80), 'SQ') AS SQ,
		CONVERT( char(80), 'MB') AS MB,
		CONVERT( char(80), 'COF') AS COF,
		CONVERT( char(80), '182') AS Code182,
		CONVERT( char(80), 'CN') AS ProNumberQual
				
		Into	#DESADVHeaderRaw
	from	shipper
	JOIN	edi_setups ON dbo.shipper.destination = dbo.edi_setups.destination 
	LEFT OUTER JOIN bill_of_lading  ON shipper.bill_of_lading_number = bill_of_lading.bol_number 
	left outer join carrier on shipper.bol_carrier = carrier.scac  
		 
	where	( ( shipper.id = @shipper ) )

	--SELECT	*	FROM	#DESADVHeaderRaw
								
	INSERT	#DESADVHeaderFlatFileLines (LineData)
	SELECT	('//STX12//X12'+ LEFT(TradingPArtnerCode,12)+LEFT(ShipperID,30)+ LEFT(PartialComplete,1) +LEFT(DocumentType,10) + LEFT(DocumentType,6)+ LEFT(ASNOverlayGroup,3)) FROM #DESADVHeaderRaw
	INSERT	#DESADVHeaderFlatFileLines (LineData)
	Select	('01'+ LEFT(ShipperID,35)+ LEFT(MESSAGEFUNCTION,3)+ LEFT(ASNdate,35)) FROM #DESADVHeaderRaw
	INSERT	#DESADVHeaderFlatFileLines (LineData)
	Select	('02'+ LEFT(DateShipped,35)+ LEFT(ArrivalDate,35)) FROM #DESADVHeaderRaw
	INSERT	#DESADVHeaderFlatFileLines (LineData)
	Select	('03'+ LEFT(G,3) + LEFT(LBR,3)+ LEFT(GrossWeightLBS,18)) FROM #DESADVHeaderRaw
	INSERT	#DESADVHeaderFlatFileLines (LineData)
	Select	('03'+ LEFT(N,3) + LEFT(LBR,3)+ LEFT(NetWeightLBS,18) ) FROM #DESADVHeaderRaw
	INSERT	#DESADVHeaderFlatFileLines (LineData)
	select	('03'+ LEFT(SQ,3) + LEFT(C62,3)+ LEFT(StagedObjs,18) ) from #DESADVHeaderRaw
	INSERT	#DESADVHeaderFlatFileLines (LineData)
	select	('04'+ LEFT(ProNumberQual,3) + LEFT(ProNumber,35)) from #DESADVHeaderRaw
	INSERT	#DESADVHeaderFlatFileLines (LineData)
	select	('04'+ LEFT(MB,3) + LEFT(BOL,35)) from #DESADVHeaderRaw
	INSERT	#DESADVHeaderFlatFileLines (LineData)
	select	('04'+ LEFT(COF,3) + LEFT(ShippingDock,35)) from #DESADVHeaderRaw
	INSERT	#DESADVHeaderFlatFileLines (LineData)
	select	('05'+ LEFT(MaterialIssuer,35) + LEFT(Qual16,3)) from #DESADVHeaderRaw
	INSERT	#DESADVHeaderFlatFileLines (LineData)
	select	('06'+ LEFT(edi_shipto,35) + LEFT(Qual92,3)+ LEFT(edi_shipto,25)) from #DESADVHeaderRaw	
	INSERT	#DESADVHeaderFlatFileLines (LineData)
	select	('07' +  LEFT(SupplierCode,35) + LEFT(Qual16,3)+ LEFT(SupplierCode,35)+ LEFT(Qual16,3)) from #DESADVHeaderRaw
	--Need to define following data Where do we store ordered by?
	--INSERT	#DESADVHeaderFlatFileLines (LineData)
	--select	('08'+ LEFT(MaterialIssuer,35) + LEFT(Qual92,3)) from #DESADVHeaderRaw
	INSERT	#DESADVHeaderFlatFileLines (LineData)
	select	('11' + LEFT(TransQual,3) + LEFT(TransMode,3) + LEFT(SCAC,17) + LEFT(Code182,3)) from #DESADVHeaderRaw
	INSERT	#DESADVHeaderFlatFileLines (LineData)
	select	('12' + LEFT(EQUIPMENTTYPE,3) + left(TruckNumber,17)) from #DESADVHeaderRaw
	INSERT	#DESADVHeaderFlatFileLines (LineData)
	select	('13' + LEFT(SealNumber,10) ) from #DESADVHeaderRaw

		
	Select	CONVERT(char(80),LineData)+CONVERT(char(3), LINEID)
	From	#DESADVHeaderFlatFileLines
	order BY LineID
		
		
END













GO
