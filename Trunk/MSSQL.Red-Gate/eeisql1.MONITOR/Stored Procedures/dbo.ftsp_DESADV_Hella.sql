SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[ftsp_DESADV_Hella] (@shipper INT)
AS
BEGIN


   /*     


    
    FlatFile Layout for Overlay: HE9_DESADV_D_D.08A_HELLA^FTVersion_140926     10-31-

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

       DOCUMENT NAME CODE                                   AN   003   003    1BGM010

       DESPATCH ADVICE NO.                                  AN   006   035    1BGM020

       FILLER('                                        ')   AN   041   040           

       Record Length:                                                  080           

    Record '02' (10 x - End Record '02')                    02   001   002           

       DATE/TIME TYPE                                       AN   003   003    1DTM010

       DATE/TIME/PERIOD                                     AN   006   012    1DTM010

       ('                                               ... AN   018   063           

       Record Length:                                                  080           

    Record '03' (10 x - End Record '03')                    03   001   002           

       TRANSPORT NO.                                        AN   003   035    1RFF010

       FI...('                                           ') AN   038   043           

       Record Length:                                                  080           

    Loop Start (99 x - End Record '05')                                              

       Record '04'                                          04   001   002           

          NAME TYPE                                         AN   003   003    1NAD01 

          PARTY ID.                                         AN   006   035    1NAD020

          PARTY ID TYPE                                     AN   041   003    1NAD020

                                          1
    Description                                            Type Start Length Element 

          PARTY NAME                                        AN   044   035    1NAD040

          FILLER('  ')                                      AN   079   002           

          Record Length:                                               080           

       Record '05'                                          05   001   002           

          FINAL DELIVERY POINT                              AN   003   035    3LOC020

          ..('                                           ') AN   038   043           

          Record Length:                                               080           

    Record '06'                                             06   001   002           

       MODE OF TRANSPORT CODE                               AN   003   003    1TDT030

       EQUIPMENT TYPE                                       AN   006   003    1EQD01 

       EQUIPMENT ID NO.                                     AN   009   017    1EQD020

       ('                                               ... AN   026   055           

       Record Length:                                                  080           

    Loop Start (99 x - End Record '14')                                              

       Record '07'                                          07   001   002           

          CURRENT-HL                                        AN   003   035    1CPS01 

          PACKAGING LEVEL CODE                              AN   038   003    1CPS03 

          FI...('                                        ') AN   041   040           

          Record Length:                                               080           

       Loop Start                                                                    

          Record '08'                                       08   001   002           

             NO. OF PACKAGES                                R    003   010    2PAC01 

             PACKAGING RELATED DESCRIPTION CODE             AN   013   003    2PAC020

             HELLA PACKAGE TYPE                             AN   016   017    2PAC030

             ('                                         ... AN   033   048           

             Record Length:                                            080           

          Loop Start (3 x - End Record '14')                                         

             Record '09'                                    09   001   002           

                17                                          AN   003   003    2PCI01 

                TYPE OF MARKING (M)                         AN   006   003    2PCI040

                ('                                      ... AN   009   072           

                Record Length:                                         080           

             Loop Start (99 x - End Record '14')                                     

                Record '10'                                 10   001   002           

                                          2
    Description                                            Type Start Length Element 

                   IDENTITY NO.                             AN   003   035    2GIN020

                   IDENTITY NO.                             AN   038   035    2GIN020

                   FILLER('        ')                       AN   073   008           

                   Record Length:                                      080           

                Record '11'                                 11   001   002           

                   IDENTITY NO.                             AN   003   035    2GIN030

                   IDENTITY NUMBER                          AN   038   035    2GIN030

                   FILLER('        ')                       AN   073   008           

                   Record Length:                                      080           

                Record '12'                                 12   001   002           

                   IDENTITY NO.                             AN   003   035    2GIN040

                   IDENTITY NUMBER                          AN   038   035    2GIN040

                   FILLER('        ')                       AN   073   008           

                   Record Length:                                      080           

                Record '13'                                 13   001   002           

                   IDENTITY NO.                             AN   003   035    2GIN050

                   IDENTITY NUMBER                          AN   038   035    2GIN050

                   FILLER('        ')                       AN   073   008           

                   Record Length:                                      080           

                Record '14'                                 14   001   002           

                   IDENTITY NO.                             AN   003   035    2GIN060

                   IDENTITY NUMBER                          AN   038   035    2GIN060

                   FILLER('        ')                       AN   073   008           

                   Record Length:                                      080           

    Loop Start (9999 x - End Record '36')                                            

       Record '15'                                          15   001   002           

          CURRENT-HL                                        AN   003   012    2CPS01 

          PACKAGING LEVEL CODE                              AN   015   003    2CPS03 

          ('                                            ... AN   018   063           

          Record Length:                                               080           

       Loop Start                                                                    

          Record '16'                                       16   001   002           

             NO. OF PACKAGES                                R    003   010    1PAC01 

             PACKAGING RELATED DESCRIPTION CODE             AN   013   003    1PAC020

                                          3
    Description                                            Type Start Length Element 

             HELLA PACKAGE TYPE                             AN   016   017    1PAC030

             ('                                         ... AN   033   048           

             Record Length:                                            080           

          Record '17' (10 x - End Record '17')              17   001   002           

             QUANTITY                                       R    003   037    1QTY010

             MEASURE UNIT CODE                              AN   040   008    1QTY010

             FILLER('                                 ')    AN   048   033           

             Record Length:                                            080           

          Loop Start (3 x - End Record '24')                                         

             Record '18'                                    18   001   002           

                17                                          AN   003   003    1PCI01 

                TYPE OF MARKING                             AN   006   003    1PCI040

                ('                                      ... AN   009   072           

                Record Length:                                         080           

             Record '19' (1000 x - End Record '19')         19   001   002           

                OUTER PACK UNIT ID                          AN   003   070    2RFF010

                FILLER('        ')                          AN   073   008           

                Record Length:                                         080           

             Loop Start (99 x - End Record '24')                                     

                Record '20'                                 20   001   002           

                   IDENTITY NO.                             AN   003   035    1GIN020

                   IDENTITY NO.                             AN   038   035    1GIN020

                   FILLER('        ')                       AN   073   008           

                   Record Length:                                      080           

                Record '21'                                 21   001   002           

                   IDENTITY NO.                             AN   003   035    1GIN030

                   IDENTITY NUMBER                          AN   038   035    1GIN030

                   FILLER('        ')                       AN   073   008           

                   Record Length:                                      080           

                Record '22'                                 22   001   002           

                   IDENTITY NO.                             AN   003   035    1GIN040

                   IDENTITY NUMBER                          AN   038   035    1GIN040

                   FILLER('        ')                       AN   073   008           

                   Record Length:                                      080           

                                          4
    Description                                            Type Start Length Element 

                Record '23'                                 23   001   002           

                   IDENTITY NO.                             AN   003   035    1GIN050

                   IDENTITY NUMBER                          AN   038   035    1GIN050

                   FILLER('        ')                       AN   073   008           

                   Record Length:                                      080           

                Record '24'                                 24   001   002           

                   IDENTITY NO.                             AN   003   035    1GIN060

                   IDENTITY NUMBER                          AN   038   035    1GIN060

                   FILLER('        ')                       AN   073   008           

                   Record Length:                                      080           

       Loop Start (9999 x - End Record '36')                                         

          Record '25'                                       25   001   002           

             BUYER'S ITEM NO.                               AN   003   035    1LIN030

             SUPPLIER/DRAWING REV NO.                       AN   038   035    1PIA020

             FILLER('        ')                             AN   073   008           

             Record Length:                                            080           

          Record '26'                                       26   001   002           

             DRAWING REVISION #                             AN   003   035    1PIA030

             ('                                         ... AN   038   043           

             Record Length:                                            080           

          Record '27' (25 x - End Record '27')              27   001   002           

             ITEM DESCRIPTION                               AN   003   035    1IMD030

             ('                                         ... AN   038   043           

             Record Length:                                            080           

          Record '28'                                       28   001   002           

             DESPATCH QUANTITY                              R    003   012    2QTY010

             MEASURE UNIT CODE                              AN   015   003    2QTY010

             COUNTRY OF ORIGIN                              AN   018   002    1ALI01 

             ('                                         ... AN   020   061           

             Record Length:                                            080           

          Loop Start (99 x - End Record '33')                                        

             Record '29'                                    29   001   002           

                FREE TEXT                                   AN   003   078    1FTX040

                Record Length:                                         080           

                                          5
    Description                                            Type Start Length Element 

             Record '30'                                    30   001   002           

                FREE TEXT                                   AN   003   078    1FTX040

                Record Length:                                         080           

             Record '31'                                    31   001   002           

                FREE TEXT                                   AN   003   078    1FTX040

                Record Length:                                         080           

             Record '32'                                    32   001   002           

                FREE TEXT                                   AN   003   078    1FTX040

                Record Length:                                         080           

             Record '33'                                    33   001   002           

                FREE TEXT                                   AN   003   078    1FTX040

                Record Length:                                         080           

          Loop Start                                                                 

             Record '34'                                    34   001   002           

                REFERENCE CODE TYPE                         AN   003   003    3RFF010

                REFERENCE ID                                AN   006   070    3RFF010

                FILLER('     ')                             AN   076   005           

                Record Length:                                         080           

             Record '35'                                    35   001   002           

                LINE NO.                                    AN   003   006    3RFF010

                REFERENCE DATE / TIME                       AN   009   014    2DTM010

                DATE OR TIME OR PERIOD FORMAT CODE          AN   023   003    2DTM010

                ('                                      ... AN   026   055           

                Record Length:                                         080           

          Record '36'                                       36   001   002           

             LOCATION NAME CODE                             AN   003   035    1LOC020

             ('                                         ... AN   038   043           

             Record Length:                                            080           



                                          6     



*/



