SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [EDI_XML_GM_SPO_ASN].[udf_Root]
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

	SET
		@xmlOutput =
			(	SELECT
					(	SELECT
							EDI_XML.TRN_INFO('00D97A', 'DESADV', ah.TradingPartner, ah.IConnectID, ah.ShipperID, NULL)
						,	EDI_XML_VD97A.SEG_BGM('351', NULL, ah.ShipperID, '9')
						,	EDI_XML_VD97A.SEG_DTM('137', ah.ShipDateTime, '203')
						,	EDI_XML_VD97A.SEG_DTM('11', ah.ASNDate, '203')
						,	EDI_XML_VD97A.SEG_MEA('AAX', 'G', 'LBR', ah.GrossWeightLbs)
						,	EDI_XML_VD97A.SEG_MEA('AAX', 'SQ', 'C62', ah.StagedObjs)
						,	EDI_XML_VD97A.SEG_MEA('AAX', 'N', 'LBR', ah.NetWeightLbs)
						,	(	SELECT
						 							EDI_XML.LOOP_INFO('RFF')
												,	EDI_XML_VD97A.SEG_RFF('CN', ah.CNNumber)
						 						FOR XML RAW ('LOOP-RFF'), TYPE
						 					)
						,	(	SELECT
						 			EDI_XML.LOOP_INFO('NAD')
								,	EDI_XML_VD97A.SEG_NAD('MI', ah.MaterialIssuer, NULL, '92')
						 		FOR XML RAW ('LOOP-NAD'), TYPE
						 	)
						,	(	SELECT
						 			EDI_XML.LOOP_INFO('NAD')
								,	EDI_XML_VD97A.SEG_NAD('ST', ah.Destination, NULL, '92')
								,	EDI_XML_VD97A.SEG_LOC('11', ah.ShippingDock)
						 		FOR XML RAW ('LOOP-NAD'), TYPE
						 	)
						,	(	SELECT
						 			EDI_XML.LOOP_INFO('NAD')
								,	EDI_XML_VD97A.SEG_NAD('SU', ah.SupplierCode, NULL, '16')
						 		FOR XML RAW ('LOOP-NAD'), TYPE
						 	)
						,	(	SELECT
						 			EDI_XML.LOOP_INFO('TDT')
								,	EDI_XML_VD97A.SEG_TDT('12', NULL, ah.TransMode, ah.SCAC, NULL, '182', NULL)
						 		FOR XML RAW ('LOOP-TDT'), TYPE
						 	)
						,	(	SELECT
						 			EDI_XML.LOOP_INFO('EQD')
								,	EDI_XML_VD97A.SEG_EQD('TE', ah.TruckNo)
						 		FOR XML RAW ('LOOP-EQD'), TYPE
						 	)
							--CPS Loop
						,	(	SELECT
						 			EDI_XML.LOOP_INFO('CPS')
								,	EDI_XML_VD97A.SEG_CPS(al.RowNumber, NULL, al.PackagingIndicator)
								--PAC Loop
								,	(	SELECT
						 					EDI_XML.LOOP_INFO('PAC')
										,	EDI_XML_VD97A.SEG_PAC(al.ObjectPackCount, NULL)
										,	(	SELECT
								 					EDI_XML.LOOP_INFO('PCI')
												,	EDI_XML_VD97A.SEG_PCI('16')
												,	EDI_XML_VD97A.SEG_RFF('CN', ah.ProNumber)
								 				FOR XML RAW ('LOOP-PCI'), TYPE
								 			)
						 				FOR XML RAW ('LOOP-PAC'), TYPE
						 			)
								--LIN Loop
								,	(	SELECT
						 					EDI_XML.LOOP_INFO('LIN')
										,	EDI_XML_VD97A.SEG_LIN(NULL, NULL, al.CustomerPart, 'IN')
										,	EDI_XML_VD97A.SEG_QTY('12', al.ObjectQty, 'C62')
										,	EDI_XML_VD97A.SEG_QTY('3', al.AccumQty, 'C62')
										--RFF Loop
										,	(	SELECT
						 							EDI_XML.LOOP_INFO('RFF')
												,	EDI_XML_VD97A.SEG_RFF('ON', al.CustomerPO)
						 						FOR XML RAW ('LOOP-RFF'), TYPE
						 					)
						 				FOR XML RAW ('LOOP-LIN'), TYPE
						 			)
								FROM
									EDI_XML_GM_SPO_ASN.udf_ASNLines (@ShipperID) al
						 		FOR XML RAW ('LOOP-CPS'), TYPE
						 	)
						FROM
							EDI_XML_GM_SPO_ASN.ASNHeaders ah
						WHERE
							ah.ShipperID = @ShipperID
						FOR XML RAW ('TRN-DESADV'), TYPE
					)
				FOR XML RAW ('TRN'), TYPE
			)
--- </Body>

---	<Return>
	RETURN
		@xmlOutput
END

GO
