SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [EDI_XML_PLEX_ASN].[udf_Root]
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
	,	@TotalQuantity = sum(al.QtyPacked)
	from
		EDI_XML_PLEX_ASN.ASNLines al
	where
		al.ShipperID = @ShipperID

	set
		@xmlOutput =
			(	select
					(	select
							EDI_XML.TRN_INFO('004010', '856', ah.TradingPartner, ah.IConnectID, ah.ShipperID, @PartialComplete)
						,	EDI_XML_V4010.SEG_BSN(@Purpose, ah.ShipperID, ah.ASNDate, ah.ASNTime)
						,	EDI_XML_V4010.SEG_DTM('011', ah.ShipDateTime, ah.TimeZoneCode)
						,	(	select
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(1, null, 'S', 1)
								,	EDI_XML_V4010.SEG_MEA('WT', 'G', ah.GrossWeight, 'LB')
								,	EDI_XML_V4010.SEG_MEA('WT', 'N', ah.NetWeight, 'LB')
								,	EDI_XML_V4010.SEG_TD1(ah.PackageType, ah.BOLQuantity)
								,	EDI_XML_V4010.SEG_TD5('B', '2', ah.Carrier, ah.TransMode, null, null)
								,	EDI_XML_V4010.SEG_TD3('TL', ah.EquipInitial, ah.TruckNumber)
								,	EDI_XML_V4010.SEG_REF('PK', ah.PackingListNumber)
								,	EDI_XML_V4010.SEG_REF('BM', ah.BOLNumber)
								,	EDI_XML_V4010.SEG_REF('CN', ah.PackingListNumber)
								,   EDI_XML_PLEX_ASN.SEG_FOB(ah.FOB)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_PLEX_ASN.SEG_N1('ST', ah.ShipToIDtype, ah.ShipToID, ah.ShipToName)
						 				for xml raw ('LOOP-N1'), type
						 			)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_PLEX_ASN.SEG_N1('SU', ah.supplierIDType, ah.SupplierCode, ah.SupplierName)
						 				for xml raw ('LOOP-N1'), type
						 			)
				 				for xml raw ('LOOP-HL'), type
				 			)
							--, EDI_XML_V4010.SEG_HL(2, 1, 'T', null)
						,	(	select
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(1+al.RowNumber, 1, 'I', null)
								,	EDI_XML_PLEX_ASN.SEG_LIN(null, 'BP', al.CustomerPart, 'PO', al.CustomerPO, 'EC', al.CustomerECL)
								,	EDI_XML_V4010.SEG_SN1(null, al.QtyPacked, 'EA', al.AccumShipped)
								,	EDI_XML_V4010.SEG_PRF(al.CustomerPO)
									--CLD Loop
								,	(	select
											EDI_XML.LOOP_INFO('CLD')
										,	EDI_XML_V4010.SEG_CLD(alpqd.PackCount, alpqd.PackQty, ah.PackageType)
										,	EDI_XML_PLEX_ASN.udf_OrderSerials(ah.ShipperID, al.CustomerPart)
										from
											EDI_XML_PLEX_ASN.ASNLinePackQtyDetails alpqd
										where
											alpqd.ShipperID = al.ShipperID
											and alpqd.CustomerPart = al.CustomerPart
										for xml raw ('LOOP-CLD'), type
									)	
								from
									EDI_XML_PLEX_ASN.ASNLines al
								where
									al.ShipperID = @ShipperID
								order by
									al.RowNumber
				 				for xml raw ('LOOP-HL'), type
							)
						,	EDI_XML_V4010.SEG_CTT(1 + @ItemLoops, null)
						from
							EDI_XML_PLEX_ASN.ASNHeaders ah
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
