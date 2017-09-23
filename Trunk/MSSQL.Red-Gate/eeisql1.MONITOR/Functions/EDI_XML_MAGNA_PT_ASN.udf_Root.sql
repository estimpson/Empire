SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE function [EDI_XML_MAGNA_PT_ASN].[udf_Root]
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
		EDI_XML_MAGNA_PT_ASN.ASNLines al
	where
		al.ShipperID = @ShipperID

	set
		@xmlOutput =
			(	select
					(	select
							EDI_XML.TRN_INFO('003060AIAG', '856', ah.TradingPartner, ah.IConnectID, ah.ShipperID, @PartialComplete)
						,	EDI_XML_V4010.SEG_BSN(@Purpose, ah.ShipperID, ah.ASNDate, ah.ASNTime)
						,	EDI_XML_V4010.SEG_DTM('011', ah.ShipDateTime, ah.TimeZone)
						,	(	select
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(1, null, 'S', null)
								,	EDI_XML_V4010.SEG_MEA('PD', 'G', ah.GrossWeightLbs, 'LB')
								,	EDI_XML_V4010.SEG_MEA('PD', 'N', ah.NetWeightLbs, 'LB')
								,	EDI_XML_V4010.SEG_TD1('CTN90', ah.PackCount)
								,	EDI_XML_V4010.SEG_TD5('B', '2', ah.SCAC, ah.TransMode, null, null)
								,	(	select 
											EDI_XML.LOOP_INFO('TD3')
										,	EDI_XML_V4010.SEG_TD3(ah.EquipDesc, ah.EquipInitial, ah.TrailerNumber)
										for xml raw ('LOOP-TD3'), type
									)
								,	EDI_XML_V4010.SEG_REF('PK', ah.ShipperID)
								,	EDI_XML_V4010.SEG_REF('BM', ah.rEFBMValue)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_MAGNA_PT_ASN.SEG_N1('SU', 92, ah.SupplierCode, 'Empire Electronics, Inc.')
						 				for xml raw ('LOOP-N1'), type
						 			)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_MAGNA_PT_ASN.SEG_N1('ST', 92, ah.ShipToID, ah.ShipToName)
						 				for xml raw ('LOOP-N1'), type
						 			)
				 				for xml raw ('LOOP-HL'), type
				 			)
						,	(	select
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(1+al.RowNumber, 1, 'O', null)
								,	EDI_XML_V4010.SEG_LIN(null, 'BP', al.CustomerPart, null, null)
								,	EDI_XML_V4010.SEG_SN1(null, al.QtyPacked, 'EA', al.AccumShipped)
								,	EDI_XML_V4010.SEG_PRF(al.CustomerPO)
								from
									EDI_XML_MAGNA_PT_ASN.ASNLines al
								where
									al.ShipperID = @ShipperID
								order by
									al.RowNumber
				 				for xml raw ('LOOP-HL'), type
								)
						,	(	select
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(2+al.RowNumber, 2, 'I', null)
								,	(	select
				 							EDI_XML.LOOP_INFO('CLD')
										,	EDI_XML_V4010.SEG_CLD(alpqd.ContainerCount, alpqd.PackQty, 'CTN90')
										,	EDI_XML_MAGNA_PT_ASN.udf_OrderSerials(ah.ShipperID, al.CustomerPart)
										from
											EDI_XML_MAGNA_PT_ASN.ASNLinePackQuantityDetail alpqd
										where
											alpqd.ShipperID = @ShipperID
				 						for xml raw ('LOOP-CLD'), type
										)
								from
									EDI_XML_MAGNA_PT_ASN.ASNLines al
								where
									al.ShipperID = @ShipperID
								order by
									al.RowNumber
				 				for xml raw ('LOOP-HL'), type
								)
						,	EDI_XML_V4010.SEG_CTT(2 + @ItemLoops, @TotalQuantity)
						from
							EDI_XML_MAGNA_PT_ASN.ASNHeaders ah
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