--[dbo].[ftsp_DESADV_Hella] 79963
 
 
SET ANSI_PADDING ON
--ASN Header

DECLARE

--Header Line Variables
	@ReservedMandatory CHAR(9) = '//STX12//',
	@x12TransactionID CHAR(3) = '',
	@TradingPartnerCode	CHAR(12),
	@DocumentNumber CHAR(30) = @shipper,
	@PartialComplete CHAR(1) = '',
	@EDIFACTTransactionID CHAR(10)= 'DESADV',
	@DocumentClassCode CHAR(6) = '',
	@OverlayCode CHAR(3) = '',

--BGM
	@DocumentNameCode CHAR(3) = '351',
	@DespatchAdviceNo CHAR(35) = @shipper,

--DTM
	@DateQualifierDocumentDT CHAR(3) = '137',
	@DocumentDT CHAR(12),
	@DateQualifierShippedDT CHAR(3) = '11',
	@ShippedDT CHAR(12),
	@DateQualifierExpectedReceiptDT CHAR(3) = '132',
	@ExpectedReceiptDT CHAR(12),

--RFF
	@TransportNumber CHAR(35),

--NAD
	@NADTypeQualifierBuyer CHAR(3) = 'BY',
	@NADIDBuyer CHAR(35),
	@NADIDType91 CHAR(3) = '91',
	@NADTypeQualifierSeller CHAR(3) = 'SE',
	@NADIDSeller CHAR(35),
	@NADIDTypeSeller92 CHAR(3) = '92',
	@NADTypeQualifierShipTo CHAR(3) = 'ST',
	@NADIDShipTo CHAR(35),
	@NADIDTypeShipTo92 CHAR(3) = '92',

