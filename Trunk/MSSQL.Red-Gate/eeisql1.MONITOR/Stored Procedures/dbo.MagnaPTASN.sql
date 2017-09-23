SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE procedure [dbo].[MagnaPTASN]  (@shipper int)
as
begin

--[dbo].[MagnaPTASN] 74396
/*


    FlatFile Layout for Overlay: MG1_856_D_v3060_MAGNA^SOI_070702     02-07-14 15:42

    Fixed Record/Fixed Field (FF)        Max Record Length: 080

    Input filename: DX-FX-FF.080         Output filename: DX-XF-FF.080


    Description                                            Type Start Length Element 

    Header Record '//'                                      //   001   002           

       RESERVED (MANDATORY)('STX12//')                      ID   003   007           

       X12 TRANSACTION ID (MANDATORY X12)                   ID   010   003           

       TRADING PARTNER (MANDATORY)                          AN   013   012           

       DOCUMENT NUMBER (MANDATORY)                          AN   025   030           

       FOR PARTIAL TRANSACTION USE A 'P' (OPTIONAL)         ID   055   001           

       EDIFACT(EXTENDED) TRANSACTION ID (MANDATORY EDIFACT) ID   056   010           

       DOCUMENT CLASS CODE (OPTIONAL)                       ID   066   006           

       OVERLAY CODE (OPTIONAL)                              ID   072   003           

       FILLER('      ')                                     AN   075   006           

       Record Length:                                                  080           

    Record '01'                                             01   001   002           

       ASN PURPOSE                                          AN   003   002    1BSN01 

       ASN #                                                AN   005   030    1BSN02 

       ASN DATE                                             DT   035   006    1BSN03 

       ASN TIME                                             TM   041   008    1BSN04 

       FILLER('                                ')           AN   049   032           

       Record Length:                                                  080           

    Record '02' (10 x - End Record '02')                    02   001   002           

       SHIPPED DATE                                         DT   003   006    1DTM02 

       SHIPPED TIME                                         TM   009   008    1DTM03 

       TIME CODE                                            AN   017   002    1DTM04 

       CENTURY                                              N    019   003    1DTM05 

       ('                                               ... AN   022   059           

       Record Length:                                                  080           

    Record '03' (40 x - End Record '03')                    03   001   002           

       MEASUREMENT REFERENCE ID                             AN   003   002    1MEA01 

       WEIGHT TYPE                                          AN   005   001    1MEA02 

       WEIGHT                                               R    006   022    1MEA03 

       UNIT OF MEASURE                                      AN   028   002    1MEA04 

                                          1
    Description                                            Type Start Length Element 

       ('                                               ... AN   030   051           

       Record Length:                                                  080           

    Record '04' (20 x - End Record '04')                    04   001   002           

       PACKAGING CODE                                       AN   003   005    1TD101 

       # OF UNITS                                           N    008   008    1TD102 

       ('                                               ... AN   016   065           

       Record Length:                                                  080           

    Record '05' (12 x - End Record '05')                    05   001   002           

       SCAC                                                 AN   003   020    1TD503 

       TRANSPORT METHOD                                     AN   023   002    1TD504 

       LOCATION TYPE                                        AN   025   002    1TD507 

       LOCATION ID                                          AN   027   030    1TD508 

       FILLER('                        ')                   AN   057   024           

       Record Length:                                                  080           

    Record '06'                                             06   001   002           

       EQUIPMENT DESCRIPTION CODE                           AN   003   002    1TD301 

       EQUIPMENT INITIAL                                    AN   005   004    1TD302 

       EQUIPMENT #                                          AN   009   010    1TD303 

       ('                                               ... AN   019   062           

       Record Length:                                                  080           

    Loop Start (5 x - End Record '09')                                               

       Record '07'                                          07   001   002           

          SPECIAL HANDLING CODE                             AN   003   003    1TD401 

          HAZARDOUS MATERIAL TYPE                           AN   006   001    1TD402 

          HAZARDOUS MATERIAL CODE                           AN   007   004    1TD403 

          ('                                            ... AN   011   070           

          Record Length:                                               080           

       Record '08'                                          08   001   002           

          DESCRIPTION                                       AN   003   078    1TD404 

          Record Length:                                               080           

       Record '09'                                          09   001   002           

          YES/NO CONDITION OR RESPONSE CODE                 AN   003   001    1TD405 

          ('                                            ... AN   004   077           

          Record Length:                                               080           

                                          2
    Description                                            Type Start Length Element 

    Record '10' (200 x - End Record '10')                   10   001   002           

       REFERENCE ID TYPE                                    AN   003   002    1REF01 

       REFERENCE ID                                         AN   005   030    1REF02 

       ..('                                              ') AN   035   046           

       Record Length:                                                  080           

    Loop Start (200 x - End Record '11')                                             

       Record '11'                                          11   001   002           

          ENTITY ID                                         AN   003   002    1N101  

          ID CODE TYPE                                      AN   005   002    1N103  

          ID                                                AN   007   020    1N104  

          NAME                                              AN   027   035    1N102  

          FILLER('                   ')                     AN   062   019           

          Record Length:                                               080           

    Loop Start (200000 x - End Record '19')                                          

       Record '12'                                          12   001   002           

          PRODUCT/SERVICE ID TYPE                           AN   003   002    1LIN02 

          PRODUCT/SERVICE ID                                AN   005   040    1LIN03 

          # OF UNITS SHIPPED                                R    045   012    1SN102 

          UNIT OF MEASURE                                   AN   057   002    1SN103 

          QUANTITY SHIPPED TO DATE                          R    059   011    1SN104 

          FILLER('           ')                             AN   070   011           

          Record Length:                                               080           

       Record '13'                                          13   001   002           

          PO #                                              AN   003   022    1PRF01 

          ('                                            ... AN   025   056           

          Record Length:                                               080           

       Record '14' (200 x - End Record '14')                14   001   002           

          REFERENCE ID TYPE                                 AN   003   003    4REF01 

          REFERENCE ID                                      AN   006   030    4REF02 

          ('                                             ') AN   036   045           

          Record Length:                                               080           

       Loop Start (200000 x - End Record '19')                                       

          Record '15' (40 x - End Record '15')              15   001   002           

             MEASUREMENT REFERENCE ID                       AN   003   002    2MEA01 

                                          3
    Description                                            Type Start Length Element 

             MEASUREMENT TYPE                               AN   005   002    2MEA02 

             MEASUREMENT VALUE                              R    007   022    2MEA03 

             UNIT OF MEASURE                                AN   029   002    2MEA040

             ('                                         ... AN   031   050           

             Record Length:                                            080           

          Record '16' (200 x - End Record '16')             16   001   002           

             REFERENCE ID TYPE                              AN   003   002    2REF01 

             REFERENCE ID                                   AN   005   030    2REF02 

             ('                                         ... AN   035   046           

             Record Length:                                            080           

          Loop Start (200 x - End Record '18')                                       

             Record '17'                                    17   001   002           

                # OF LOADS                                  N    003   006    1CLD01 

                # OF UNITS SHIPPED                          R    009   012    1CLD02 

                PACKAGING CODE                              AN   021   005    1CLD03 

                ('                                      ... AN   026   055           

                Record Length:                                         080           

             Record '18' (200 x - End Record '18')          18   001   002           

                REFERENCE ID TYPE                           AN   003   003    3REF01 

                REFERENCE ID                                AN   006   030    3REF02 

                ('                                      ... AN   036   045           

                Record Length:                                         080           

          Record '19'                                       19   001   002           

             EXCESS TRANSPORTATION REASON CODE              AN   003   002    1ETD01 

             EXCESS TRANSPORTATION RESPONSIBILITY CODE      AN   005   001    1ETD02 

             AUTHORIZATION FOR EXPENSE #                    AN   006   030    1ETD04 

             ('                                         ... AN   036   045           

             Record Length:                                            080           




*/

