SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [EDI_XML_AUTOLIV_ASN].[udf_Root]
(	@ShipperID int
,	@Purpose char(2)
,	@PartialComplete int
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
		EDI_XML_Autoliv_ASN.ASNLines al
	where
		al.ShipperID = @ShipperID

	set
		@xmlOutput =
			(	select
					(	select
							EDI_XML.TRN_INFO('004010', '856', ah.TradingPartner, ah.iConnectID , ah.ShipperID, @PartialComplete)
						,	EDI_XML_V4010.SEG_BSN(@Purpose, ah.ShipperID, ah.ASNDate, ah.ASNTime)
						,	EDI_XML_V4010.SEG_DTM('011', ah.ShipDateTime, ah.TimeZoneCode)
						,	(	select
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(1, null, 'S', 1)
								,	EDI_XML_V4010.SEG_MEA('PD', 'G', ah.GrossWeight, 'LB')
								,	EDI_XML_V4010.SEG_MEA('PD', 'N', ah.NetWeight, 'LB')
								,	EDI_XML_V4010.SEG_TD5('B', '2', ah.Carrier, ah.TransMode, null, null)
								,	EDI_XML_V4010.SEG_TD3('TL', null, ah.TruckNumber)
								,	EDI_XML_V4010.SEG_REF('SI', ah.BOLNumber)
								,	EDI_XML_V4010.SEG_REF('ED', ah.ProNumber)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_AUTOLIV_ASN.SEG_N1('MI', 'ZZ', ah.MaterialIssuer, ah.MaterialIssuerName)
						 				for xml raw ('LOOP-N1'), type
						 			)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_AUTOLIV_ASN.SEG_N1('ST', 'ZZ', ah.ShipToCode, ah.ShipToName)
						 				for xml raw ('LOOP-N1'), type
						 			)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_AUTOLIV_ASN.SEG_N1('SU', 92, ah.SupplierCode, ah.SupplierName)
						 				for xml raw ('LOOP-N1'), type
						 			)
				 				for xml raw ('LOOP-HL'), type
				 			)
						,	(	select
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(1+al.RowNumber, 1, 'I', null)
								,	EDI_XML_V4010.SEG_LIN(null, 'BP', al.CustomerPart, null, null)
								,	EDI_XML_V4010.SEG_SN1(null, al.QtyShipped, 'EA', null)
								,	EDI_XML_AUTOLIV_ASN.SEG_PRF(al.CustomerPO, al.CustomerR)
								,	EDI_XML_V4010.SEG_TD1(al.PackType, al.LadingQty)
								,	EDI_XML_V4010.SEG_REF('PK', ah.BOLNumber)
								from
									EDI_XML_Autoliv_ASN.ASNLines al
								where
									al.ShipperID = @ShipperID
								order by
									al.RowNumber
				 				for xml raw ('LOOP-HL'), type
								)
						,	EDI_XML_V4010.SEG_CTT(1 + @ItemLoops, @TotalQuantity)
						from
							EDI_XML_AUTOLIV_ASN.ASNHeaders ah
						where
							ah.ShipperID = @ShipperID
						for xml raw ('TRN-856'), type
					)
				for xml raw ('TRN'), type
			)
--- </Body>

---	<Return>
	return
		@xmlOutput
end

GO
