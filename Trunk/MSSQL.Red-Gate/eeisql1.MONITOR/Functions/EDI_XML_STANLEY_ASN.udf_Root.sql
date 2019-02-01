SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE FUNCTION [EDI_XML_STANLEY_ASN].[udf_Root]
(	@ShipperID INT
,	@Purpose CHAR(2)
,	@partialComplete INT
)
RETURNS XML
AS
BEGIN
--- <Body>

--Andre FT, LLC 2018/07/05 - Changed packing slip identifier to PS per Stanley's request 
	declare
		@xmlOutput xml

	declare
		@ItemLoops int
	,	@TotalQuantity int

	select
		@ItemLoops = count(*)
	,	@TotalQuantity = sum(al.QtyPacked)
	from
		EDI_XML_STANLEY_ASN.ASNLines al
	where
		al.ShipperID = @ShipperID

	SET
		@xmlOutput =
			(	SELECT
					(	SELECT
							EDI_XML.TRN_INFO('004010', '856', ah.TradingPartner, ah.IConnectID, ah.ShipperID, @PartialComplete)
						,	EDI_XML_V4010.SEG_BSN(@Purpose, ah.ShipperID, ah.ASNDate, ah.ASNTime)
						,	EDI_XML_V4010.SEG_DTM('011', ah.ShipDateTime, ah.TimeZoneCode)
						,	(	SELECT
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(1, NULL, 'S', NULL)
								,	EDI_XML_V4010.SEG_MEA('PD', 'G', ah.GrossWeight, 'LB')
								,	EDI_XML_V4010.SEG_MEA('PD', 'N', ah.NetWeight, 'LB')
								,	EDI_XML_V4010.SEG_TD1(ah.PackageType, ah.BOLQuantity)
								,	EDI_XML_V4010.SEG_TD5('B', '2', ah.Carrier, ah.TransMode, NULL, NULL)
								,	EDI_XML_V4010.SEG_TD3(ah.EquipDesc, ah.EquipInitial, ah.TrailerNumber)
								,	EDI_XML_V4010.SEG_REF('BM', ah.BOLNumber)
								,	EDI_XML_V4010.SEG_REF('PS', ah.ShipperID)
								,	(	SELECT
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_V4010.SEG_N1_NAME('ST', '92', ah.ShipToID, ah.ShipToName)
						 				FOR XML RAW ('LOOP-N1'), TYPE
						 			)
								,	(	SELECT
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_V4010.SEG_N1_NAME('SU', '92', ah.SupplierCode, ah.SupplierName)
						 				FOR XML RAW ('LOOP-N1'), TYPE
						 			)
				 				FOR XML RAW ('LOOP-HL'), TYPE
				 			)
						,	(	SELECT
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(1+al.RowNumber, 1, 'I', NULL)
								,	EDI_XML_V4010.SEG_LIN(NULL, 'BP', al.CustomerPart, 'PO', al.CustomerPO)
								,	EDI_XML_V4010.SEG_SN1(NULL, al.Quantity, 'PC', NULL)
								--CLD Segments
								,	(	SELECT
											EDI_XML_V4010.SEG_CLD(alpqd.PackCount, alpqd.PackQty, alpqd.PackageType)
										,	(	SELECT
										 			EDI_XML_V4010.SEG_REF('LS', ao.Serial )
										 		FROM
										 			[EDI_XML_STANLEY_ASN].[udf_ASNSerials](@ShipperID) ao
												WHERE
													ao.ShipperID = alpqd.ShipperID
													AND ao.CustomerPart = alpqd.CustomerPart
													AND ao.DiscretePO = alpqd.DiscretePO
													AND ao.PackageType = alpqd.PackageType
													AND ao.SerialQty = alpqd.PackQty
												FOR XML PATH (''), TYPE
										 	)
										FROM
											[EDI_XML_STANLEY_ASN].[udf_ASNLinePackQtyDetails](ShipperID) alpqd
										WHERE
											alpqd.ShipperID = al.ShipperID
											AND alpqd.CustomerPart = al.CustomerPart
											AND alpqd.DiscretePO = al.CustomerPO
										FOR XML PATH (''), TYPE
									)	
								FROM
									 [EDI_XML_STANLEY_ASN].[udf_ASNLines] (@ShipperID) al
								ORDER BY
									al.RowNumber
				 				FOR XML RAW ('LOOP-HL'), TYPE
							)
						,	EDI_XML_V4010.SEG_CTT(1 + @ItemLoops, @TotalQuantity)
						FROM
							EDI_XML_STANLEY_ASN.ASNHeaders ah
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
