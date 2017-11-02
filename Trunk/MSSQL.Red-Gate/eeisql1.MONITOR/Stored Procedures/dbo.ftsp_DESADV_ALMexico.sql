SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[ftsp_DESADV_ALMexico] (@shipper INT)
AS
BEGIN


   /* 
    



    FlatFile Layout for Overlay: GH7_DESADV_D_Dr97A_GMCH_131209     08-10-14 15:47

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

       DOCUMENT/MESSAGE #                                   AN   003   017    1BGM020

       DESADV DATE                                          AN   020   035    1DTM010

       FILLER('                          ')                 AN   055   026           

       Record Length:                                                  080           

    Record '02'                                             02   001   002           

       SHIPPED DATE                                         AN   003   035    2DTM010

       FI...('                                           ') AN   038   043           

       Record Length:                                                  080           

    Record '03' (3 x - End Record '03')                     03   001   002           

       PROPERTY MEASURED, CODED                             AN   003   003    1MEA020

       MEASURE UNIT TYPE                                    AN   006   003    1MEA030

       MEASUREMENT VALUE                                    AN   009   018    1MEA030

       ('                                               ... AN   027   054           

       Record Length:                                                  080           

    Record '04'                                             04   001   002           

       MASTER BOL / SHIPPER                                 AN   003   017    1RFF010

       ('                                               ... AN   020   061           

       Record Length:                                                  080           

                                          1
    Description                                            Type Start Length Element 

    Record '05'                                             05   001   002           

       DOCUMENT DATE                                        AN   003   035    3DTM010

       SUPPLIER ID                                          AN   038   035    3NAD020

       FILLER('        ')                                   AN   073   008           

       Record Length:                                                  080           

    Record '06'                                             06   001   002           

       PARTY NAME                                           AN   003   035    3NAD040

       BUYER ID                                             AN   038   035    4NAD020

       FILLER('        ')                                   AN   073   008           

       Record Length:                                                  080           

    Record '07'                                             07   001   002           

       PARTY NAME                                           AN   003   035    4NAD040

       SHIP TO ID                                           AN   038   035    1NAD020

       FILLER('        ')                                   AN   073   008           

       Record Length:                                                  080           

    Record '08'                                             08   001   002           

       PARTY NAME                                           AN   003   035    1NAD040

       PLACE/LOCATION ID                                    AN   038   025    1LOC020

       FILLER('                  ')                         AN   063   018           

       Record Length:                                                  080           

    Loop Start (10 x - End Record '09')                                              

       Record '09'                                          09   001   002           

          MODE OF TRANSPORT, CODED                          AN   003   003    1TDT030

          CARRIER ID                                        AN   006   017    1TDT050

          ('                                            ... AN   023   058           

          Record Length:                                               080           

    Loop Start (10 x - End Record '10')                                              

       Record '10'                                          10   001   002           

          EQUIPMENT ID #                                    AN   003   017    1EQD020

          ('                                            ... AN   020   061           

          Record Length:                                               080           

    Loop Start (499 x - End Record '18')                                             

       Record '11'                                          11   001   002           

          HIERARCHICAL ID. #                                AN   003   012    1CPS01 

                                          2
    Description                                            Type Start Length Element 

          PACKAGING LEVEL, CODED                            AN   015   003    1CPS03 

          ('                                            ... AN   018   063           

          Record Length:                                               080           

       Loop Start                                                                    

          Record '12'                                       12   001   002           

             NUMBER OF PACKAGES                             R    003   010    1PAC01 

             TYPE OF PACKAGES ID                            AN   013   017    1PAC030

             ('                                         ... AN   030   051           

             Record Length:                                            080           

          Loop Start (1000 x - End Record '14')                                      

             Record '13'                                    13   001   002           

                MAX SERIAL FOR PART                         AN   003   035    2RFF010

                SHIPPING MARKS                              AN   038   035    1PCI020

                FILLER('        ')                          AN   073   008           

                Record Length:                                         080           

             Record '14' (99 x - End Record '14')           14   001   002           

                ID #                                        AN   003   035    1GIR030

                OBJECT SERIAL                               AN   038   035    1GIR020

                FILLER('        ')                          AN   073   008           

                Record Length:                                         080           

       Loop Start (499 x - End Record '18')                                          

          Record '15'                                       15   001   002           

             ITEM #                                         AN   003   035    1LIN030

             MAX SERIAL FOR PART                            AN   038   035    1PIA020

             FILLER('        ')                             AN   073   008           

             Record Length:                                            080           

          Record '16' (25 x - End Record '16')              16   001   002           

             ITEM DESCRIPTION                               AN   003   035    1IMD030

             ITEM DESCRIPTION                               AN   038   035    1IMD030

             FILLER('        ')                             AN   073   008           

             Record Length:                                            080           

          Record '17' (2 x - End Record '17')               17   001   002           

             QUANTITY                                       R    003   014    2QTY010

             ('                                         ... AN   017   064           

                                          3
    Description                                            Type Start Length Element 

             Record Length:                                            080           

          Record '18'                                       18   001   002           

             PO NUMBER                                      AN   003   010    3RFF010

             PO LINE NUMBER                                 AN   013   005    3RFF010

             ('                                         ... AN   018   063           

             Record Length:                                            080           




















































                                          4

*/



