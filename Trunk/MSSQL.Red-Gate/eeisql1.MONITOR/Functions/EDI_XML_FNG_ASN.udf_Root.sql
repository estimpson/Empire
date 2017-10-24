SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--Select [EDI_XML_FNG_ASN].[udf_Root]
--(	102607
--,	'00'
--,	1
--) 
CREATE function [EDI_XML_FNG_ASN].[udf_Root]
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
		EDI_XML_FNG_ASN.ASNLines al
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
								,	EDI_XML_V4010.SEG_TD1('CTN25', ah.PackCount)
								,	EDI_XML_V4010.SEG_TD5('B', '2', ah.Carrier, ah.TransMode, null, null)
								,	EDI_XML_V4010.SEG_TD3(ah.EquipDesc, ah.EquipInitial, ah.TrailerNumber)
								,	EDI_XML_V4010.SEG_REF('BM', ah.REFBMValue)
								,	EDI_XML_V4010.SEG_REF('PK', ah.REFPKValue)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_FNG_ASN.SEG_N1('ST', '1', ah.ShipToID, ah.ShipToName)
						 				for xml raw ('LOOP-N1'), type
						 			)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_FNG_ASN.SEG_N1('SU', '1', ah.SupplierCode, ah.SupplierName)
						 				for xml raw ('LOOP-N1'), type
						 			)
				 				for xml raw ('LOOP-HL'), type
				 			)
						,	(	select
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(1+al.RowNumber, 1, 'O', null)
								,	EDI_XML_V4010.SEG_LIN(null, 'BP', al.CustomerPart, 'EC', al.CustomerECL)
								,	EDI_XML_FNG_ASN.SEG_SN1('004010', null, al.QtyPacked, 'EA', al.AccumShipped, 'EA')
								,	EDI_XML_V4010.SEG_PRF(al.CustomerPO)
								--CLD Loop
								,	(	select
											EDI_XML.LOOP_INFO('CLD')
										,	EDI_XML_V4010.SEG_CLD(alpqd.PackCount, alpqd.PackQty, alpqd.PackageType)
										,	EDI_XML_FNG_ASN.udf_OrderSerials(alpqd.ShipperID, alpqd.CustomerPart, alpqd.PackageType, alpqd.PackQty)
										from
											EDI_XML_FNG_ASN.ASNLinePackQtyDetails alpqd
										where
											alpqd.ShipperID = al.ShipperID
											and alpqd.CustomerPart = al.CustomerPart
										for xml raw ('LOOP-CLD'), type
									)	
								from
									EDI_XML_FNG_ASN.ASNLines al
								where
									al.ShipperID = @ShipperID
								order by
									al.RowNumber
				 				for xml raw ('LOOP-HL'), type
							)
						,	EDI_XML_V4010.SEG_CTT(1 + @ItemLoops, @TotalQuantity)
						from
							EDI_XML_FNG_ASN.ASNHeaders ah
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
