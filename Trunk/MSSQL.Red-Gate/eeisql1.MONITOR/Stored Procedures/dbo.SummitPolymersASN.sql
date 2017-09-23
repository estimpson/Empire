SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE	procedure [dbo].[SummitPolymersASN]  (@shipper int)
as
begin
--[dbo].[SummitPolymersASN] 48959
--[dbo].[SummitPolymersASN] 65630
--Using SY7_DESADV_D_Dr97A_SUMMIT POLYMER_120508 data entry form in TLW

set ANSI_Padding on
--ASN Header

declare
	@TradingPartner	char(12),
	@ShipperID char(35),
	@ShipperID2 char(30),
	@PartialComplete char(1),
	@PurposeCode char(2),
	@DateTypeDateShipped char(3),
	@DateTypeGetDate char(3),
	@DateTypeArrivalDate char(3),
	@ASNDate char(35),
	@ASNTime char(8),
	@ShippedDate char(35),
	@ArrivalDate char(35),
	@ShippedTime char(8),
	@TimeZone char(2),
	@GrossWeightQualifier char(3),
	@GrossWeightLbs char(18),
	@NetWeightQualifier char(3),
	@NetWeightLbs char(18),
	@WeightUM char(3),
	@PackagingCode char(5),
	@PackCount char(8),
	@SCAC char(17),
	@TransMode char(3),
	@LocationQualifier char(2),
	@PPCode char(30),
	@EquipDesc char(3),
	@EquipInit char(4),
	@TrailerNumber char(17),
	@REFBMQual char(3),
	@REFPKQual char(3),
	@REFCNQual char(3),
	@REFBMValue char(35),
	@REFPKValue char(30),
	@REFCNValue char(30),
	@FOB char(2),
	@ProNumber char(16),
	@SealNumber char(8),
	@SupplierName char(35),
	@SupplierCode char(35),
	@MaterialIssuerID char(35),
	@MaterialIssuerName char(35),
	@ShipToName char(35),
	@ShipToID char(35),	
	@AETCResponsibility char(1),
	@AETC char(8),
	@DockCode char(8),
	@PoolCode char(30),
	@EquipInitial char(4),
	@DocType6 char(6) ,
	@DocType10 char(10)
	
	select
		@TradingPartner	= es.trading_partner_code ,
		@ShipperID =  s.id,
		@ShipperID2 =  s.id,
		@PartialComplete = '' ,
		@PurposeCode = '00',
		@ASNDate = convert(char, getdate(), 112) ,
		@ASNTime = left(replace(convert(char, getdate(), 108), ':', ''),4),
		@ShippedDate = convert(char, s.date_shipped,112)  ,
		@ArrivalDate = convert(char, dateadd(dd,1,s.date_shipped) ,112)  ,
		@ShippedTime =  left(replace(convert(char, date_shipped, 108), ':', ''),4),
		@TimeZone = [dbo].[udfGetDSTIndication](date_shipped),
		@GrossWeightLbs = convert(char,convert(int,s.gross_weight)),
		@NetWeightLbs = convert(char,convert(int,s.net_weight)),
		@PackagingCode = 'CTN25' ,
		@PackCount = s.staged_objs,
		@SCAC = s.ship_via,
		@TransMode = s.trans_mode ,
		@TrailerNumber = coalesce(nullif(s.truck_number,''), s.id),
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
		@MaterialIssuerID = COALESCE(es.material_issuer,''),
		@AETCResponsibility = case when upper(left(aetc_number,2)) = 'CE' then 'A' when upper(left(aetc_number,2)) = 'SR' then 'S' when upper(left(aetc_number,2)) = 'CR' then 'Z' else '' end,
		@AETC =coalesce(s.aetc_number,''),
		@LocationQualifier =case when s.trans_mode in ('A', 'AC','AE') then 'OR'  when isNull(nullif(pool_code,''),'-1') = '-1' then '' else 'PP' end,
		@PoolCode = case when s.trans_mode in ('A', 'AC','AE') then Left(s.pro_number,3)  when s.trans_mode in ('E', 'U') then '' else coalesce(pool_code,'') end,
		@EquipDesc = 'TE',
		@EquipInitial = coalesce( bol.equipment_initial, s.ship_via ),
		@SealNumber = coalesce(s.seal_number,''),
		@Pronumber = coalesce(s.pro_number,''),
		@DockCode = coalesce(s.shipping_dock, ''),
		@GrossWeightQualifier = 'G',
		@NetWeightQualifier = 'N',
		@WeightUM = 'LBR',
		@DateTypeArrivalDate = '132',
		@DateTypeDateShipped = '11',
		@DateTypeGetDate = '137',
		@DocType10 = 'DESADV',
		@DocType6 = 'DESADV'
		
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
	SELECT ('//STX12//X12'+ @TradingPartner + @ShipperID2 + space(1) + @docType10 +  @DocType6 )
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('01' + @ShipperID)
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('02' + @DateTypeDateShipped + @ShippedDate)
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('02' + @DateTypeGetDate + @ASNDate)
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('02' + @DateTypeArrivalDate + @ArrivalDate)
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('03' + @WeightUM + @GrossWeightLbs+ @WeightUM + @NetWeightLbs  )
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('04' +  space(35) + @REFBMValue  )
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('05' + @MaterialIssuerID )
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('06' + @SupplierCode + @SupplierName)
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('07' + @ShipToID )
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('08' + @TransMode + @SCAC)
INSERT	#ASNFlatFileHeader (LineData)
	SELECT	('09' + @EquipDesc + @TrailerNumber)


 --ASN Detail