--[dbo].[ftsp_DESADV_ALMexico] 79968
 
 
SET ANSI_PADDING ON
--ASN Header

DECLARE
	@TradingPartnerCode	CHAR(12),
	@ShipperID CHAR(17),
	@MessageID CHAR(35),
	@PartialComplete CHAR(1),
	@DocumentType CHAR(10),
	@DocumentType2 CHAR(6),
	@ASNOverlayGroup CHAR(3),
	@MessageFunction CHAR(3),
	@ASNDate CHAR(35),
	@ASNTime char(8),
	@ShippedDate CHAR(35),
	@ShippedTime char(8),
	@DTMQualifier_10 CHAR(3),
	@DTMQualifier_97 CHAR(3),
	@MEAQualifier_GrossWeight CHAR(3) = 'G',
	@MEAQualifier_NETWeight CHAR(3) = 'N',
	@MEAQualifier_LadingQty CHAR(3) = 'SQ',
	@MEAQualifier_WT CHAR(3),
	@MEAQualifier_AAW CHAR(3),
	@MEAUM_KGM CHAR(3) = 'KGM',
	@MEAUM_PCE CHAR(3) = 'PCE',
	@GrossWeightKG CHAR(18),
	@NetWeightKG CHAR(18),
	@Lifts CHAR(18),
	@RFFShipperType CHAR(3) = 'AAS',
	@ShipperDoc CHAR(35) = @shipper,
	@DocumentDate CHAR(35),
	@REF01_BM CHAR(3),
	@BOL CHAR(17),	
	@SupplierCode CHAR(35),
	@SupplierName CHAR(35),
	@BuyerCode CHAR(35),
	@BuyerName CHAR(35),
	@ShipToCode CHAR(35),
	@ShipToName CHAR(35),
	@ShipToDock CHAR(25),
	@TruckNumber CHAR(17),
	@TransModeCoded CHAR(3) = 'M',
	@SCAC CHAR(17),
	@ShipFromQualifier CHAR(3) 
 
 SELECT
	@TradingPartnerCode	= COALESCE(edi_setups.trading_partner_code,'ALC'),
	@ShipperID = ISNULL(shipper.id,0),
	@MessageID = ISNULL(shipper.id,0),
	@BOL = coalesce(shipper.bill_of_lading_number, shipper.id),
	@PartialComplete = '',
	@DocumentType = 'DESADV',
	@DocumentType2 = 'DESADV',
	@ASNOverlayGroup = '',
	@MessageFunction = '9',
	@ASNDate = CONVERT(VARCHAR(25), GETDATE(), 112), /*+LEFT(CONVERT(VARCHAR(25), GETDATE(), 108),2) +SUBSTRING(CONVERT(VARCHAR(25), GETDATE(), 108),4,2))*/
--	@ASNTime = convert( char(80), [MONITOR].[FT].[fn_DateTimeToString] ( getdate(),'hh') + [MONITOR].[FT].[fn_DateTimeToString] (getdate(),'nn')),
	@ShippedDate = CONVERT(VARCHAR(25), shipper.date_shipped, 112) +LEFT(CONVERT(VARCHAR(25), shipper.date_shipped, 108),2) +SUBSTRING(CONVERT(VARCHAR(25), shipper.date_shipped, 108),4,2),
	@DocumentDate = CONVERT(VARCHAR(25), shipper.date_shipped, 112),