--LOC
	@LOCDock CHAR(35),

--TDT	
	@TransMode CHAR(3),

--EQD

	@EquipmentType CHAR(3) = 'TE',
	@EquipmentID CHAR(17), 

	
--------Detail Variables--------

--PAC (Pallet)
	@NoOfpallets CHAR(10),
	@PackagingDescriptionCodePallet CHAR(3) = '35',
	@PackageTypePallet CHAR(17),

--GIN (Pallet)
	@GINPalletSerial CHAR(35),


--PAC (Object)
	@NoOfObjects CHAR(10) ,
	@PackagingDescriptionCodeObject CHAR(3) = '35',
	@PackageTypeObject CHAR(17),

--QTY (Object PackQty)
	@ObjectQtyPerpack CHAR(37),
	@ObjectQtyUM CHAR(8) = 'PCE',
	

--PCI
	@PCIIDTypeS CHAR(3) = 'S',
	@PCIIDTypeM CHAR(3) = 'M',
	@PCIID17 CHAR(3) = '17',

--RFF (Object Parent Serial)
	@RFFObjectParentSerial CHAR(70),

--GIN (Object)
	@GINObjectSerial0 CHAR(35),
	@GINObjectSerial1 CHAR(35),
	@GINObjectSerial2 CHAR(35),
	@GINObjectSerial3 CHAR(35),
	@GINObjectSerial4 CHAR(35),
	@GINObjectSerial5 CHAR(35),
	@GINObjectSerial6 CHAR(35),
	@GINObjectSerial7 CHAR(35),
	@GINObjectSerial8 CHAR(35),
	@GINObjectSerial9 CHAR(35),

