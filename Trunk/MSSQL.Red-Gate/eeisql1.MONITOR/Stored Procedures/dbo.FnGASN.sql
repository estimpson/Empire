SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE	procedure [dbo].[FnGASN]  (@shipper int)
as
begin
--[dbo].[FnGASN] 55483
--[dbo].[FnGASN] 74721
--TLW Form FNG_856_D_v4010_FLEX N GATE SOI_110308

set ANSI_Padding on
--ASN Header

declare
	@TradingPartner	char(12),
	@ShipperID char(30),
	@ShipperID2 char(16),
	@PartialComplete char(1),
	@PurposeCode char(2),
	@ASNDate char(8),
	@ASNTime char(8),
	@ShippedDate char(8),
	@ShippedTime char(8),
	@TimeZone char(2),
	@GrossWeightQualifier char(3),
	@GrossWeightLbs char(22),
	@NetWeightQualifier char(3),
	@NetWeightLbs char(22),
	@WeightUM char(2),
	@PackagingCode char(5),
	@PackCount char(8),
	@SCAC char(20),
	@TransMode char(2),
	@LocationQualifier char(2),
	@PPCode char(30),
	@EquipDesc char(2),
	@EquipInit char(4),
	@TrailerNumber char(10),
	@REFBMQual char(3),
	@REFPKQual char(3),
	@REFCNQual char(3),
	@REFBMValue char(30),
	@REFPKValue char(30),
	@REFCNValue char(30),
	@FOB char(2),
	@ProNumber char(16),
	@SealNumber char(8),
	@SupplierName char(35),
	@SupplierCode char(20),
	@ShipToName char(35),
	@ShipToID char(20),	
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
		@ASNDate = convert(char, getdate(), 112) ,
		@ASNTime = left(replace(convert(char, getdate(), 108), ':', ''),4),
		@ShippedDate = convert(char, s.date_shipped, 112)  ,
		@ShippedTime =  left(replace(convert(char, date_shipped, 108), ':', ''),4),
		@TimeZone = [dbo].[udfGetDSTIndication](date_shipped),
		@GrossWeightLbs = convert(char,convert(int,s.gross_weight)),
		@NetWeightLbs = convert(char,convert(int,s.net_weight)),
		@PackagingCode = 'CTN25' ,
		@PackCount = s.staged_objs,
		@SCAC = s.ship_via,
		@TransMode = s.trans_mode ,
		@TrailerNumber = coalesce(nullif(s.truck_number,''), convert(varchar(max),s.id)),
		@REFBMQual = 'BM' ,
		@REFPKQual = 'PK',
		@REFCNQual = 'CN',
		@REFBMValue = coalesce(bill_of_lading_number, id),
		@REFPKValue = id,
		@REFCNValue = pro_number,
		@FOB = case when freight_type =  'Collect' then 'CC' when freight_type in  ('Consignee Billing', 'Third Party Billing') then 'TP' when freight_type  in ('Prepaid-Billed', 'PREPAY AND ADD') then 'PA' when freight_type = 'Prepaid' then 'PP' else 'CC' end ,
		@SupplierName = 'Empire Electronics, Inc.' ,
		@SupplierCode = coalesce(es.supplier_code, '047380894') ,
		@ShipToName =  d.name,
		@ShipToID = COALESCE(nullif(es.parent_destination,''),es.destination),
		@AETCResponsibility = case when upper(left(aetc_number,2)) = 'CE' then 'A' when upper(left(aetc_number,2)) = 'SR' then 'S' when upper(left(aetc_number,2)) = 'CR' then 'Z' else '' end,
		@AETC =coalesce(s.aetc_number,''),
		@LocationQualifier =case when s.trans_mode in ('A', 'AC','AE') then 'OR'  when isNull(nullif(pool_code,''),'-1') = '-1' then '' else 'PP' end,
		@PoolCode = case when s.trans_mode in ('A', 'AC','AE') then Left(s.pro_number,3)  when s.trans_mode in ('E', 'U') then '' else coalesce(pool_code,'') end,
		@EquipDesc = coalesce( Nullif(es.equipment_description,''), 'TL' ),
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
	SELECT	('01'+  @PurposeCode + @ShipperID + @ASNDate + @ASNTime  )
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('02' + @ShippedDate + @ShippedTime + @TimeZone)
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('03' + @GrossWeightQualifier + @GrossWeightLbs + @WeightUM )
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('03' + @NetWeightQualifier + @NetWeightLbs + @WeightUM )
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('04' + @PackagingCode + @PackCount )
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('05' + @SCAC  + @TransMode + (case when nullif(@PoolCode,'') is null then space(2) else @LocationQualifier   end ) + @PoolCode )
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('06' +  @EquipDesc + @EquipInitial + @TrailerNumber )		
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('07' + @REFBMQual + @REFBMValue )
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('07' + @REFPKQual + @REFPKValue )
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('08' + @ShipToID + @ShipToName + @SupplierCode )
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('09' + @SupplierName )

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

insert @ShipperDetail
			( Part ,
			PackingSlip ,
			ShipperID,
			CustomerPart ,
			CustomerPO ,
			SDQty ,
			SDAccum ,
			EngLevel 
          
        )	
select
	sd.part_original,
	sd.shipper,
	sd.shipper,
	sd.Customer_Part,
	sd.Customer_PO,
	sd.alternative_qty,	
	sd.Accum_Shipped,
	coalesce(oh.engineering_level,'')
	
from
	shipper s
