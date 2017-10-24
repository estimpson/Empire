SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [EDI_XML_Autosystems_ASN].[udf_Root]
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
	,	@TotalQuantity = sum(al.QtyPacked)
	from
		EDI_XML_Autosystems_ASN.ASNLines al
	where
		al.ShipperID = @ShipperID

	set
		@xmlOutput =
			(	select
					(	select
							EDI_XML.TRN_INFO('004010', '856', ah.TradingPartnerID, ah.iConnectID, ah.ShipperID, @PartialComplete)
						,	EDI_XML_V4010.SEG_BSN(@Purpose, ah.ShipperID, ah.ShipDate, ah.ShipTime)
						,	EDI_XML_V4010.SEG_DTM('011', ah.ShipDateTime, null)
						,	(	select
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(1, null, 'S', 1)
								,	EDI_XML_V4010.SEG_MEA('PD', 'G', ah.GrossWeight, 'LB')
								,	EDI_XML_V4010.SEG_MEA('PD', 'T', ah.TareWeight, 'LB')
								,	EDI_XML_V4010.SEG_TD1(ah.PackageType, ah.BOLQuantity)
								,	EDI_XML_V4010.SEG_TD5('B', '02', ah.Carrier, ah.TransMode, ah.LocationQualifier, ah.AirportCode)
								,	EDI_XML_V4010.SEG_TD3('TL', null, ah.TruckNumber)
								,	EDI_XML_V4010.SEG_REF('BM', ah.BOLNumber)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_V4010.SEG_N1('ST', 92, ah.ShipTo)
						 				for xml raw ('LOOP-N1'), type
						 			)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_V4010.SEG_N1('SF', 92, ah.SupplierCode)
						 				for xml raw ('LOOP-N1'), type
						 			)
				 				for xml raw ('LOOP-HL'), type
				 			)
						,	(	select
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(1+al.RowNumber, 1, 'I', 0)
								,	EDI_XML_V4010.SEG_LIN(null, 'BP', al.CustomerPart, null, null)
								,	EDI_XML_V4010.SEG_SN1(null, al.QtyPacked, al.Unit, al.AccumShipped)
								,	EDI_XML_Autosystems_ASN.SEG_PRF(al.CustomerPO, '2000' + right('0'+convert(varchar, al.RowNumber),2) + '00')
								,	EDI_XML_V4010.SEG_REF('PK', ah.ShipperID)
								from
									EDI_XML_Autosystems_ASN.ASNLines al
								where
									al.ShipperID = @ShipperID
								order by
									al.RowNumber
				 				for xml raw ('LOOP-HL'), type
							)
						,	EDI_XML_V4010.SEG_CTT(1 + @ItemLoops, @TotalQuantity)
						from
							EDI_XML_Autosystems_ASN.ASNHeaders ah
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