--LIN
	@LINCustomerpart CHAR(35),
	
--PIA	
	@SupplierPart CHAR(35),
	@EngineeringRev CHAR(35),

--IMD
	@PartDescription CHAR(35),

--QTY
	@PartQty CHAR(12),
	@PartUM CHAR(3) = 'C62',

--ALI
	@CountryOfOrigin CHAR(2) = 'HN',

--RFF
	@RFFPONumberType CHAR(3) = 'ON',
	@RFFPONumber CHAR(70),
	@RFFPOLineNumber CHAR(6),

--DTM
	@DTMDateShipped CHAR(14),
	@DTMDateShippedType CHAR(3) = '203',

--LOC
	@LineFeedCode CHAR(35),

--CPS
	@CPS1 INT = 0,
	@CPS2 INT = 0,
	@CPS1CHAR CHAR(35),
	@CPS2CHAR CHAR(12),
	@CPS1Type CHAR(3) = '3', --Outer = 3, None = 4
	@CPS2Type CHAR(3) ='1' -- 1 = Inner

SELECT
	@TradingPartnerCode	= COALESCE(NULLIF(edi_setups.trading_partner_code,''),'HellaMexico'),
	@DespatchAdviceNo = ISNULL(shipper.id,0),
	
	@DocumentDT = CONVERT(VARCHAR(25), GETDATE(), 112) + LEFT(CONVERT(VARCHAR(25), GETDATE(), 108),2) +SUBSTRING(CONVERT(VARCHAR(25), GETDATE(), 108),4,2),
	@ShippedDT = CONVERT(VARCHAR(25), shipper.date_shipped, 112) +LEFT(CONVERT(VARCHAR(25), shipper.date_shipped, 108),2) +SUBSTRING(CONVERT(VARCHAR(25), shipper.date_shipped, 108),4,2),
	@DTMDateShipped = CONVERT(VARCHAR(25), shipper.date_shipped, 112) +LEFT(CONVERT(VARCHAR(25), shipper.date_shipped, 108),2) +SUBSTRING(CONVERT(VARCHAR(25), shipper.date_shipped, 108),4,2),
	@ExpectedReceiptDT = CONVERT(VARCHAR(25), DATEADD(dd,7, shipper.date_shipped), 112) +LEFT(CONVERT(VARCHAR(25), shipper.date_shipped, 108),2) +SUBSTRING(CONVERT(VARCHAR(25), shipper.date_shipped, 108),4,2),

	@TransportNumber = COALESCE(NULLIF(shipper.pro_number,''),shipper.truck_number, CONVERT(VARCHAR(25), shipper.id)),

	@NADIDBuyer = COALESCE(edi_setups.parent_destination, edi_setups.destination),
	@NADIDSeller = COALESCE(NULLIF(edi_setups.supplier_code,''), '0043712581'),
	@NADIDShipTo = COALESCE(NULLIF(edi_setups.EDIShipToID,''), '3272'),

	@LOCDock =  COALESCE(shipper.shipping_dock, ''),

	@TransMode = CASE WHEN shipper.trans_mode LIKE '%A%' THEN '40' ELSE '10' END,

	@EquipmentType = 'TE',
	@EquipmentID = COALESCE(Shipper.truck_number,CONVERT(VARCHAR(25), shipper.id))


