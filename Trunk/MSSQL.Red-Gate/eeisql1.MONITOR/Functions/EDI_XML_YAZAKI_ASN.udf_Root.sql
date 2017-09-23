SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE function [EDI_XML_YAZAKI_ASN].[udf_Root]
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
		EDI_XML_YAZAKI_ASN.ASNLines al
	where
		al.ShipperID = @ShipperID

	set
		@xmlOutput =
			(	select
					(	select
							EDI_XML.TRN_INFO('005050', '856', ah.TradingPartner, ah.IConnectID, ah.ShipperID, @PartialComplete)
						,	EDI_XML_V4010.SEG_BSN(@Purpose, ah.ShipperID, ah.ASNDate, ah.ASNTime)
						,	EDI_XML_V4010.SEG_DTM('011', ah.ShipDateTime, ah.TimeZoneCode)
						,	EDI_XML_V4010.SEG_DTM('017', ah.ArrivalDateTime, ah.TimeZoneCode)
						,	(	select
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(1, null, 'S', null)
								,	EDI_XML_V4010.SEG_MEA('PD', 'G', EDI_XML_YAZAKI_ASN.udf_GetShipperWeight(@ShipperID, 'G'), 'LB')--needs GrossWeightLbs
								,	EDI_XML_V4010.SEG_MEA('PD', 'N', EDI_XML_YAZAKI_ASN.udf_GetShipperWeight(@ShipperID, 'N'), 'LB')								
								,	EDI_XML_V4010.SEG_MEA('PD', 'T', EDI_XML_YAZAKI_ASN.udf_GetShipperWeight(@ShipperID, 'T'), 'LB')--needs TareWeightLbs
								,	EDI_XML_V4010.SEG_MEA('PD', 'VOL', '4', 'CF')
								,	EDI_XML_V4010.SEG_TD1('CTN90', ah.PackCount)
								,	EDI_XML_V4010.SEG_TD5('B', '2', ah.SCAC, ah.TransMode, null, null)
								,	EDI_XML_V4010.SEG_REF('BM', ah.REFBMValue)
								,	EDI_XML_YAZAKI_ASN.SEG_FOB(ah.PaymentMethod, 'CA', 'US', '01', ah.TransCode, 'AC', 'TROY, MICHIGAN')
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_YAZAKI_ASN.SEG_N1('SF', 92, ah.SupplierCode, 'Empire')
						 				for xml raw ('LOOP-N1'), type
						 			)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_YAZAKI_ASN.SEG_N1('ST', 92, ah.ShipToID, ah.ShipToName)
						 				for xml raw ('LOOP-N1'), type
						 			)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_YAZAKI_ASN.SEG_N1('RI', 92, ah.SupplierCode, ah.DockCode)
						 				for xml raw ('LOOP-N1'), type
									)
								from
									EDI_XML_YAZAKI_ASN.ASNHeaders ah
								where
									ah.ShipperID = @ShipperID
								for xml raw ('LOOP-HL'), type
							)
						,	(	select
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(2, 1, 'E', null)
								,	(	select
						 					EDI_XML.LOOP_INFO('TD3')
										,	EDI_XML_YAZAKI_ASN.SEG_TD3('TL', ah.EquipmentIntial, ah.EquipmentNumber, 'G', EDI_XML_YAZAKI_ASN.udf_GetShipperWeight(@ShipperID, 'G'), 'LB', null, null, ah.SealNumber, 'LTRL')--needs GrossWeightLbs
						 				for xml raw ('LOOP-TD3'), type
						 			)
								from
									EDI_XML_YAZAKI_ASN.ASNHeaders ah
								where
									ah.ShipperID = @ShipperID
								for xml raw ('LOOP-HL'), type
							)
							,	EDI_XML_V4010.SEG_HL(3, 2, 'T', null)
						,	(	select
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(3+al.RowNumber, 3, 'I', null)
								,	EDI_XML_YAZAKI_ASN.SEG_LIN(null, 'BP', al.CustomerPart, 'VP', al.VendorPart, 'PD', al.PartDescription, 'PO', al.CustomerPO)
								,	EDI_XML_V4010.SEG_SN1(null, al.QtyPacked, 'PC', null)
								,	EDI_XML_YAZAKI_ASN.SEG_SLN('001', 'I', al.Price, 'PE')
								,	EDI_XML_V4010.SEG_REF('IV', al.ShipperID)
								,	EDI_XML_V4010.SEG_REF('PK', al.ShipperID)
								,	(	select
						 					EDI_XML.LOOP_INFO('CLD')
										,	EDI_XML_YAZAKI_ASN.SEG_CLD(alpqd.LoadCount, alpqd.PackQty, 'CTN90', '6', 'LB')
										,	EDI_XML_YAZAKI_ASN.udf_OrderSerials(ah.ShipperID, al.CustomerPart)
										,	EDI_XML_YAZAKI_ASN.SEG_DTM('003', ah.ShipDateTime, null)
										from
											EDI_XML_YAZAKI_ASN.ASNLinePackQtyDetails alpqd
										where
											alpqd.ShipperID = @ShipperID
											and alpqd.CustomerPart = al.CustomerPart
						 				for xml raw ('LOOP-CLD'), type
									)
								from
									EDI_XML_YAZAKI_ASN.ASNLines al
								where
									al.ShipperID = @ShipperID
								order by
									al.RowNumber
				 				for xml raw ('LOOP-HL'), type
							)
						,	EDI_XML_V4010.SEG_CTT(2 + @ItemLoops, @TotalQuantity)
						from
							EDI_XML_YAZAKI_ASN.ASNHeaders ah
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
