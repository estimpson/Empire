SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE function [EDI_XML_TRW_ASN].[udf_Root]
(	@ShipperID int
,	@Purpose char(2)
,	@partialComplete int
)
returns xml
as
begin
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
		EDI_XML_TRW_ASN.ASNLines al
	where
		al.ShipperID = @ShipperID
	set
		@xmlOutput =
			(	select
					(	select
							EDI_XML.TRN_INFO('00D97A', 'DESADV', ah.TradingPartner, ah.IConnectID, ah.ShipperID, null)
						,	EDI_XML_TRW_ASN.SEG_BGM('350', 'DESADV', ah.ShipperID, '9', 'NA')
						,	EDI_XML_VD97A.SEG_DTM('10', ah.ShipDateTime, '102')
						,	EDI_XML_VD97A.SEG_DTM('97', ah.ASNDate, '102')
						,	EDI_XML_TRW_ASN.SEG_MEA('EGW', 'KG', ah.GrossWeightKG)
						,	EDI_XML_TRW_ASN.SEG_MEA('WT', 'KG', ah.NetWeightKG)
						,	EDI_XML_TRW_ASN.SEG_MEA('AAU', 'EA', ah.Lifts)
						,	(	select
						 			EDI_XML.LOOP_INFO('RFF')
								,	EDI_XML_VD97A.SEG_RFF('PK', ah.ShipperID)
						 		for xml raw ('LOOP-RFF'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('RFF')
								,	EDI_XML_VD97A.SEG_RFF('BM', ah.BOL)
						 		for xml raw ('LOOP-RFF'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('NAD')
								,	EDI_XML_VD97A.SEG_NAD('ST', ah.EDIShipTo, null, null)
						 		for xml raw ('LOOP-NAD'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('NAD')
								,	EDI_XML_VD97A.SEG_NAD('SF', ah.SupplierCode, null, null)
						 		for xml raw ('LOOP-NAD'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('TDT')
								,	EDI_XML_VD97A.SEG_TDT('20', ah.TruckNumber, ah.TransMode, ah.SCAC, null, null, null)
						 		for xml raw ('LOOP-TDT'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('CPS')
								,	EDI_XML_VD97A.SEG_CPS(al.RowNumber, null, null)
								,	(	select
											EDI_XML.LOOP_INFO('LIN')
										,	EDI_XML_VD97A.SEG_LIN(al.ShipperLine, null, al.CustomerPart, null)
										,	EDI_XML_VD97A.SEG_PIA('1', al.CustomerPO, 'PO')
										,	EDI_XML_VD97A.SEG_QTY('1', al.QtyShipped, al.UM)	
										,	EDI_XML_VD97A.SEG_QTY('3', al.AccumShipped, al.UM)	
										for xml raw ('LOOP-LIN'), type
									)
								from
									EDI_XML_TRW_ASN.ASNLines al
								where
									al.ShipperID = @ShipperID
								order by
									al.RowNumber
						 		for xml raw ('LOOP-CPS'), type
						 	)
						,	EDI_XML_VD97A.SEG_CNT('2', @ItemLoops)
						from
							EDI_XML_TRW_ASN.ASNHeaders ah
						where
							ah.ShipperID = @ShipperID
						for xml raw ('TRN-DESADV'), type
					)
				for xml raw ('TRN'), type
			)
--- </Body>

---	<Return>
	return
		@xmlOutput
end



GO