FROM	
	shipper
	JOIN edi_setups ON dbo.shipper.destination = dbo.edi_setups.destination
	JOIN destination ON edi_setups.destination = destination.destination 
	LEFT OUTER JOIN bill_of_lading ON shipper.bill_of_lading_number = bill_of_lading.bol_number 
	LEFT OUTER JOIN carrier ON shipper.bol_carrier = carrier.scac
	CROSS JOIN parameters p 
WHERE
	shipper.id = @shipper
	
CREATE	TABLE	
	#ASNHeaderFlatFileLines (
	LineId	INT IDENTITY (1,1),
	LineData CHAR(80)
	)


--Get List of pallets and pallet package types for this shipper id.

DECLARE @PalletsShipped TABLE
(	PalletPackageTypeCount INT,
	PalletPackageType CHAR(17) PRIMARY KEY (PalletPackageType)
)


INSERT @PalletsShipped
        ( PalletPackageTypeCount, PalletPackageType )

Select	Count(1),
		coalesce(nullif(package_type,''), 'AAA.AAA-A')
From
	audit_trail
Where
	part = 'PALLET'
and
	shipper = Convert(varchar(30),@Shipper) and
	type = 'S'
GROUP BY
			coalesce(nullif(package_type,''), 'AAA.AAA-A')


DECLARE @PalletSerialsShipped TABLE
(	PalletSerial INT,
	PalletPackageType CHAR(17) PRIMARY KEY (PalletSerial)
)


INSERT @PalletSerialsShipped
        ( PalletSerial, PalletPackageType )

Select	serial,
		coalesce(nullif(package_type,''), 'AAA.AAA-A')
From
	audit_trail
Where
	part = 'PALLET'
and
	shipper = CONVERT(VARCHAR(30), @Shipper ) AND
	type = 'S'



--Get all Serials Shipped
DECLARE @ObjectsShipped TABLE
(	ObjectSerial INT,
	ObjectParentSerial INT,
	ObjectPackageType char(17),
	ObjectCustomerpart char(35),
	ObjectQuantity CHAR(37)
	 PRIMARY KEY (ObjectSerial)
)


INSERT @ObjectsShipped
        ( ObjectSerial ,
          ObjectParentSerial ,
		  ObjectPackageType ,
          ObjectCustomerpart ,
          ObjectQuantity
        )


Select	serial,
		COALESCE(PalletSerial,0),
		coalesce(nullif(package_type,''), 'BBB.BBB-B'),
		customer_part,
		CONVERT(INT,quantity)
From
	audit_trail
LEFT JOIN
	@PalletSerialsShipped PSS ON pss.PalletSerial = audit_trail.parent_serial
JOIN
	shipper_detail ON shipper_detail.part_original = audit_trail.part AND
	shipper_detail.shipper = @Shipper
Where
	audit_trail.part != 'PALLET'
and
	audit_trail.shipper = CONVERT(VARCHAR(25),@Shipper) and
	audit_trail.type = 'S'

