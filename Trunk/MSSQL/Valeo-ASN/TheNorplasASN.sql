alter function EDI_XML_NORPLAS_ASN.udf_Root
(	@ShipperID INT
,	@Purpose CHAR(2)
,	@partialComplete INT
)
RETURNS XML
AS
BEGIN
--- <Body>
	declare
		@xmlOutput xml

	declare
		@ItemLoops int
	,	@TotalQuantity int

	select
		@ItemLoops = max(al.RowNumber)
	,	@TotalQuantity = sum(al.QtyPacked)
	from
		EDI_XML_NORPLAS_ASN.ASNLines al
	where
		al.ShipperID = @ShipperID
		
			DECLARE @ItemsPack		TABLE
			(		ShipperID Int,
					CustomerPart varchar(35),
					PackType varchar(25),
					PackCount int,
					RowNumber int,
					rowType varchar(1),
					RowID int IDENTITY(2,1)
			)
			INSERT @ItemsPack
			        ( ShipperID ,
			          CustomerPart ,
			          PackType ,
			          PackCount ,
			          RowNumber ,
			          rowType
			        )
		
		SELECT SHIPPERID,CustomerPart,PackType, PackCount ,rowNumber, 'p' from [EDI_XML_NORPLAS_ASN].[ASNLinePackQtyDetails] where ShipperID = @ShipperID 
		UNION  select SHIPPERID,CustomerPart,'', 0 ,0, 'i' from [EDI_XML_NORPLAS_ASN].[ASNLines] where ShipperID = @ShipperID order by 2,5

	SET
		@xmlOutput =
			(	SELECT
					(	SELECT
							EDI_XML.TRN_INFO('004010', '856', ah.TradingPartner, ah.IConnectID, ah.ShipperID, @PartialComplete)
						,	EDI_XML_V4010.SEG_BSN(@Purpose, ah.ShipperID, ah.ASNDate, ah.ASNTime)
						,	EDI_XML_V4010.SEG_DTM('011', ah.ShipDateTime, NULL)
						,	(	SELECT
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(1, NULL, 'S', NULL)
								,	EDI_XML_V4010.SEG_MEA('PD', 'G', ah.GrossWeight, 'LB')
								,	EDI_XML_V4010.SEG_MEA('PD', 'N', ah.NetWeight, 'LB')
								,	EDI_XML_V4010.SEG_TD1('CTN90', ah.PackCount)
								,	EDI_XML_V4010.SEG_TD5('B', '2', ah.Carrier, ah.TransMode, NULL, NULL)
								,	EDI_XML_V4010.SEG_TD3('TL', NULL, ah.TrailerNumber)
								,	EDI_XML_V4010.SEG_REF('BM', ah.REFBMValue)
								,	EDI_XML_V4010.SEG_REF('PK', ah.REFPKValue)
								,	(	SELECT
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_NORPLAS_ASN.SEG_N1('MI', '92', ah.MaterialIssuerCode, 'NORPLAS INDUSTRIES INC.')
						 				FOR XML RAW ('LOOP-N1'), TYPE
						 			)
								,	(	SELECT
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_NORPLAS_ASN.SEG_N1('SU', '92', ah.SupplierCode, 'EMPIRE ELECTRONICS, INC.')
						 				FOR XML RAW ('LOOP-N1'), TYPE
						 			)
								,	(	SELECT
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_NORPLAS_ASN.SEG_N1('ST', '92', ah.ShipToID, ah.ShipToName)
						 				FOR XML RAW ('LOOP-N1'), TYPE
						 			)
				 				FOR XML RAW ('LOOP-HL'), TYPE
				 			)
							--HL Order Loop
						,	(	SELECT
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(ItemLevel.RowID, 1, 'O', NULL)
								,	EDI_XML_V4010.SEG_LIN(NULL, 'BP', al.CustomerPart, NULL, NULL)
								,	EDI_XML_V4010.SEG_SN1(NULL, al.QtyPacked, 'EA', al.AccumShipped)
								,	EDI_XML_V4010.SEG_PRF(al.CustomerPO)
								-- HL Item (CLD and Box Serials)
								,	(	SELECT
				 							EDI_XML.LOOP_INFO('HL')
										,	EDI_XML_V4010.SEG_HL( PackLevel.RowID, ItemLevelpack.RowID, 'I', NULL)
										,	EDI_XML_V4010.SEG_CLD(alpqd.PackCount, alpqd.PackQty, alpqd.PackType)
										,	EDI_XML_NORPLAS_ASN.udf_OrderSerials(ah.ShipperID, al.CustomerPart, alpqd.PackType, alpqd.PackQty)								
										FROM
											[EDI_XML_NORPLAS_ASN].[Fn_ASNLinePackQtyDetails](@ShipperID, al.CustomerPart) alpqd
											OUTER APPLY ( SELECT TOP 1 IP.RowID FROM @ItemsPack IP WHERE IP.ShipperID = @ShipperID AND IP.CustomerPart = alpqd.CustomerPart AND IP.PackType = alpqd.PackType AND IP.PackCount = alpqd.PackCount AND IP.rowType = 'p') PackLevel
											OUTER APPLY ( SELECT TOP 1 IP.RowID FROM @ItemsPack IP WHERE IP.ShipperID = @ShipperID AND IP.CustomerPart = alpqd.CustomerPart  AND IP.rowType = 'i') ItemLevelPack
										FOR XML RAW ('LOOP-HL'), TYPE
									)
								FROM
									EDI_XML_NORPLAS_ASN.ASNLines al
									OUTER APPLY ( SELECT TOP 1 IP.RowID FROM @ItemsPack IP WHERE IP.ShipperID = @ShipperID AND IP.CustomerPart = al.CustomerPart  AND IP.rowType = 'i') ItemLevel
								WHERE
									al.ShipperID = @ShipperID
								ORDER BY
									al.RowNumber
				 				FOR XML RAW ('LOOP-HL'), TYPE
							)
						--Item (CLD) Loop
						
						,	EDI_XML_V4010.SEG_CTT( ItempackCount.maxRowID, @TotalQuantity)
						FROM
							EDI_XML_NORPLAS_ASN.ASNHeaders ah
						CROSS APPLY ( SELECT MAX(RowID) maxRowID FROM @ItemsPack ) AS ItempackCount
						WHERE
							ah.ShipperID = @ShipperID
						FOR XML RAW ('TRN-856'), TYPE
					)
				FOR XML RAW ('TRN'), TYPE
			)
--- </Body>

---	<Return>
	RETURN
		@xmlOutput
END





GO