--	@ShippedTime = convert( char(80), [MONITOR].[FT].[fn_DateTimeToString] ( shipper.date_shipped,'hh') + [MONITOR].[FT].[fn_DateTimeToString] (shipper.date_shipped,'nn')),
	@GrossWeightKG = CONVERT(INT, CEILING(ISNULL(NULLIF(shipper.gross_weight,0),100) * .45359237)),
	@NetWeightKG = CONVERT(INT, CEILING(ISNULL(NULLIF(shipper.net_weight,0),100) * .45359237)),
	@Lifts = convert(int, shipper.staged_objs),
	@SupplierCode = coalesce(edi_setups.supplier_code,'0000002203'),
	@SupplierName = p.company_name,
	@ShipToCode = coalesce(edi_setups.parent_destination, 'UP01'),
	@ShipToName = destination.name,
	@ShipToDock = coalesce(shipper.shipping_dock,''),
	@BuyerCode = coalesce(edi_setups.parent_destination, 'UP01'),
	@BuyerName = destination.name,		
	@SCAC = isnull(shipper.ship_via,''),
	@TruckNumber = isnull(nullif(shipper.truck_number,''),convert(varchar(25), shipper.id))

from	
	shipper
	join edi_setups on dbo.shipper.destination = dbo.edi_setups.destination
	join destination on edi_setups.destination = destination.destination 
	left outer join bill_of_lading on shipper.bill_of_lading_number = bill_of_lading.bol_number 
	left outer join carrier on shipper.bol_carrier = carrier.scac
	cross join parameters p 
where
	shipper.id = @shipper
	
create	table	
	#ASNHeaderFlatFileLines (
	LineId	int identity (1,1),
	LineData char(80)
	)

--insert	#ASNHeaderFlatFileLines (LineData)
--select	('//STX12//X12' +  @TradingPartnerCode + @ShipperID + @PartialComplete + @DocumentType + @DocumentType2 + @ASNOverlayGroup)
	
insert	#ASNHeaderFlatFileLines (LineData)
select	('01' + @ShipperID + @ASNDate )

insert	#ASNHeaderFlatFileLines (LineData)
select	('02' +  @ShippedDate)

INSERT	#ASNHeaderFlatFileLines (LineData)
SELECT	('03' +  @MEAQualifier_GrossWeight + @MEAUM_KGM + @GrossWeightKG)

INSERT	#ASNHeaderFlatFileLines (LineData)
SELECT	('03' + @MEAQualifier_NetWeight + @MEAUM_KGM + @NetWeightKG)
	
INSERT	#ASNHeaderFlatFileLines (LineData)
SELECT	('03' + @MEAQualifier_LadingQty + @MEAUM_PCE + @Lifts)
	
INSERT	#ASNHeaderFlatFileLines (LineData)
SELECT	('04'  + @BOL )
	
INSERT	#ASNHeaderFlatFileLines (LineData)
SELECT	('05' + @DocumentDate + @SupplierCode)

INSERT	#ASNHeaderFlatFileLines (LineData)
SELECT	('06' + @Suppliername + @BuyerCode  )
	
INSERT	#ASNHeaderFlatFileLines (LineData)
SELECT	('07' + @Buyername + @ShipToCode )

INSERT	#ASNHeaderFlatFileLines (LineData)
SELECT	('08' + @ShipToName + @ShipToDock)
	
INSERT	#ASNHeaderFlatFileLines (LineData)
SELECT	('09' + @TransModeCoded + @SCAC)
	
INSERT	#ASNHeaderFlatFileLines (LineData)
SELECT	('10' + @TruckNumber)
	
--ASN Detail
DECLARE @ShipperDetail TABLE
(
	ShipperLine INT IDENTITY(1,1),
	CustomerPart VARCHAR(35),
	PartName VARCHAR(35),
	CustomerPO VARCHAR(35),
	CustomerPOLine VARCHAR(35),
	PackageType VARCHAR(35),
	PackageCount INT,
	QtyShipped INT,
	MasterSerial INT

)

INSERT @ShipperDetail
(
	CustomerPart,
	PartName,
	CustomerPO,
	CustomerPOLine,
	PackageType,
	PackageCount,
	QtyShipped,
	MasterSerial
)
SELECT	

	CustomerPart = COALESCE(sd.customer_part,''),
	PartName = LEFT(sd.part_name,35),
	CustomerPO = CASE WHEN sd.customer_po LIKE '%[:]%' THEN SUBSTRING(sd.customer_po, 1, PATINDEX('%:%', sd.customer_po)-1) ELSE sd.customer_po END ,
	CustomerPOLine = CASE WHEN sd.customer_po LIKE '%[:]%' THEN SUBSTRING(sd.customer_po,  PATINDEX('%:%', sd.customer_po)+1, 35) ELSE sd.customer_po END ,
	PackageType = '0000',
	PackageCount  = COUNT(1),
	QtyShipped = CONVERT(INT, SUM(sd.alternative_qty)),
	MasterSerial =  MAX(Serial)
