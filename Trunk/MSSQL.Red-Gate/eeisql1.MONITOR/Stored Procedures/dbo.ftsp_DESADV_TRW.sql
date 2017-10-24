SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[ftsp_DESADV_TRW] (@shipper int)
as
begin
--[dbo].[ftsp_DESADV_TRW] 65017
 
 
set ANSI_Padding on
--ASN Header

declare
	@TradingPartnerCode	char(12),
	@ShipperID char(30),
	@MessageID char(35),
	@PartialComplete char(1),
	@DocumentType char(10),
	@DocumentType2 char(6),
	@ASNOverlayGroup char(3),
	@MessageFunction char(3),
	@ASNDate char(8),
-- 	@ASNTime char(8),
	@ShippedDate char(8),
 --	@ShippedTime char(8),
	@DTMQualifier_10 char(3),
	@DTMQualifier_97 char(3),
	@MEAQualifier_EGW char(3),
	@MEAQualifier_WT char(3),
	@MEAQualifier_AAW char(3),
	@MEAUM_KG char(3),
	@MEAUM_EA char(3),
	@GrossWeightKG char(22),
	@NetWeightKG char(22),
	@Lifts char(22),
	@REF01_PK char(3),
	@REF01_BM char(3),
	@BOL char(10),
	@EDIShipTo char(35),
	@SupplierCode char(35),
	@TruckNumber char(78),
	@TransModeCoded char(3),
	@SCAC char(17),
	@ShipFromQualifier char(3) 
 
 select
	@TradingPartnerCode	= coalesce(edi_setups.trading_partner_code,'TRW'),
	@ShipperID = isnull(shipper.id,0),
	@MessageID = isnull(shipper.id,0),
	@PartialComplete = '',
	@DocumentType = 'DESADV',
	@DocumentType2 = 'DESADV',
	@ASNOverlayGroup = '',
	@MessageFunction = '9',
	@ASNDate = convert(varchar(25), getdate(), 112), /*+LEFT(CONVERT(VARCHAR(25), GETDATE(), 108),2) +SUBSTRING(CONVERT(VARCHAR(25), GETDATE(), 108),4,2))*/
--	@ASNTime = convert( char(80), [MONITOR].[FT].[fn_DateTimeToString] ( getdate(),'hh') + [MONITOR].[FT].[fn_DateTimeToString] (getdate(),'nn')),
	@ShippedDate = convert(varchar(25), shipper.date_shipped, 112), /*+LEFT(CONVERT(VARCHAR(25), shipper.date_shipped, 108),2) +SUBSTRING(CONVERT(VARCHAR(25), shipper.date_shipped, 108),4,2))*/
--	@ShippedTime = convert( char(80), [MONITOR].[FT].[fn_DateTimeToString] ( shipper.date_shipped,'hh') + [MONITOR].[FT].[fn_DateTimeToString] (shipper.date_shipped,'nn')),
	@DTMQualifier_10 = '10',
	@DTMQualifier_97 = '97',
	@MEAQualifier_EGW = 'EGW',
	@MEAQualifier_WT = 'WT',
	@MEAQualifier_AAW = 'AAW',
	@MEAUM_KG = 'KG',
	@MEAUM_EA = 'EA',
	@GrossWeightKG = convert(int, ceiling(isnull(nullif(shipper.gross_weight,0),100) * .45359237)),
	@NetWeightKG = convert(int, ceiling(isnull(nullif(shipper.net_weight,0),100) * .45359237)),
	@Lifts =
	isnull((select	count(distinct Parent_serial) 
			from	audit_trail
			where	audit_trail.shipper = convert(char(10),@shipper) and
					audit_trail.type = 'S' and 
					isnull(parent_serial,0) >0 ),0) +
	isnull((select	count(serial) 
			from	audit_trail,
					package_materials
			where	audit_trail.shipper = convert(char(10),@shipper) and
					audit_trail.type = 'S' and
					part <> 'PALLET' and 
					parent_serial is NULL and
					audit_trail.package_type = package_materials.code and
					package_materials.type = 'B' ),0) +
	isnull((select	count(serial) 
			from	audit_trail,
					package_materials
			where	audit_trail.shipper =  convert(char(10),@shipper) and
					audit_trail.type = 'S' and 
					parent_serial is NULL and
					audit_trail.package_type = package_materials.code and
					package_materials.type = 'O' ),0),
	@REF01_PK = 'PK',
	@REF01_BM = 'BM',
	@BOL = coalesce(shipper.bill_of_lading_number,shipper.id, 0),
	@EDIShipTo = coalesce(edi_setups.parent_destination,edi_setups.destination, ''),
	@ShipFromQualifier = 'SF',
	@SupplierCode = isnull(edi_setups.supplier_code,''),
	@TruckNumber = upper(isnull(nullif(shipper.truck_number,''), convert(varchar(25), shipper.id))),
	@TransModeCoded = 
	case shipper.trans_mode 
		when 'A' then '40' 
		else '30' 
	end,
	@SCAC = isnull(shipper.ship_via,'')
