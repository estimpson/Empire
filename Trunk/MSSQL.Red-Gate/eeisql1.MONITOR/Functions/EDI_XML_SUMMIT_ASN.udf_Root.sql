SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [EDI_XML_SUMMIT_ASN].[udf_Root]
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
						,	EDI_XML_VD97A.SEG_BGM('351', 'DESADV', ah.ShipperID, '9')
						,	EDI_XML_VD97A.SEG_DTM('11', ah.ShipDateTime, '203')
						,	EDI_XML_VD97A.SEG_DTM('137', ah.ASNDate, '203')
						,	EDI_XML_VD97A.SEG_DTM('132', ah.ArrivalDate, '203')
						,	EDI_XML_VD97A.SEG_MEA('AAX', 'G', 'LBR', ah.GrossWeightLbs)
						,	EDI_XML_VD97A.SEG_MEA('AAX', 'N', 'LBR', ah.NetWeightLbs)
						,	(	select
						 			EDI_XML.LOOP_INFO('RFF')
								,	EDI_XML_VD97A.SEG_RFF('BM', ah.ReferenceN)
						 		for xml raw ('LOOP-RFF'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('NAD')
								,	EDI_XML_VD97A.SEG_NAD('MI', ah.MaterialIssuerID, null, '16')
						 		for xml raw ('LOOP-NAD'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('NAD')
								,	EDI_XML_SUMMIT_ASN.SEG_NAD('SU', ah.SupplierCode, null, '16', 'Empire Electronics, Inc.')
						 		for xml raw ('LOOP-NAD'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('NAD')
								,	EDI_XML_VD97A.SEG_NAD('ST', ah.ShipToID, null, '16')
						 		for xml raw ('LOOP-NAD'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('TDT')
								,	EDI_XML_VD97A.SEG_TDT('12', null, ah.TransMode, ah.SCAC, null, '182', ah.CarrierName)
						 		for xml raw ('LOOP-TDT'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('EQD')
								,	EDI_XML_VD97A.SEG_EQD('TE', ah.TrailerNumber)
						 		for xml raw ('LOOP-EQD'), type
						 	)
							--CPS Loop
						,	(	select
						 			EDI_XML.LOOP_INFO('CPS')
								,	EDI_XML_VD97A.SEG_CPS(al.RowNumber, null, '4')
								--PAC Loop
								,	(	select
						 					EDI_XML.LOOP_INFO('PAC')
										,	EDI_XML_VD97A.SEG_PAC(al.PackageCount, null)
										--PCI Loop
										,	(	select
						 							EDI_XML.LOOP_INFO('PCI')
												,	EDI_XML_VD97A.SEG_PCI('16')
						 						for xml raw ('LOOP-PCI'), type
						 					)
						 				for xml raw ('LOOP-PAC'), type
						 			)
								--LIN Loop
								,	(	select
						 					EDI_XML.LOOP_INFO('LIN')
										,	EDI_XML_VD97A.SEG_LIN(null, null, al.CustomerPart, 'IN')
										,	EDI_XML_VD97A.SEG_QTY('12', al.QtyShipped, 'EA')
										,	EDI_XML_VD97A.SEG_QTY('3', al.AccumShipped, 'EA')
										--RFF Loop
										,	(	select
						 							EDI_XML.LOOP_INFO('RFF')
												,	EDI_XML_VD97A.SEG_RFF('ON', al.CustomerPO)
						 						for xml raw ('LOOP-RFF'), type
						 					)
						 				for xml raw ('LOOP-LIN'), type
						 			)
								from
									EDI_XML_SUMMIT_ASN.ASNLines al
								where
									al.ShipperID = @ShipperID
						 		for xml raw ('LOOP-CPS'), type
						 	)
						from
							EDI_XML_SUMMIT_ASN.ASNHeaders ah
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