FROM
	shipper_detail sd
JOIN
	audit_trail at ON at.part = sd.part_original AND
	at.shipper = CONVERT(VARCHAR(35),sd.shipper)
WHERE
	sd.shipper = @shipper
GROUP BY
	COALESCE(sd.customer_part,''),
	LEFT(sd.part_name,35),
	CASE WHEN sd.customer_po LIKE '%[:]%' THEN SUBSTRING(sd.customer_po, 1, PATINDEX('%:%', sd.customer_po)-1) ELSE sd.customer_po END ,
	CASE WHEN sd.customer_po LIKE '%[:]%' THEN SUBSTRING(sd.customer_po,  PATINDEX('%:%', sd.customer_po)+1, 35) ELSE sd.customer_po END 

DECLARE @ShipperSerials TABLE
(
	CustomerPart VARCHAR(35),
	Serial INT

)

INSERT @ShipperSerials
        ( CustomerPart, Serial )


SELECT	

	CustomerPart = COALESCE(sd.customer_part,''),
	Serial =  Serial
FROM
	shipper_detail sd
JOIN
	audit_trail at ON at.part = sd.part_original AND
	at.shipper = CONVERT(VARCHAR(35),sd.shipper)
WHERE
	sd.shipper = @shipper
	
	
--Delcare Variables for ASN Details	
DECLARE
	@ShipperLine CHAR(12),
	@LoopCustomerPart VARCHAR(35),	
	@CustomerPart CHAR(35),	
	@PartName CHAR(35),
	@CustomerPO CHAR(10),
	@CustomerPOLine CHAR(5),
	@PackageType CHAR(17),
	@PackageCount CHAR(10),
	@REFType CHAR(2) = 'AAT',
	@REF CHAR(35),
	@QtyShipped CHAR(14),
	@Serial CHAR(35),
	@SerialType CHAR(3) = 'ML',
	@BatchNumber CHAR(35),
	@BatchNumberType CHAR(3) = 'BX'
 
DECLARE
	Parts CURSOR LOCAL FOR
SELECT
	ShipperLine,
	Customerpart,
	PartName,
	CustomerPart,
	CustomerPO,
	CustomerPOLine,
	PackageType,
	PackageCount,
	QtyShipped,
	MasterSerial

FROM	
	@ShipperDetail
ORDER BY
	shipperLine
	

OPEN
	Parts

WHILE
	1 = 1 BEGIN
	
	FETCH
		Parts
	INTO
	@ShipperLine,
    @LoopCustomerPart,
	@PartName,
	@CustomerPart,
	@CustomerPO,
	@CustomerPOLine,
	@PackageType,
	@PackageCount,
	@QtyShipped,
	@REF

			
	IF	@@FETCH_STATUS != 0 BEGIN
		BREAK
	END			
				INSERT	#ASNHeaderFlatFileLines (LineData)
				SELECT	('11' + @ShipperLine + '1  ' )

				INSERT	#ASNHeaderFlatFileLines (LineData)
				SELECT	('12' + @PackageCount + @PackageType )
	
				INSERT	#ASNHeaderFlatFileLines (LineData)
				SELECT	('13' +  @REF)
    
				DECLARE
					Serials CURSOR LOCAL FOR
				SELECT
				Serial

				FROM	
				@ShipperSerials

				WHERE
					CustomerPart = @LoopCustomerPart
	

				OPEN
				Serials

				WHILE
				1 = 1 BEGIN
	
				FETCH
				Serials
				INTO
				@Serial

			
				IF	@@FETCH_STATUS != 0 BEGIN
				BREAK
				END
	
				INSERT	#ASNHeaderFlatFileLines (LineData)
				SELECT	('14' + @Serial + @Serial)
	
				END	
	
				CLOSE Serials
				DEALLOCATE Serials
	
		INSERT	#ASNHeaderFlatFileLines (LineData)
		SELECT	('15' + @CustomerPart  )

		INSERT	#ASNHeaderFlatFileLines (LineData)
		SELECT	('16' + @PartName  )
	
		INSERT	#ASNHeaderFlatFileLines (LineData)
		SELECT	('17' + @QtyShipped )

		INSERT	#ASNHeaderFlatFileLines (LineData)
		SELECT	('18' + @CustomerPO + @CustomerPOLine)
		
END	
	
CLOSE parts
DEALLOCATE parts
 
 
SELECT		
	CONVERT(CHAR(80),LineData)
FROM		
	#ASNHeaderFlatFileLines
ORDER BY	
	LineID
	

SET ANSI_PADDING OFF
END







GO