DECLARE @PartPackTypeQuantityGroup TABLE
(	ObjectCustomerPart CHAR(35),
	ObjectPackageType CHAR(17),
	Quantity INT,
	GroupCount INT
	 PRIMARY KEY (ObjectCustomerPart, ObjectPackageType, Quantity)
)

INSERT @PartPackTypeQuantityGroup
        ( ObjectCustomerPart ,
          ObjectPackageType ,
          Quantity ,
          GroupCount
        )

SELECT  ObjectCustomerpart,
		ObjectPackageType,
		ObjectQuantity,
		COUNT(1)
FROM 
	@ObjectsShipped
GROUP BY
	ObjectCustomerpart,
	ObjectPackageType,
	ObjectQuantity

DECLARE @PartLineItems TABLE
(	CustomerPart CHAR(35),
	Part VARCHAR(35),
	CustomerPO VARCHAR(30),
	CustomerPOLine VARCHAR(30),
	PartDescription VARCHAR(100),
	EngineeringLevel VARCHAR(50),
	LineFeedCode VARCHAR(30),
	DateShipped VARCHAR(30),
	Quantity INT

	 PRIMARY KEY (CustomerPart)
)

INSERT
	@PartLineItems
	        ( CustomerPart ,
			  Part,
	          CustomerPO ,
	          CustomerPOLine ,
	          PartDescription ,
	          EngineeringLevel ,
	          LineFeedCode ,
	          DateShipped ,
	          Quantity
	        )
SELECT 
	sd.customer_part,
	MAX(LEFT(sd.part_original,7)),
	MAX(LEFT(sd.customer_po,10)),
	MAX(RIGHT(sd.Customer_po,4)),
	MAX(sd.part_name),
	MAX(COALESCE(oh.engineering_level,'A')),
	MAX(COALESCE(oh.line_feed_code,'')),
	MAX(CONVERT(VARCHAR(30), sd.date_shipped, 112)),
	SUM(qty_packed)
FROM	
	Shipper_Detail sd
LEFT JOIN
	order_header oh ON oh.order_no = sd.order_no
WHERE
	sd.shipper =  @Shipper
GROUP BY
	sd.customer_part


--SELECT * FROM @PalletSerialsShipped


--insert	#ASNHeaderFlatFileLines (LineData)
--select	(@ReservedMandatory + @x12TransactionID +  @TradingPartnerCode + @DocumentNumber + @PartialComplete + @EDIFACTTransactionID + @DocumentClassCode + @OverlayCode)
	
insert	#ASNHeaderFlatFileLines (LineData)
select	('01' + @DocumentNameCode +  @DespatchAdviceNo  )

insert	#ASNHeaderFlatFileLines (LineData)
select	('02' +  @DateQualifierDocumentDT + @DocumentDT)

insert	#ASNHeaderFlatFileLines (LineData)
select	('02' +  @DateQualifierShippedDT + @ShippedDT)

insert	#ASNHeaderFlatFileLines (LineData)
select	('02' +  @DateQualifierExpectedReceiptDT + @ExpectedReceiptDT)	

insert	#ASNHeaderFlatFileLines (LineData)
select	('03' +  @TransportNumber)	

insert	#ASNHeaderFlatFileLines (LineData)
select	('04' +  @NADTypeQualifierBuyer + @NADIDBuyer + @NADIDType91)

insert	#ASNHeaderFlatFileLines (LineData)
select	('04' +  @NADTypeQualifierSeller + @NADIDSeller + @NADIDTypeSeller92)	

insert	#ASNHeaderFlatFileLines (LineData)
select	('04' +  @NADTypeQualifierShipTo + @NADIDShipTo + @NADIDTypeShipTo92)				
	
INSERT	#ASNHeaderFlatFileLines (LineData)
SELECT	('05' + @LocDock)

INSERT	#ASNHeaderFlatFileLines (LineData)
SELECT	('06' + @TransMode + @EquipmentType + @EquipmentID)


--Get all pallets for Shipment
DECLARE
	Pallets CURSOR LOCAL FOR
