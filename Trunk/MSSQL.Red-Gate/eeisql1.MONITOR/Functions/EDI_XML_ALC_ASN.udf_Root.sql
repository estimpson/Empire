SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [EDI_XML_ALC_ASN].[udf_Root]
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
						,	EDI_XML_VD97A.SEG_BGM('351', null, ah.ShipperID, '9')
						,	EDI_XML_VD97A.SEG_DTM('137', ah.ShipDateTime, '203')
						,	EDI_XML_VD97A.SEG_DTM('11', ah.ASNDate, '203')
						,	EDI_XML_VD97A.SEG_MEA('AAX', 'G', 'LBR', ah.GrossWeightLbs)
						,	EDI_XML_VD97A.SEG_MEA('AAX', 'N', 'LBR', ah.NetWeightLbs)
						,	EDI_XML_VD97A.SEG_MEA('AAX', 'SQ', 'PCE', ah.StagedObjs)
						,	EDI_XML_VD97A.SEG_RFF('AAS', ah.ShipperID)
						,	EDI_XML_VD97A.SEG_DTM('171', ah.ShipDateTime, '203')
						,	(	select
						 			EDI_XML.LOOP_INFO('NAD')
								,	EDI_XML_VD97A.SEG_NAD('SU', ah.SupplierCode, null, '92')
						 		for xml raw ('LOOP-NAD'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('NAD')
								,	EDI_XML_VD97A.SEG_NAD('BY', ah.MaterialIssuer, null, '92')
						 		for xml raw ('LOOP-NAD'), type
						 	)											
						,	(	select
						 			EDI_XML.LOOP_INFO('NAD')
								,	EDI_XML_VD97A.SEG_NAD('ST', ah.Destination, null, '92')
								,	EDI_XML_VD97A.SEG_LOC('11', ah.ShippingDock)
						 		for xml raw ('LOOP-NAD'), type
						 	)						
						,	(	select
						 			EDI_XML.LOOP_INFO('TDT')
								,	EDI_XML_VD97A.SEG_TDT('12', null, ah.TransMode, ah.SCAC, null, '92', null)
						 		for xml raw ('LOOP-TDT'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('EQD')
								,	EDI_XML_VD97A.SEG_EQD('TE', ah.TruckNo)
						 		for xml raw ('LOOP-EQD'), type
						 	)
							--CPS Loop
						,	(	select
						 			EDI_XML.LOOP_INFO('CPS')
								,	EDI_XML_VD97A.SEG_CPS(al.RowNumber, null, 1)
								,	EDI_XML_VD97A.SEG_PAC(al.ObjectPackCount, '0000')
								--PCI Loop
										,	(	select
								 					EDI_XML.LOOP_INFO('PCI')
												,	EDI_XML_VD97A.SEG_PCI('16')
												,	EDI_XML_VD97A.SEG_RFF('AAT', ap.MasterSerial)
												,	 [EDI_XML_ALC_ASN].[SEG_GIR] ('3','NOLOT', 'BX', ap.SerialNumber, 'ML')
												from
													 [EDI_XML_ALC_ASN].[udf_ASNSerials] (@ShipperID, al.CustomerPart) ap
								 				for xml raw ('LOOP-PCI'), type
								 			)
						 		
								--LIN Loop
								,	(	select
						 					EDI_XML.LOOP_INFO('LIN')
										,	EDI_XML_VD97A.SEG_LIN(null, null, al.CustomerPart, 'IN')
											--PIA Loop
										,	(	select
						 							EDI_XML.LOOP_INFO('PIA')
												,	EDI_XML_ALC_ASN.SEG_PIA('1', 'NOLOT', 'BB')
						 						for xml raw ('LOOP-PIA'), type
						 					)
										,	EDI_XML_VD97A.SEG_QTY('12', al.ObjectQty, 'PCE')
										,	EDI_XML_VD97A.SEG_DTM('94', ah.ShipDateTime-30, '102')
										--,	EDI_XML_VD97A.SEG_QTY('3', al.AccumQty, 'PCE')
										--RFF Loop
										,	(	select
						 							EDI_XML.LOOP_INFO('RFF')
												,	EDI_XML_ALC_ASN.SEG_RFF('ON', al.CustomerPO, al.CustomerPOLine)
						 						for xml raw ('LOOP-RFF'), type
						 					)
						 				for xml raw ('LOOP-LIN'), type
						 			)
										from
											EDI_XML_ALC_ASN.udf_ASNLines (@ShipperID) al
						 				for xml raw ('LOOP-CPS'), type
						 	)
						from
							EDI_XML_GM_SPO_ASN.ASNHeaders ah
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
