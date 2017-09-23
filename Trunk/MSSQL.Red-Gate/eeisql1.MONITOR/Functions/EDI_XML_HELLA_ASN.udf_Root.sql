SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [EDI_XML_HELLA_ASN].[udf_Root]
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
	,	@TotalQuantity = sum(al.QtyShipped)
	from
		EDI_XML_HELLA_ASN.ASNLines al
	where
		al.ShipperID = @ShipperID
	SET
		@xmlOutput =
			(	SELECT
					(	SELECT
							EDI_XML.TRN_INFO('00D07A', 'DESADV', ISNULL(NULLIF(ah.TradingPartner,''),'HELLA'), ISNULL(NULLIF(ah.iConnectID,''),'12342'), ah.ShipperID, NULL)
						,	EDI_XML_HELLA_ASN.SEG_BGM('351', 'DESADV', ah.ShipperID, '9', 'NA')
						,	EDI_XML_VD07A.SEG_DTM('137', ah.ASNDate, '203')
						,	EDI_XML_VD07A.SEG_DTM('11', ah.ShipDateTime, '203')
						,	EDI_XML_VD07A.SEG_DTM('132', ah.ShipDateTime, '203')
						,	EDI_XML_VD07A.SEG_RFF('AAS', ah.ProNumber, NULL)
						,	EDI_XML_VD07A.SEG_NAD('BY',	ah.BUYER, NULL, '91')
						,	EDI_XML_VD07A.SEG_NAD('SE', ah.NADIDSeller, NULL, '92')
						,	EDI_XML_VD07A.SEG_NAD('ST', ah.EDIShipTo, NULL, '92')
						,	EDI_XML_VD07A.SEG_LOC('11', ah.EDIShipTo, NULL, '92')
						,	EDI_XML_VD07A.SEG_TDT('12', NULL, ah.TransMode, NULL, NULL, NULL)
						,	EDI_XML_VD07A.SEG_EQD('TE', ah.trucknumber)
						
						--Item Loop
						,	(	SELECT
						 			EDI_XML.LOOP_INFO('CPS')
								,	EDI_XML_VD07A.SEG_CPS(al.rowNumber, NULL, 4)
								
								--	Item Pack Group & Serials Per Item Pack Group - Commenting per Brighitta smail 10/6/2016 stating packaging was not required on the ASN
								--,		( SELECT	EDI_XML_VD07A.SEG_PAC ( pg.packCount, NULL, '35', pg.PackageType, NULL, '92')
								--				,	EDI_XML_VD07A.SEG_QTY('52', pg.PackageQty, 'PCE')
								--				,	EDI_XML_VD07A.SEG_PCI ( '17', NULL, NULL, 'S' )

								--				-- Get All serials for this part, pack group Grouping 
								--				,	 [EDI_XML_HELLA_ASN].[udf_OrderSerials] (al.ShipperID, al.CustomerPart, pg.PackAgeType, pg.PackageQty ) 
								--			FROM
								--			EDI_XML_HELLA_ASN.ASNPackGroup pg
								--			WHERE
								--			ShipperID = al.ShipperID AND
								--			CustomerPart =  al.CustomerPart
								--			FOR XML RAW ('LOOP-PAC'), TYPE )
								,	EDI_XML_HELLA_ASN.SEG_LIN(NULL, al.CustomerPart )
								,	EDI_XML_HELLA_ASN.SEG_PIA(al.InternalPart, al.DrawingRevisionNumber)
								,	EDI_XML_HEllA_ASN.SEG_IMD (NULL, NULL, NULL, NULL, NULL, al.PartName)
								,	EDI_XML_VD07A.SEG_QTY('12', al.QtyShipped, 'C62')
								,	EDI_XML_VD07A.SEG_ALI ( 'HN' )
								,	EDI_XML_VD07A.SEG_RFF ( 'ON', al.CustomerPO, al.CustomerPOLine )
								--,	EDI_XML_VD07A.SEG_RFF ( 'CR', 'KANBANID', 'KBLINE' ) --waiting for Hella to define this data asb 08/20/2016; asb: commented per email from Brighitta 12/13/2016
								,	EDI_XML_VD07A.SEG_DTM('171', GETDATE() , '203') -- waiting for Hella to define this data asb 08/20/2016
								,	EDI_XML_VD07A.SEG_LOC('159', al.LineFeed, NULL, '92')
									
								FROM
									EDI_XML_HELLA_ASN.ASNLines al
								WHERE
									al.ShipperID = @ShipperID
								ORDER BY
									al.RowNumber
						 		FOR XML RAW ('LOOP-CPS'), TYPE
						 	)
						,	EDI_XML_VD07A.SEG_CNT('2', @ItemLoops)
						FROM
							EDI_XML_HELLA_ASN.ASNHeaders ah
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