SELECT
	 PalletPackageTypeCount ,
	 PalletPackageType
FROM	
	@PalletsShipped
ORDER BY
	2

OPEN
	Pallets

WHILE
	1 = 1 BEGIN
	
	FETCH
		Pallets
	INTO
	@NoOfpallets,
	@PackageTypePallet

			
	IF	@@FETCH_STATUS != 0 BEGIN
		BREAK
	END			
				Select @CPS1CHAR = @CPS1

				INSERT	#ASNHeaderFlatFileLines (LineData)
				SELECT	('07' + @CPS1CHAR + @CPS1Type )
				
				INSERT	#ASNHeaderFlatFileLines (LineData)
				SELECT	('08' + @NoOfPallets + @PackagingDescriptionCodePallet + @PackageTypePallet )

				INSERT	#ASNHeaderFlatFileLines (LineData)
				SELECT	('09' + @PCIID17 + @PCIIDTypeM )


					DECLARE
					PalletSerials CURSOR LOCAL FOR
					SELECT
						PalletSerial 

					FROM	
						@PalletSerialsShipped
					WHERE 
						PalletPackageType = @PackageTypePallet
					ORDER BY
					1
	

					OPEN
					PalletSerials

					WHILE
					1 = 1 BEGIN
	
					FETCH
					PalletSerials
					INTO
					@GINPalletSerial

			
					IF	@@FETCH_STATUS != 0 BEGIN
					BREAK
					END	

					

					INSERT	#ASNHeaderFlatFileLines (LineData)
					SELECT	('10' + @GINPalletSerial )


					END
					CLOSE PalletSerials
					DEALLOCATE PalletSerials



SELECT @CPS1 = @CPS1+1

END	
	
CLOSE Pallets
DEALLOCATE Pallets


DECLARE
	Parts CURSOR LOCAL FOR
SELECT
	 CustomerPart,
	 Part,
	 EngineeringLevel,
	 PartDescription,
	 Quantity,
	 CustomerPO,
	 CustomerPOLine,
	 LineFeedCode

FROM	
	@PartLineItems

SELECT @CPS2 = @CPS1+1
SELECT @CPS2CHAR = @CPS2
SELECT @CPS2TYPE = CASE WHEN (SELECT 1 FROM @PalletSerialsShipped ) IS NOT NULL THEN '1' ELSE '4' END

OPEN
	Parts

