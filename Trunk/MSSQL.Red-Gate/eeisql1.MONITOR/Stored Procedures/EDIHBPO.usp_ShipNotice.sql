SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EDIHBPO].[usp_ShipNotice]  (@shipper int)
as
begin

--EDIHBPO.usp_ShipNotice 63669
set ANSI_Padding on
--ASN Header

declare
	@TradingPartner	char(12),
	@ShipperID char(30),
	@PartialComplete char(1),
	@ASNDate char(8),
	@ASNTime char(4),
	@ShippedDate char(8),
	@ShippedTime char(4),
	@GrossWeightLbs char(22),
	@PackagingCode char(5),
	@PackCount char(8),
	@SCAC char(4),
	@TransMode char(1),
	@TrailerNumber char(10),
	@REFBMQual char(2),
	@REFPKQual char(2),
	@REFCNQual char(2),
	@REFBMValue char(30),
	@REFPKValue char(30),
	@REFCNValue char(30),
	@FOB char(2),
	@SupplierName char(75),
	@SupplierCode char(35),
	@ShipToName char(75),
	@ShipToID char(35),
	@RoutingCode char(35),
	@SellerID char(35),
	@SellerName char(75),
	@SoldToID char(35),
	@ConsolidationCenterID char(35),
	@SoldToName char(75),
	@ConsolidationCenterName char(75)
	
	select
		@TradingPartner	= coalesce(es.trading_partner_code, 'HBPO'),
		@ShipperID =  s.id,
		@PartialComplete = '' ,
		@ASNDate = convert(char, getdate(), 112) ,
		@ASNTime = left(replace(convert(char, getdate(), 108), ':', ''),4),
		@ShippedDate = convert(char, s.date_shipped, 112)  ,
		@ShippedTime =  left(replace(convert(char, date_shipped, 108), ':', ''),4),
		@GrossWeightLbs = convert(char,convert(int,s.gross_weight)),
		@PackagingCode = 'CNT71' ,
		@PackCount = s.staged_objs,
		@SCAC = s.ship_via,
		@TransMode = case when trans_mode like '%A%' then 'A' else 'M' end ,
		@TrailerNumber = s.truck_number,
		@REFBMQual = 'BM' ,
		@REFPKQual = 'PK',
		@REFCNQual = 'CN',
		@REFBMValue = coalesce(bill_of_lading_number, id),
		@REFPKValue = id,
		@REFCNValue = pro_number,
		@FOB = case when freight_type =  'Collect' then 'CC' when freight_type in  ('Consignee Billing', 'Third Party Billing') then 'TP' when freight_type  in ('Prepaid-Billed', 'PREPAY AND ADD') then 'PA' when freight_type = 'Prepaid' then 'PP' else '' end ,
		@RoutingCode = 'NA',
		@ConsolidationCenterID  = case when trans_mode like '%A%' then '' else coalesce(pool_code, '') end,
		@ConsolidationCenterName = coalesce((select max(name) from destination where destination = pool_code),''),
		@SoldToID = d.destination,
		@SoldToName =  d.name,
		@ShipToID = es.destination,
		@ShipToName =  d.name,
		@SellerID =  coalesce(es.supplier_code,'SUPP'),
		@SellerName = 'Titan Tool & Die, Ltd.',
		@SupplierCode =  coalesce(es.supplier_code,'SUPP'),	
		@SupplierName = 'Titan Tool & Die, Ltd.'
		
	from
		Shipper s
	join
		dbo.edi_setups es on s.destination = es.destination
	join
		dbo.destination d on es.destination = d.destination
	
	where
		s.id = @shipper
	

Create	table	#ASNFlatFile (
				LineId	int identity,
				LineData char(79) )

INSERT	#ASNFlatFile (LineData)
	SELECT	('//STX12//856'+  @TradingPartner + @ShipperID+ @PartialComplete )
INSERT	#ASNFlatFile (LineData)
	SELECT	('01'+  @ShipperID + @ASNDate + @ASNTime + @ShippedDate + @ShippedTime+@GrossWeightLbs )
INSERT	#ASNFlatFile (LineData)
	SELECT	('02' + @PackagingCode + @PackCount )
INSERT	#ASNFlatFile (LineData)
	SELECT	('03' + @SCAC  + @TransMode + @RoutingCode + @TrailerNumber)
INSERT	#ASNFlatFile (LineData)
	SELECT	('04' + @REFBMQual + @REFBMValue )
INSERT	#ASNFlatFile (LineData)
	SELECT	('04' + @REFCNQual + @REFCNValue )
INSERT	#ASNFlatFile (LineData)
	SELECT	('04' + @REFPKQual + @REFPKValue )
INSERT	#ASNFlatFile (LineData)
	SELECT	('05' + @FOB  )
if @ConsolidationCenterID>''
Begin
INSERT	#ASNFlatFile (LineData)
	SELECT	('06' + @ConsolidationCenterName )
end
if @ConsolidationCenterID>''
Begin
INSERT	#ASNFlatFile (LineData)
	SELECT	('07' + @ConsolidationCenterID )
End
INSERT	#ASNFlatFile (LineData)
	SELECT	('08' + @SoldToName )