from	
	shipper
	join edi_setups on dbo.shipper.destination = dbo.edi_setups.destination
	join destination on edi_setups.destination = destination.destination 
	left outer join bill_of_lading on shipper.bill_of_lading_number = bill_of_lading.bol_number 
	left outer join carrier on shipper.bol_carrier = carrier.scac  
where
	shipper.id = @shipper
	
	
print @GrossWeightKG
print @NetWeightKG

create	table	
	#ASNHeaderFlatFileLines (
	LineId	int identity (1,1),
	LineData char(80)
	)

insert	#ASNHeaderFlatFileLines (LineData)
select	('//STX12//X12' +  @TradingPartnerCode + @ShipperID + @PartialComplete + @DocumentType + @DocumentType2 + @ASNOverlayGroup)
	
insert	#ASNHeaderFlatFileLines (LineData)
select	('01' + @MessageID + @MessageFunction)

insert	#ASNHeaderFlatFileLines (LineData)
select	('02' + @DTMQualifier_10 + @ShippedDate)
	
insert	#ASNHeaderFlatFileLines (LineData)
select	('02' + @DTMQualifier_97 + @ASNDate)
	
insert	#ASNHeaderFlatFileLines (LineData)
select	('03' + @MEAQualifier_EGW + @MEAUM_KG + @GrossWeightKG)
	
insert	#ASNHeaderFlatFileLines (LineData)
select	('03' + @MEAQualifier_WT + @MEAUM_KG + @NetWeightKG)
	
insert	#ASNHeaderFlatFileLines (LineData)
select	('03' + @MEAQualifier_AAW + @MEAUM_EA + @Lifts)
	
insert	#ASNHeaderFlatFileLines (LineData)
select	('04' + @REF01_PK + @ShipperID)
	
insert	#ASNHeaderFlatFileLines (LineData)
select	('04' + @REF01_BM + @BOL)
	
insert	#ASNHeaderFlatFileLines (LineData)
select	('05' + @EDIShipTo)
	
insert	#ASNHeaderFlatFileLines (LineData)
select	('08' + @SupplierCode)
	
insert	#ASNHeaderFlatFileLines (LineData)
select	('09' + @TruckNumber)
	
insert	#ASNHeaderFlatFileLines (LineData)
select	('10' + @TransModeCoded + @SCAC)




--ASN Detail
declare @ShipperDetail table
(
	ShipperLine int identity(1,1),
	PartOriginal varchar(25),
	CustomerPart varchar(35),
	CustomerPO varchar(35),
	QtyShipped int,
	UM varchar(3),
	AccumShipped int
)

insert @ShipperDetail
(
	PartOriginal,
	CustomerPart,
	CustomerPO,
	QtyShipped,
	UM,
	AccumShipped
)
select	

	PartOriginal = COALESCE(left(sd.part_original,7),''),
	CustomerPart = coalesce(sd.customer_part,''),
	CustomerPO = coalesce(sd.customer_po,''),
	QtyShipped = convert(int, sum(sd.alternative_qty)),
	UM = max(coalesce(sd.alternative_unit,'PCE')),
	AccumShipped = convert(int, max(sd.accum_shipped))
from
	shipper_detail sd
where
	sd.shipper = @shipper
group by
	coalesce(left(sd.part_original,7),''),
	coalesce(sd.customer_part,''),
	coalesce(sd.customer_po,'')
	
	
	
--Delcare Variables for ASN Details	
declare
	@CPS char(2) = '1',
	@ShipperLine char(6),
	@PartOriginal char(25),
	@CustomerPart char(35),
	@CustomerPO char(35),
	@QtyShipped char(17),
	@UM varchar(3),
	@AccumShipped char(17)

 
--declare
--	@Part varchar(35)
--set 
--	@Part = ''	
	
declare
	Parts cursor local for
select
	ShipperLine,
	PartOriginal,
	CustomerPart,
	CustomerPO,
	QtyShipped,
	UM,
	AccumShipped
from	
	@ShipperDetail
	

open
	Parts

while
	1 = 1 begin
	
	fetch
		Parts
	into
		@ShipperLine,
		@PartOriginal,
		@CustomerPart,
		@CustomerPO,
		@QtyShipped,
		@UM,
		@AccumShipped
			
	if	@@FETCH_STATUS != 0 begin
		break
	end
	
		insert	#ASNHeaderFlatFileLines (LineData)
		select	('11' + @CPS)
	
		insert	#ASNHeaderFlatFileLines (LineData)
		select	('12' + @ShipperLine + @CustomerPart)
		
		insert	#ASNHeaderFlatFileLines (LineData)
		select	('13' + @CustomerPO)
		
		insert	#ASNHeaderFlatFileLines (LineData)
		select	('15' + @QtyShipped + convert(char(3),@UM) + @AccumShipped + convert(char(3), @UM))
end	
	
close parts
deallocate parts
 
 
select		
	convert(char(80),LineData)
from		
	#ASNHeaderFlatFileLines
order by	
	LineID
	

set ANSI_padding off
end


GO
