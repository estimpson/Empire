SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [EDI_XML_GM_BFT_ASN].[udf_Root]
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

	set
		@xmlOutput =
			(	select
					(	select
							EDI_XML.TRN_INFO('00D97A', 'DESADV', ah.TradingPartner, ah.IConnectID, ah.ShipperID, null)
						,	EDI_XML_VD97A.SEG_BGM(null, 'DESADV', ah.ShipperID, '9')
						,	EDI_XML_VD97A.SEG_DTM('137', ah.ShipDateTime, '203')
						,	EDI_XML_VD97A.SEG_DTM('11', ah.ASNDate, '203')
						,	EDI_XML_VD97A.SEG_DTM('132', ah.ArrivalDate, '203')
						,	EDI_XML_VD97A.SEG_MEA('AAX', 'G', 'LBR', ah.GrossWeightLbs)
						,	EDI_XML_VD97A.SEG_MEA('AAX', 'N', 'LBR', ah.NetWeightLbs)
						,	EDI_XML_VD97A.SEG_MEA('AAX', 'SQ', 'C62', ah.StagedObjs)
						,	(	select
						 			EDI_XML.LOOP_INFO('RFF')
								,	EDI_XML_VD97A.SEG_RFF('MB', ah.BOL)
						 		for xml raw ('LOOP-RFF'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('NAD')
								,	EDI_XML_VD97A.SEG_NAD('MI', ah.MaterialIssuer, null, '192')
						 		for xml raw ('LOOP-NAD'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('NAD')
								,	EDI_XML_VD97A.SEG_NAD('ST', ah.Destination, null, '92')
								,	EDI_XML_VD97A.SEG_LOC('11', ah.ShippingDock)
						 		for xml raw ('LOOP-NAD'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('NAD')
								,	EDI_XML_VD97A.SEG_NAD('SU', ah.SupplierCode, null, '16')
						 		for xml raw ('LOOP-NAD'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('TDT')
								,	EDI_XML_VD97A.SEG_TDT('12', null, ah.TransMode, ah.SCAC, null, '182', null)
						 		for xml raw ('LOOP-TDT'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('EQD')
								,	EDI_XML_VD97A.SEG_EQD('TE', ah.TruckNumber)
						 		for xml raw ('LOOP-EQD'), type
						 	)
							--CPS Loop
						,	(	select
						 			EDI_XML.LOOP_INFO('CPS')
								,	EDI_XML_VD97A.SEG_CPS(al.RowNumber, null, al.PackagingIndicator)
								--PAC Loops
								,	(	select
						 					EDI_XML.LOOP_INFO('PAC')
										,	EDI_XML_VD97A.SEG_PAC(al.ObjectPackCount, al.ObjectPackCode)
						 				for xml raw ('LOOP-PAC'), type
						 			)
								,	(	select
						 					EDI_XML.LOOP_INFO('PAC')
										,	EDI_XML_VD97A.SEG_PAC(al.PalletPackCount, al.PalletPackCode)
						 				for xml raw ('LOOP-PAC'), type
						 			)
								--LIN Loop
								,	(	select
						 					EDI_XML.LOOP_INFO('LIN')
										,	EDI_XML_VD97A.SEG_LIN(null, null, al.CustomerPO, 'IN')
										,	EDI_XML_VD97A.SEG_PIA('1', al.ModelYear, 'RY')
										,	EDI_XML_VD97A.SEG_QTY('12', al.ObjectQty, 'C62')
										,	EDI_XML_VD97A.SEG_QTY('3', al.AccumQty, 'C62')
										--RFF Loop
										,	(	select
						 							EDI_XML.LOOP_INFO('RFF')
												,	EDI_XML_VD97A.SEG_RFF('ON', al.CustomerPO)
						 						for xml raw ('LOOP-RFF'), type
						 					)
						 				for xml raw ('LOOP-LIN'), type
						 			)
								from
									EDI_XML_GM_BFT_ASN.ASNLines al
								where
									al.ShipperID = @ShipperID
						 		for xml raw ('LOOP-CPS'), type
						 	)
						from
							EDI_XML_GM_BFT_ASN.ASNHeaders ah
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