WHILE
	1 = 1 BEGIN
	
	FETCH
		Parts
	INTO
	@LINCustomerpart,
	@Supplierpart,
	@EngineeringRev,
	@PartDescription,
	@PartQty,
	@RFFPOnumber,
	@RFFPOLineNumber,
	@LineFeedCode


			
	IF	@@FETCH_STATUS != 0 BEGIN
		BREAK
	END		
	
					DECLARE
					PartPackTypes CURSOR LOCAL FOR
					SELECT
						 ObjectPackageType ,
						 Quantity ,
						 GroupCount

					FROM	
						@PartPackTypeQuantityGroup
					WHERE 
						ObjectCustomerPart = @LINCustomerPart
					ORDER BY
					1
	

					OPEN
					PartPackTypes

					WHILE
					1 = 1 BEGIN
	
					FETCH
					PartPackTypes
					INTO
					@PackageTypeObject,
					@ObjectQtyPerPack,
					@NoOfObjects


			
					IF	@@FETCH_STATUS != 0 BEGIN
					BREAK
					END	

					INSERT	#ASNHeaderFlatFileLines (LineData)
					SELECT	('15' + @CPS2CHAR + @CPS2TYPE  )

					INSERT	#ASNHeaderFlatFileLines (LineData)
					SELECT	('16' + @NoOfObjects + @PackagingDescriptionCodeObject + @PackageTypeObject  )

					INSERT	#ASNHeaderFlatFileLines (LineData)
					SELECT	('17' + @ObjectQtyPerpack + @ObjectQtyUM )

					
					INSERT	#ASNHeaderFlatFileLines (LineData)
					SELECT	('18' + @PCIID17 + @PCIIDTypeS )
					


							DECLARE
							PalletPartPackSerials CURSOR LOCAL FOR
							SELECT
								DISTINCT
								ObjectParentSerial 
								FROM	
								@ObjectsShipped
								WHERE
								ObjectPackageType = @PackageTypeObject and
								ObjectCustomerpart = @LINCustomerPart and
								ObjectQuantity = @ObjectQtyPerpack AND
								ObjectParentSerial >0
							
								ORDER BY
								1
	

								OPEN
								PalletPartPackSerials

								WHILE
								1 = 1 BEGIN
	
								FETCH
								PalletPartPackSerials
								INTO
								@RFFObjectparentSerial

			
								IF	@@FETCH_STATUS != 0 BEGIN
								BREAK
								END	

								INSERT	#ASNHeaderFlatFileLines (LineData)
								SELECT	('19' +'ACI'+  @RFFObjectparentSerial )


								END
								CLOSE PalletPartPackSerials
								DEALLOCATE PalletPartPackSerials



								DECLARE
							PartPackSerials CURSOR LOCAL FOR
							SELECT
								ObjectSerial
								
								FROM	
								@ObjectsShipped
								WHERE
								ObjectPackageType = @PackageTypeObject and
								ObjectCustomerpart = @LINCustomerPart and
								ObjectQuantity = @ObjectQtyPerpack
							
								ORDER BY
								1
	

								OPEN
								PartPackSerials

								WHILE
								1 = 1 BEGIN
	
								FETCH
								PartPackSerials
								INTO
								@GINObjectSerial0

			
								IF	@@FETCH_STATUS != 0 BEGIN
								BREAK
								END	

								INSERT	#ASNHeaderFlatFileLines (LineData)
								SELECT	('20' + @GINObjectSerial0 )


								END
								CLOSE PartPackSerials
								DEALLOCATE PartPackSerials











					END
					CLOSE PartPackTypes
					DEALLOCATE PartPackTypes		
		
		
		
		INSERT	#ASNHeaderFlatFileLines (LineData)
		SELECT	('25' + @LinCustomerpart + @SupplierPart  )

		INSERT	#ASNHeaderFlatFileLines (LineData)
		SELECT	('26' + @EngineeringRev  )

		INSERT	#ASNHeaderFlatFileLines (LineData)
		SELECT	('27' + @PartDescription  )
		
		INSERT	#ASNHeaderFlatFileLines (LineData)
		SELECT	('28' + @PartQty  + @PartUM + @CountryOFOrigin)

		INSERT	#ASNHeaderFlatFileLines (LineData)
		SELECT	('34' + @RFFPONumberType + @RFFPONumber)

		INSERT	#ASNHeaderFlatFileLines (LineData)
		SELECT	('35' + @RFFPOLineNumber )

		INSERT	#ASNHeaderFlatFileLines (LineData)
		SELECT	('36' + @LineFeedCode)

SELECT @CPS2 = @CPS2+1
SELECT @CPS2CHAR = @CPS2
END	
	
CLOSE Parts
DEALLOCATE Parts

--SELECT @CPS2CHAR AS CPS2CHAR
--SELECT @CPS2TYPE AS  CPS2TYPE
--SELECT @CPS1CHAR AS CPS1CHAR
--SELECT @CPS1TYPE AS  CPS1TYPE
--SELECT * FROM @ObjectsShipped
--SELECT * FROM @PalletsShipped
--SELECT * FROM @PartPackTypeQuantityGroup
--SELECT * FROM @PartLineItems
 --[dbo].[ftsp_DESADV_Hella] 79963
SELECT		
	CONVERT(CHAR(80),LineData)
FROM		
	#ASNHeaderFlatFileLines
ORDER BY	
	LineID
	

SET ANSI_PADDING OFF








END






GO
