SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE FUNCTION [EDI_XML_NASCOTE_ASN].[udf_Root]
(	@ShipperID INT
,	@Purpose CHAR(2)
,	@PartialComplete INT
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
		EDI_XML_NASCOTE_ASN.ASNLines al
	where
		al.ShipperID = @ShipperID

	SET
		@xmlOutput =
			(	SELECT
					(	SELECT
							EDI_XML.TRN_INFO('003060', '856', ah.TradingPartner, ah.IConnectID, ah.ShipperID, @PartialComplete)
						,	EDI_XML_v3060.SEG_BSN(@Purpose, ah.ShipperID, ah.ASNDate, ah.ASNTime)
						,	EDI_XML_v3060.SEG_DTM('011', ah.ShipDateTime, NULL)
						,	(	SELECT
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_v3060.SEG_HL(1, NULL, 'S', NULL)
								,	EDI_XML_v3060.SEG_MEA('PD', 'G', ah.GrossWeightLbs, 'LB')
								,	EDI_XML_v3060.SEG_MEA('PD', 'N', ah.NetWeightLbs, 'LB')
								,	EDI_XML_v3060.SEG_TD1('PLT71', ah.PackCount)
								,	EDI_XML_v3060.SEG_TD5('B', '2', ah.SCAC, ah.TransMode, NULL, NULL)
								,	EDI_XML_v3060.SEG_TD3('TL', NULL, ah.TrailerNumber)
								,	EDI_XML_v3060.SEG_REF('PK', ah.ShipperID)
								,	EDI_XML_v3060.SEG_REF('BM', ah.BOLNumber)
								,	(	SELECT
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_NASCOTE_ASN.SEG_N1('SU', 92, ah.SupplierCode, 'Empire Electronics, Inc.')
						 				FOR XML RAW ('LOOP-N1'), TYPE
						 			)
								,	(	SELECT
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_NASCOTE_ASN.SEG_N1('ST', 92, ah.ShipToID, ah.ShipToName)
						 				FOR XML RAW ('LOOP-N1'), TYPE
						 			)
						
				 				FOR XML RAW ('LOOP-HL'), TYPE
				 			)
						,	(	SELECT
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_v3060.SEG_HL(1+al.RowNumber, 1, 'I', NULL)
								,	EDI_XML_v3060.SEG_LIN(NULL, 'BP', al.CustomerPart, NULL, NULL)
								,	EDI_XML_v3060.SEG_SN1(NULL, al.QtyPacked, 'EA', al.AccumShipped)
								,	EDI_XML_v3060.SEG_PRF(al.CustomerPO)
								,	(	SELECT
				 							EDI_XML.LOOP_INFO('CLD')
										,	EDI_XML_v3060.SEG_CLD(alpqd.PackCount, alpqd.PackQty, 'PLT71')
										,	EDI_XML_v3060.SEG_REF('LS', alpqd.Serial)
										FROM
											EDI_XML_NASCOTE_ASN.ASNLinePackQuantityDetails alpqd
										WHERE
											alpqd.ShipperID = @ShipperID AND
											alpqd.CustomerPart = al.CustomerPart
				 						FOR XML RAW ('LOOP-CLD'), TYPE
										)
								FROM
									EDI_XML_NASCOTE_ASN.ASNLines al
								WHERE
									al.ShipperID = @ShipperID
								ORDER BY
									al.RowNumber
				 				FOR XML RAW ('LOOP-HL'), TYPE
								)
						,	EDI_XML_v3060.SEG_CTT(1 + @ItemLoops, @TotalQuantity)
						FROM
							EDI_XML_NASCOTE_ASN.ASNHeader ah
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