join
	dbo.shipper_detail sd on s.id  = sd.shipper and sd.shipper =  @shipper
join
	order_header oh on sd.order_no = oh.order_no

	
	
	
declare	@ShipperSerials table (
	Part varchar(25),
	PackageType varchar(25),
	PackCount int,
	PackQty int,
	Serial int
	primary key (Part, Serial)
	)

insert @ShipperSerials          
        	
select
	at.part,
	'PLT71',
	count(distinct parent_serial),
	sum(quantity),
	at.parent_serial
	
from
	audit_trail at
where
	at.type ='S'  and at.shipper =  convert(varchar(10), @shipper)
and 
	at.part != 'PALLET' 
and
	nullif(at.parent_serial,0) is not null
and not exists 
	(select 1 from audit_trail at2 where at2.type = 'S'  and at2.shipper = convert(varchar(10), @shipper) and at2.parent_serial = at.parent_serial and at2.part!=at.part)
group by 
	at.part,
	at.parent_serial
	
union        
        	
select
	at.part,
	'CTN90',
	count(1),
	max(quantity),
	at.serial 
	
from
	audit_trail at
where
	at.type ='S'  and at.shipper =  convert(varchar(10), @shipper)
and 
	at.part != 'PALLET' 
and
	nullif(at.parent_serial,0) is null
group by
	at.part,
	at.serial

union

select
	at.part,
	'CTN90',
	count(1),
	max(quantity),
	at.serial 
	
from
	audit_trail at
where
	at.type ='S'  and at.shipper =  convert(varchar(10), @shipper)
and 
	at.part != 'PALLET' 
and
	nullif(at.parent_serial,0) is not null
and exists 
	(select 1 from audit_trail at2 where at2.type = 'S'  and at2.shipper = convert(varchar(10), @shipper) and at2.parent_serial = at.parent_serial and at2.part!=at.part)
group by
	at.part,
	at.serial
	
order by 1 asc, 2 desc, 3 asc, 4 asc

--Select		*	from		@shipperDetail order by packingslip
--Select		*	from		@shipperserials

--Delcare Variables for ASN Details		
declare	
	@CustomerPartBP char(2),
	@CustomerPartEC char(2),
	@CustomerPart char(40) ,
	@CustomerECL char(40),
	@Part varchar(25),
	@QtyPacked char(12),
	@UM char(2),
	@AccumShipped char(11),
	@CustomerPO char(22),
	@ContainerCount char(6),
	@PackageType char(5),
	@PackQty char(12),
	@SerialNumber char(30)
	
select @CustomerPartEC = 'EC'
	
Create	table	#FlatFileLines (
				LineId	int identity(200,1),
				LineData char(80)
				 )

declare
	PartPOLine cursor local for
select
			Part ,
	        CustomerPart ,
	        CustomerPO ,
	        SDQty ,
	        'EA',
	        SDAccum ,
	        EngLevel
From
	@ShipperDetail SD
	order by
		CustomerPart

open
	PartPOLine
while
	1 = 1 begin
	
	fetch
		PartPOLine
	into
		@Part ,
		@CustomerPart ,
		@CustomerPO,
		@QtyPacked,
		@UM,
		@AccumShipped,
		@CustomerECL 
			
	if	@@FETCH_STATUS != 0 begin
		break
	end
	
	--print @ASNOverlayGroup
	
	INSERT	#FlatFileLines (LineData)
		SELECT	('10'+  @CustomerPart + @CustomerPartEC      )
		
		INSERT	#FlatFileLines (LineData)
		SELECT	('11' +  @CustomerECL + @QtyPacked +  @UM + @AccumShipped + @UM   )
		
		INSERT	#FlatFileLines (LineData)
		SELECT	('12' + @CustomerPO   )
		
				
				declare PackType cursor local for
				select	Part ,
							PackageType ,
							sum(PackCount) ,
							PackQty
				From
					@ShipperSerials
				where					
					part = @Part 
				group by
					part,
					PackageType,
					PackQty
							
					open	PackType

					while	1 = 1 
					begin
					fetch	PackType	into
					@Part,
					@PackageType,
					@ContainerCount,
					@PackQty					
					
					if	@@FETCH_STATUS != 0 begin
					break
					end
									
					INSERT	#FlatFileLines (LineData)
					SELECT	('14'+ @ContainerCount +   @PackQty +  @PackageType )
					
					
					
									declare PackSerial cursor local for
									select	
										Serial
									From
										@ShipperSerials
									where					
										part = @Part and
										PackageType = @PackageType and
										PackQty = @PackQty
									
									open	PackSerial
									while	1 = 1 
									begin
									fetch	PackSerial	into
									@SerialNumber
					
									if	@@FETCH_STATUS != 0 begin
									break
									end
									
									INSERT	#FlatFileLines (LineData)
									SELECT	('15'+  @SerialNumber   )
					
									end
									close PackSerial
									deallocate PackSerial
										
						
					end
					close PackType
					deallocate PackType
				
		
						
end
close	PartPOLine 
deallocate	PartPOLine
	


create	table
	#ASNResultSet (FFdata  char(80), LineID int)

insert #ASNResultSet
        ( FFdata, LineID )

select
	Convert(char(80), LineData), LineID
from	
	#ASNFlatFileHeader
insert
	#ASNResultSet (FFdata, LineID)
select
	Convert(char(77), LineData) + Convert(char(3), LineID),LineID
from	
	#FlatFileLines
	
select	FFdata
from		#ASNResultSet
order by LineID asc

      
set ANSI_Padding OFF	
End
         




GO