declare	@ShipperDetail table (
	Part varchar(25),
	PackingSlip varchar(25),
	ShipperID int,
	CustomerPart varchar(35),
	CustomerPO varchar(35),
	SDQty int,
	SDAccum int,
	BoxesStaged int,
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
			BoxesStaged 
          
        )	
select
	left(sd.part_original,7),
	sd.shipper,
	sd.shipper,
	sd.Customer_Part,
	max(sd.Customer_PO),
	sum(sd.alternative_qty),	
	max(sd.Accum_Shipped),
	sum(sd.boxes_staged)
	
from
	shipper s
join
	dbo.shipper_detail sd on s.id  = sd.shipper and sd.shipper =  @shipper
join
	order_header oh on sd.order_no = oh.order_no
group by
	left(sd.part_original,7),
	sd.shipper,
	sd.shipper,
	sd.Customer_Part

--Delcare Variables for ASN Details		
declare
	@CPSCounter int,
	@CPS01 char(12),
	@CPS03 char(3),
	@MarkingInstructions char(3),	
	@CustomerPartBP char(2),
	@CustomerPartEC char(2),
	@CustomerPart char(35) ,
	@CustomerECL char(40),
	@Part varchar(25),
	@QtyTypeQty char(3),
	@QtyTypeAccum char(3),
	@QtyPacked char(17),
	@UM char(3),
	@AccumShipped char(17),
	@CustomerPO char(35),
	@ContainerCount char(6),
	@PackageType char(5),
	@PackQty char(12),
	@SerialNumber char(30),
	@BoxesStaged char(10)
	
select @CustomerPartEC = 'EC'
Select @MarkingInstructions = '16'
Select @QtyTypeQty = '12'
Select @QtyTypeAccum = '3'
Select @CPSCounter = 0
Select @CPS03 = '4'
	
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
	        BoxesStaged
From
	@ShipperDetail SD
	order by
		CustomerPart

open
	PartPOLine
while
	1 = 1 begin

	Select @CPSCounter = @CPSCounter + 1
	
	fetch
		PartPOLine
	into
		@Part ,
		@CustomerPart ,
		@CustomerPO,
		@QtyPacked,
		@UM,
		@AccumShipped,
		@BoxesStaged
			
	if	@@FETCH_STATUS != 0 begin
		break
	end
	
	--print @ASNOverlayGroup

	Select @CPS01 = @CPSCounter
	
	INSERT	#FlatFileLines (LineData)
		SELECT	('10'+  @CPS01 + @CPS03 )
	INSERT	#FlatFileLines (LineData)
		SELECT	('11'+  @BoxesStaged )
	INSERT	#FlatFileLines (LineData)
		SELECT	('12'+  @MarkingInstructions)	
	INSERT	#FlatFileLines (LineData)	
		SELECT	('13'+  @CustomerPart  )
	INSERT	#FlatFileLines (LineData)
		SELECT	('14'+  @QtyTypeQty + @QtyPacked + @UM  )
	INSERT	#FlatFileLines (LineData)
		SELECT	('14'+  @QtyTypeAccum + @AccumShipped + @UM  )
	INSERT	#FlatFileLines (LineData)
		SELECT	('15' +  @CustomerPO   )
		
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
UNION ALL
select
	Convert(char(80), LineData),LineID
from	
	#FlatFileLines
order by 2 ASC

	
select	FFdata
from		#ASNResultSet
order by LineID asc

      
set ANSI_Padding OFF	
End
         




GO