INSERT	#ASNFlatFile (LineData)
	SELECT	('09' + @SoldToID )
INSERT	#ASNFlatFile (LineData)
	SELECT	('10' + @ShipToName )
INSERT	#ASNFlatFile (LineData)
	SELECT	('11' + @ShipToID )
INSERT	#ASNFlatFile (LineData)
	SELECT	('12' + @SellerName )
INSERT	#ASNFlatFile (LineData)
	SELECT	('13' + @SellerID )
INSERT	#ASNFlatFile (LineData)
	SELECT	('14' + @SupplierName )
INSERT	#ASNFlatFile (LineData)
	SELECT	('15' + @SupplierCode )

 --ASN Detail

declare	@ShipperDetail table (
	ID int identity(1,1),
	Part varchar(25),
	CustomerPart varchar(35),
	CustomerPO varchar(35),
	CustomerECL varchar(35),
	DockCode varchar(35),
	Qty int,
	AccumShipped int primary key (ID))
	
insert	@ShipperDetail 
(	Part,
	CustomerPart,
	CustomerPO,
	CustomerECL,
	DockCode,
	Qty,
	AccumShipped
	)
	
select
	part_original,
	sd.customer_part,
	sd.customer_po,
	coalesce(oh.engineering_level,''),
	coalesce(s.shipping_dock,''),
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
	coalesce(pm.name,'CTN71') ,
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
	nullif(at.parent_serial,0) is null and
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
		then convert(varchar(15), max(serial)) 
		else convert(varchar(15), min(serial)) + ':' + convert(varchar(15), max(serial)) end
From
	@AuditTrailPartPackGroupRangeID atR

group by
	part,
	PackageType,
	PartPackQty,
	RangeID


--Delcare Variables for ASN Details		
declare	
	@LineItemID char(6),
	@CustomerPart char(35) ,
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
	@PackageType char(17),
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
	@UM char(3)
	 
--Populate Static Variables
select	@CountryOfOrigin = 'CA'
select	@PartUM = 'EA'	
select	@PCI_S = 'S'
select	@PCI_M = 'M'
Select	@DunnageIdentifier = '37'
Select	@DunnagePackType = 'HBPODunnage'
Select	@UM = 'C62'
Select  @PCIQualifier = '17'
Select 	@CPS03 = 1
Select	@SupplierPartQual = 'SA'
Select	@CustomerECLQual = 'DR'
 			
declare
	PartPOLine cursor local for
select
	ID = ID,
	InternalPart = Part,
	CustomerPart = customerpart,
	CustomerPO = customerpo,
	CustomerECL = customerECL,
	DockCode = DockCode,
	QtyShipped = convert(int, Qty),
	AccumShipped = convert(int, AccumShipped)
From
	@ShipperDetail SD

open
	PartPOLine

while
	1 = 1 begin
	
	fetch
		PartPOLine
	into
		@LineItemID,
		@Part,
		@CustomerPart,
		@CustomerPO,
		@CustomerECL,
		@DockCode,
		@PartQty,
		@PartAccum
			
	if	@@FETCH_STATUS != 0 begin
		break
	end

		

		Insert	#ASNFlatFile (LineData)
		Select '33'
				+ @CPS03


		declare PartPack cursor local for
			select
				*
			From
				@AuditTrailPartPackGroup
			where
				part = @Part
												
			open
				PartPack

			while
				1 = 1 begin
							
				fetch
					PartPack
				into
					@Part,
					@PackageType,
					@PartPackQty,
					@PartPackCount
								
																								
				if	@@FETCH_STATUS != 0 begin
					break
				end
					Select @DunnageCount = floor((convert(int,@PartPackQty) -.1)/6)+1
																					
					Insert	#ASNFlatFile (LineData)
					Select  '34' 
							+ @DunnageCount 
							+ @DunnageIdentifier 
							+ @DunnagePackType										
							+ @PartPackCount
							+ @PackageType
							+ @PartPackQty
							+ @UM
							
								
					Insert	#ASNFlatFile (LineData)
					Select  '35' 
							+ @PCIQualifier
							+ @PCI_S
										
																	
							declare PartPackSerialRange cursor local for

							Select	SerialRange
							From
							@AuditTrailPartPackGroupSerialRange
													

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
																			
														
																					
					End
							
					close
						PartPack
					deallocate
						PartPack
	

		Select @SupplierPart = @Part
		Insert	#ASNFlatFile (LineData)
		Select  '41' 
				+ @LineItemID 
				+ @CustomerPart
		
		Insert	#ASNFlatFile (LineData)
		Select  '42' 
				+ @SupplierPart 
				+ @SupplierPartQual
				+ @CustomerECL
				+ @CustomerECLQual
		
		Insert	#ASNFlatFile (LineData)
		Select  '43' 
				+ @PartQty 
				+ @UM 
				+ @CountryOfOrigin
		
		Insert	#ASNFlatFile (LineData)
		Select  '49' 
				+ @CustomerPO 
				+ @DockCode
	
	end	
	
	
close
	PartPOLine	
 
deallocate
	PartPOLine


select 
	LineData
From 
	#ASNFlatFile
order by 
	LineID

	
	      
set ANSI_Padding OFF	
End
         






GO
