SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [dbo].[MagnaASN]  (@shipper int)
as
begin
--[dbo].[MagnaASN] 58071
--[dbo].[MagnaASN] 71463
--TLW Form MMS_856_D_v4010_MAGNA MISSISSAUGA SI_090116

set ANSI_Padding on
--ASN Header

declare
	@TradingPartner	char(12),
	@ShipperID char(30),
	@ShipperID2 char(8),
	@PartialComplete char(1),
	@PurposeCode char(2),
	@ASNDate char(8),
	@ASNTime char(8),
	@ShippedDateQual char(3),
	@ShippedDate char(8),
	@ShippedTime char(8),
	@EstArrivalDateQual char(3),
	@EstArrivalDate char(8),
	@EstArrivalTime char(8),
	@TimeZone char(2),
	@GrossWeightQualifier char(3),
	@GrossWeightLbs char(12),
	@NetWeightQualifier char(3),
	@NetWeightLbs char(12),
	@WeightUM char(2),
	@CompositeUM char(78),
	@PackagingCode char(5),
	@PackCount char(8),
	@SCAC char(17),
	@TransMode char(2),
	@LocationQualifier char(2),
	@PPCode char(30),
	@EquipDesc char(2),
	@EquipInit char(4),
	@TrailerNumber char(10),
	@REFBMQual char(2),
	@REFPKQual char(2),
	@REFPKQual2 char(3),
	@REFCNQual char(2),
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
	@ShipToQualifier char(2),
	@ShipFromQualifier char(2),
	@SupplierQualifier char(2),	
	@ShipToIDType char(2),	
	@ShipFromIDType char(2),
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
		@ASNDate = convert(char, getdate(), 112) ,
		@ASNTime = left(replace(convert(char, getdate(), 108), ':', ''),4),
		@ShippedDateQual = '011',
		@ShippedDate = convert(char, s.date_shipped, 112)  ,
		@ShippedTime =  left(replace(convert(char, date_shipped, 108), ':', ''),4),
		@TimeZone = [dbo].[udfGetDSTIndication](date_shipped),
		@EstArrivalDateQual = '017',
		@GrossWeightLbs = convert(char,convert(int,s.gross_weight)),
		@NetWeightLbs = convert(char,convert(int,s.net_weight)),
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
		@FOB = case when freight_type =  'Collect' then 'CC' when freight_type in  ('Consignee Billing', 'Third Party Billing') then 'TP' when freight_type  in ('Prepaid-Billed', 'PREPAY AND ADD') then 'PA' when freight_type = 'Prepaid' then 'PP' else 'CC' end ,
		@SupplierName = 'Empire Electronics, Inc.' ,
		@SupplierCode = coalesce(es.supplier_code, 'US0811') ,
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

INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('//STX12//856'+  @TradingPartner + @ShipperID+ @PartialComplete ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('01'+  @PurposeCode + @ShipperID + @ASNDate + @ASNTime   ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('02' +  @ShippedDateQual + @ShippedDate + @ShippedTime ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('02' +  @EstArrivalDateQual + @EstArrivalDate + @EstArrivalTime ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('03' + @GrossWeightQualifier + @GrossWeightLbs ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('03' + @NetWeightQualifier + @NetWeightLbs  ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('04' + @PackagingCode + @PackCount + @SCACQualifier + @SCAC + @TransMode + (case when nullif(@PoolCode,'') is null then space(2) else @LocationQualifier   end ) +  @PoolCode +  @EquipDesc +  @TrailerNumber ),1	
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('05' + @REFBMQual + @REFPKValue ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('05' + @REFPKQual + @REFPKValue ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('06' + @SupplierQualifier  + @SupplierIDType + @SupplierCode  ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('06' + @ShipToQualifier  + @ShipToIDType + @ShipToID  ),1


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
	coalesce(sd.Customer_PO,''),
	sd.alternative_qty,	
	sd.Accum_Shipped,
	coalesce(oh.engineering_level,'')
	
from
	shipper s
join
	dbo.shipper_detail sd on s.id  = sd.shipper and sd.shipper =  @shipper
left join
	order_header oh on sd.order_no = oh.order_no
where part not like 'CUM%'

	
	
	
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
	
order by 1 asc, 2 desc, 3 asc, 4 asc

--Select		*	from		@shipperDetail order by packingslip
--Select		*	from		@shipperserials

--Delcare Variables for ASN Details		
declare	
	@CustomerPartBP char(2),
	@CustomerPartEC char(2),
	@CustomerPart char(20) ,
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
select @CustomerPartBP = 'BP'
select @UM = 'EA'
	
Create	table	#FlatFileLines (
				LineId	int identity(1,1),
				DetailLineID int,
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
	
	INSERT	#FlatFileLines (LineData, DetailLineID)
		SELECT	('07'+ @CustomerpartBP + @CustomerPart +  @QtyPacked +  @UM + @AccumShipped + @CustomerPO   ),2
		
		INSERT	#FlatFileLines (LineData, DetailLineID)
		SELECT	('08' +  @REFPKQual2 + @ShipperID2    ),2
		
		
				
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
									
					--INSERT	#FlatFileLines (LineData)
					--SELECT	('09'+ @ContainerCount +   @PackQty +  @PackageType )
					
					
					
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
									
									--INSERT	#FlatFileLines (LineData)
									--SELECT	('15'+  @SerialNumber   )
					
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
	#ASNResultSet (FFdata  char(80), DetailLineID int, LineID int)

insert #ASNResultSet
        ( FFdata, DetailLIneID, LineID )

select
	Convert(char(80), LineData), DetailLineID, LineID
from	
	#ASNFlatFileHeader

insert
	#ASNResultSet (FFdata, DetailLineID, LineID)
select
	Convert(char(79), LineData) +  convert(char(1), LineID) , DetailLineID, LineID
from	
	#FlatFileLines
	
select	FFdata
from		#ASNResultSet
order by DetailLineID, LineID asc

      
set ANSI_Padding OFF	
End
         









GO
