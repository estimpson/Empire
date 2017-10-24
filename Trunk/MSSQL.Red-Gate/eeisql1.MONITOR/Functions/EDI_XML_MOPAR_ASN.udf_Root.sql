SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [EDI_XML_MOPAR_ASN].[udf_Root]
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

	select
		@ItemLoops = max(al.RowNumber)
	from
		EDI_XML_MOPAR_ASN.ASNLines al
	where
		al.ShipperID = @ShipperID

	set
		@xmlOutput =
			(	select
					(	select
							EDI_XML.TRN_INFO('002040', '856', ah.TradingPartner, ah.iConnectID, @ShipperID, @PartialComplete)
						,	EDI_XML_V4010.SEG_BSN(@Purpose, ah.ShipperID, ah.ASNDate, ah.ASNTime)
						,	EDI_XML_V4010.SEG_DTM('011', ah.ShipDateTime, ah.DSTIndicator)
						,	(	select
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(1, null, 'S', null)
								,	EDI_XML_V4010.SEG_MEA(null, 'G', ah.GrossWeightLbs, 'LB')
								,	EDI_XML_V4010.SEG_MEA(null, 'N', ah.NetWeightLbs, 'LB')
								,	EDI_XML_V4010.SEG_TD1('CTN90', ah.LadingQty)
								,	EDI_XML_V4010.SEG_TD5('B', '2', ah.SCACTransfer, ah.TransMode, null, null)
								,	EDI_XML_V4010.SEG_TD3('TL', null, ah.TruckNo)
								,	EDI_XML_V4010.SEG_REF('BM', ah.SealNo)
								,	EDI_XML_V4010.SEG_REF('PK', ah.SealNo)
								,	EDI_XML_V4010.SEG_REF('FR', ah.FreightBill)
								,	EDI_XML_V4010.SEG_REF('SN', ah.SealNo)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_V4010.SEG_N1('SU', 92, ah.SupplierCode)
						 				for xml raw ('LOOP-N1'), type
						 			)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_V4010.SEG_N1('SF', 92, ah.SupplierCode)
						 				for xml raw ('LOOP-N1'), type
						 			)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_V4010.SEG_N1('ST', 92, ah.ParentDestination)
						 				for xml raw ('LOOP-N1'), type
						 			)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_V4010.SEG_N1('MA', 92, ah.ParentDestination)
						 				for xml raw ('LOOP-N1'), type
						 			)
				 				for xml raw ('LOOP-HL'), type
				 			)
						,	(	select
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(1+al.RowNumber, 1, 'O', null)
								,	EDI_XML_V4010.SEG_LIN(null, 'BP', al.CustomerPart, null, null)
								,	EDI_XML_V4010.SEG_PRF(al.CustomerPO)
								,	EDI_XML_V4010.SEG_SN1(null, al.QtyPacked, 'EA', al.AccumShipped)
								,	EDI_XML_V4010.SEG_REF('PK', ah.ShipperID)
								from
									EDI_XML_MOPAR_ASN.ASNLines al
								where
									al.ShipperID = @ShipperID
								order by
									al.RowNumber
				 				for xml raw ('LOOP-HL'), type
							)
						,	EDI_XML_V4010.SEG_CTT(1 + @ItemLoops, null)
						from
							EDI_XML_MOPAR_ASN.ASNHeaders ah
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