set ANSI_Padding on
--ASN Header

declare
	@TradingPartner	char(12),
	@ShipperID char(30),
	@ShipperID2 char(8),
	@PartialComplete char(1),
	@PurposeCode char(2) = '00',
	@ASNDate char(6),
	@ASNTime char(8),
	@ShippedDateQual char(3),
	@ShippedDate char(6),
	@ShippedTime char(8),
	@EstArrivalDateQual char(3),
	@EstArrivalDate char(8),
	@EstArrivalTime char(8),
	@TimeZone char(2),
	@Mea01RefID char(2) = 'PD',
	@GrossWeightQualifier char(1) ='G',
	@GrossWeightLbs char(22),
	@NetWeightQualifier char(1) = 'N',
	@NetWeightLbs char(22),
	@WeightUM char(2) = 'LB',
	@CompositeUM char(78),
	@PackagingCode char(5),
	@PackCount char(8),
	@SCAC char(20),
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
	@SupplierCode char(20),
	@ShipToName char(35),
	@ShipToID char(20),
	@ShipToQualifier char(2) = 'ST',
	@ShipFromQualifier char(2) = 'SF',
	@SupplierQualifier char(2)= 'SU',	
	@ShipToIDType char(2) = '92',	
	@ShipFromIDType char(2) = '92',
	@SupplierIDType char(2) ='92',
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
		@ASNDate = convert(char, getdate(), 12) ,
		@ASNTime = left(replace(convert(char, getdate(), 108), ':', ''),4),
		@ShippedDateQual = '011',
		@ShippedDate = convert(char, s.date_shipped, 12)  ,
		@ShippedTime =  left(replace(convert(char, date_shipped, 108), ':', ''),4),
		@TimeZone = [dbo].[udfGetDSTIndication](date_shipped),
		@EstArrivalDateQual = '017',
		@GrossWeightLbs = convert(char,convert(int,s.gross_weight)),
		@NetWeightLbs = convert(char,convert(int,s.net_weight)),
		@PackagingCode = 'CTN90' ,
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
		@ShipToName =  left(d.name,30),
		@ShipToID = COALESCE(nullif(es.parent_destination,''),es.destination),	
		@AETCResponsibility = case when upper(left(aetc_number,2)) = 'CE' then 'A' when upper(left(aetc_number,2)) = 'SR' then 'S' when upper(left(aetc_number,2)) = 'CR' then 'Z' else '' end,
		@AETC =coalesce(s.aetc_number,''),
		@LocationQualifier =case when s.trans_mode in ('A', 'AC','AE') then 'OR'  when isNull(nullif(pool_code,''),'-1') = '-1' then '' else 'PP' end,
		@PoolCode = case when s.trans_mode in ('A', 'AC','AE') then Left(s.pro_number,3)  when s.trans_mode in ('E', 'U') then '' else coalesce(pool_code,'') end,
		@EquipDesc = coalesce( es.equipment_description, 'TL' ),
		@EquipInitial = coalesce( left(truck_number,4), s.ship_via ),
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
	SELECT	('02' +  @ShippedDate + @ShippedTime + @TimeZone  ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('03' + @Mea01RefID + @GrossWeightQualifier + @GrossWeightLbs + @WeightUM ),1
--INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
--	SELECT	('03' + @Mea01RefID  + @NetWeightQualifier + @NetWeightLbs  ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('04' + @PackagingCode + @PackCount  ),1	
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('05' +  @SCAC + @TransMode + (case when nullif(@PoolCode,'') is null then space(2) else @LocationQualifier   end ) +  @PoolCode ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('06' + @EquipDesc + @EquipInitial +@TrailerNumber ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('10' + @REFPKQual + @REFPKValue  ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('11' + @SupplierQualifier  + @SupplierIDType + @SupplierCode + @SupplierName ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('11' + @ShipToQualifier  + @ShipToIDType + @ShipToID + @ShipToName  ),1


 --ASN Detail

declare	@ShipperDetail table (
	PackingSlip varchar(25),
	ShipperID int,
	CustomerPart varchar(35),
	CustomerPO varchar(35),
	SDQty int,
	SDAccum int,
	EngLevel varchar(25),
	primary key (CustomerPart, CustomerPO, PackingSlip)
	)

insert @ShipperDetail
			( 
			PackingSlip ,
			ShipperID,
			CustomerPart ,
			CustomerPO ,
			SDQty ,
			SDAccum ,
			EngLevel 
          
        )	
select
	max(sd.shipper),
	max(sd.shipper),
	sd.Customer_Part,
	coalesce(sd.Customer_PO,''),
	sum(sd.alternative_qty),
	max(sd.Accum_Shipped),
	max(coalesce(oh.engineering_level,''))
	
from
	shipper s
join
	dbo.shipper_detail sd on s.id  = sd.shipper and sd.shipper =  @shipper
left join
	order_header oh on sd.order_no = oh.order_no
where part not like 'CUM%'
group by
sd.Customer_Part,
coalesce(sd.Customer_PO,'')
		

	
	
	
declare	@ShipperSerials table (
	CustomerPart varchar(35),
	CustomerPO varchar(35),
	PackageType varchar(25),
	PackQty int,
	Serial int
	primary key (CustomerPart, Serial)
	)

insert @ShipperSerials          
      	
 select
	sd.customer_part,
	sd.customer_po,
	'CTN90',
	at.quantity,
	at.serial 
	
from
	audit_trail at
join
		shipper_detail sd on sd.part_original =  at.part and  sd.shipper = @shipper
where
	at.type ='S'  and at.shipper =  convert(varchar(10), @shipper)
and 
	at.part != 'PALLET' 

	
order by 1 asc, 3 asc, 4 asc

--Select		*	from		@shipperDetail order by packingslip
--Select		*	from		@shipperserials

--Delcare Variables for ASN Details		
declare	
	@CustomerPartBP char(2) = 'BP',
	@CustomerPartEC char(2) = 'EC',
	@CustomerPart char(40) ,
	@CustomerECL char(40),
	@CustomerPartLoop varchar(35),
	@CustomerPOLoop varchar(35),
	@PackTypeLoop varchar(35),
	@QtyPackedLoop int,
	@QtyPacked char(12),
	@UM char(2) ='PC' ,
	@AccumShipped char(11),
	@CustomerPO char(22),
	@ContainerCount char(6),
	@PackageType char(5),
	@PackQty char(12),
	@PackQtyLoop int,
	@SerialQualifier char(3) = 'LS',
	@SerialNumber char(30)
	

Create	table	#FlatFileLines (
				LineId	int identity(1,1),
				DetailLineID int,
				LineData char(80)
				 )

declare
	PartPOLine cursor local for
select
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
		@CustomerPartLoop ,
		@CustomerPOLoop,
		@QtyPackedLoop,
		@UM,
		@AccumShipped,
		@CustomerECL 
			
	if	@@FETCH_STATUS != 0 begin
		break
	end
	
	--print @ASNOverlayGroup

	Select @CustomerPart = @CustomerPartLoop
	Select @CustomerPO =  @CustomerPOLoop
	Select @QtyPacked = @QtyPackedLoop
	
	INSERT	#FlatFileLines (LineData, DetailLineID)
		SELECT	('12'+ @CustomerpartBP + @CustomerPart +  @QtyPacked +  @UM + @AccumShipped  ),2
	
		INSERT	#FlatFileLines (LineData, DetailLineID)
		SELECT	('13' +  + @CustomerPO   ),2
		
		
				
				declare PackType cursor local for
				select			CustomerPart ,
												CustomerPO,
												PackageType ,
												PackQty,
												count(1)
				From
					@ShipperSerials
				where					
					customerpart = @CustomerPartLoop 
					and CustomerPO = @CustomerPOLoop
				group by
						CustomerPart ,
						CustomerPO,
						PackageType,
						PackQty
							
					open	PackType

					while	1 = 1 
					begin
					fetch	PackType	into
					@CustomerPartLoop,
					@CustomerPOLoop,
					@PackTypeLoop,
					@PackQtyLoop,
					@ContainerCount			
					
					if	@@FETCH_STATUS != 0 begin
					break
					end

					Select @PackageType = @PackTypeLoop
					Select @PackQty =  @PackQtyLoop
									
					INSERT	#FlatFileLines (LineData, DetailLineID)
					SELECT	('17'+ @ContainerCount +   @PackQty +  @PackageType ), 2
					
					
					
									declare PackSerial cursor local for
									select	
										Serial
									From
										@ShipperSerials
									where					
										CustomerPart = @CustomerPartLoop and
										CustomerPO = @CustomerPOLoop and
										PackageType = @PackTypeLoop and
										PackQty = @PackQtyLoop
									
									open	PackSerial
									while	1 = 1 
									begin
									fetch	PackSerial	into
									@SerialNumber
					
									if	@@FETCH_STATUS != 0 begin
									break
									end
									
									INSERT	#FlatFileLines (LineData,  DetailLineID)
									SELECT	('18'+ @SerialQualifier +  @SerialNumber   ), 2
					
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
