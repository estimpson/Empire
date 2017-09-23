
alter function EDI_XML_STANLEY_ASN.udf_Root
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
		@ItemLoops = count(*)
	,	@TotalQuantity = sum(al.QtyPacked)
	from
		EDI_XML_STANLEY_ASN.ASNLines al
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
								,	EDI_XML_V4010.SEG_HL(1, null, 'S', null)
								,	EDI_XML_V4010.SEG_MEA('PD', 'G', ah.GrossWeight, 'LB')
								,	EDI_XML_V4010.SEG_MEA('PD', 'N', ah.NetWeight, 'LB')
								,	EDI_XML_V4010.SEG_TD1(ah.PackageType, ah.BOLQuantity)
								,	EDI_XML_V4010.SEG_TD5('B', '2', ah.Carrier, ah.TransMode, null, null)
								,	EDI_XML_V4010.SEG_TD3(ah.EquipDesc, ah.EquipInitial, ah.TrailerNumber)
								,	EDI_XML_V4010.SEG_REF('BM', ah.BOLNumber)
								,	EDI_XML_V4010.SEG_REF('PK', ah.ShipperID)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_V4010.SEG_N1_NAME('ST', '92', ah.ShipToID, ah.ShipToName)
						 				for xml raw ('LOOP-N1'), type
						 			)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_V4010.SEG_N1_NAME('SU', '92', ah.SupplierCode, ah.SupplierName)
						 				for xml raw ('LOOP-N1'), type
						 			)
				 				for xml raw ('LOOP-HL'), type
				 			)
						,	(	select
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(1+al.RowNumber, 1, 'I', null)
								,	EDI_XML_V4010.SEG_LIN(null, 'BP', al.CustomerPart, 'PO', al.CustomerPO)
								,	EDI_XML_V4010.SEG_SN1(null, al.QtyPacked, 'EA', null)
								--CLD Segments
								,	(	select
											EDI_XML_V4010.SEG_CLD(alpqd.PackCount, alpqd.PackQty, alpqd.PackageType)
										,	(	select
										 			EDI_XML_V4010.SEG_REF('LS', ao.CustomerSerial )
										 		from
										 			EDI_XML_STANLEY_ASN.ASNObjects ao
												where
													ao.ShipperID = alpqd.ShipperID
													and ao.CustomerPart = alpqd.CustomerPart
													and ao.PackageType = alpqd.PackageType
													and ao.Quantity = alpqd.PackQty
												for xml path (''), type
										 	)
										from
											EDI_XML_STANLEY_ASN.ASNLinePackQtyDetails alpqd
										where
											alpqd.ShipperID = al.ShipperID
											and alpqd.CustomerPart = al.CustomerPart
										for xml path (''), type
									)	
								from
									EDI_XML_STANLEY_ASN.ASNLines al
								where
									al.ShipperID = @ShipperID
								order by
									al.RowNumber
				 				for xml raw ('LOOP-HL'), type
							)
						,	EDI_XML_V4010.SEG_CTT(1 + @ItemLoops, @TotalQuantity)
						from
							EDI_XML_STANLEY_ASN.ASNHeaders ah
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

select
	EDI_XML_STANLEY_ASN.udf_Root(107447, '00', 0)


select
	EDI_XML_STANLEY_ASN.udf_Root(107389, '00', 0)
