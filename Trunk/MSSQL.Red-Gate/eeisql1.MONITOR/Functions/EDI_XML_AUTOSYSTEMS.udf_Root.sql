SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_AUTOSYSTEMS].[udf_Root]
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

	set
		@xmlOutput =
			(	select
					(	select
							EDI_XML.TRN_INFO('004010', '856', 'AUTOSYSTEMS', '???', ah.ShipperID, @PartialComplete)
						,	EDI_XML_V4010.SEG_BSN(@Purpose, ah.ShipperID, ah.ASNDate, ah.ASNTime)
						,	EDI_XML_V4010.SEG_DTM('011', ah.ShipDateTime, '')
						,	(	select
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(1, null, 'S', 1)
								,	EDI_XML_V4010.SEG_MEA('PD', 'G', ah.GrossWeight, 'LB')
								,	EDI_XML_V4010.SEG_MEA('PD', 'T', '', 'LB')
								,	EDI_XML_V4010.SEG_TD1(ah.PackageType, '')
								,	EDI_XML_V4010.SEG_TD5('B', '2', ah.Carrier, ah.TransMode, null, null)
								,	EDI_XML_V4010.SEG_TD3('TL', null, ah.TruckNumber)
								,	EDI_XML_V4010.SEG_REF('BM', ah.BOLNumber)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_V4010.SEG_N1('ST', 'ST', '200142425')
						 				for xml raw ('LOOP-N1'), type
						 			)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_V4010.SEG_N1('SF', 'SF', 'US0842')
						 				for xml raw ('LOOP-N1'), type
						 			)
				 				for xml raw ('LOOP-HL'), type
				 			)
			--			,	EDI_XML_Toyota_ASN.LOOP_HL_OrderLines(@ShipperID)
			--			,	EDI_XML_V4010.SEG_CTT(1 + @ItemLoops, @TotalQuantity)
						from
							EDI_XML_AUTOSYSTEMS.ASNHeaders ah
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
