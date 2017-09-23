SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE function [EDI_XML_VISTEON_LEGACY_ASN].[udf_Root]
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
	,	@TotalQuantity = sum(al.shipQty)
	from
		EDI_XML_VISTEON_LEGACY_ASN.ASNLines al
	where
		al.ShipperID = @ShipperID

	set
		@xmlOutput =
			(	select
					(	select
							EDI_XML.TRN_INFO('002002FORD', '856', ah.TradingPartnerID, ah.iConnectID, ah.ShipperID, @PartialComplete)
						,	EDI_XML_VISTEON_LEGACY_ASN.SEG_BSN(@Purpose, ah.ShipperID, ah.ASNDate, ah.ASNTime)
						,	EDI_XML_VISTEON_LEGACY_ASN.SEG_DTM('011', ah.ASNDate)
						,	(	select
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_VISTEON_LEGACY_ASN.SEG_HL(1, null, 'S')
								,	EDI_XML_VISTEON_LEGACY_ASN.SEG_MEA('PD', 'G', ah.GrossWeightLbs, 'LB')
								,	EDI_XML_VISTEON_LEGACY_ASN.SEG_MEA('PD', 'N', ah.NetWeightLbs, 'LB')
								,	EDI_XML_VISTEON_LEGACY_ASN.SEG_TD1(ah.PackageType, ah.LadingQty)
								,	EDI_XML_VISTEON_LEGACY_ASN.SEG_TD5('B', '02', ah.SCAC, ah.TransMode, ah.LocationQualifier, ah.PoolCode)
								,	EDI_XML_VISTEON_LEGACY_ASN.SEG_TD3('TL', ah.SCACPickUp, ah.TruckNumber)
								,	EDI_XML_VISTEON_LEGACY_ASN.SEG_REF('BM', ah.BOLNumber)
								,	CASE WHEN isNULL(ah.FreightBill,'') !='' THEN EDI_XML_VISTEON_LEGACY_ASN.SEG_REF(ah.FreightBillQual, ah.FreightBill) END
								,	CASE WHEN isNULL(ah.FreightBill,'') !='' THEN EDI_XML_VISTEON_LEGACY_ASN.SEG_REF('CN', ah.FreightBill ) ELSE EDI_XML_VISTEON_LEGACY_ASN.SEG_REF('CN', ah.ShipperID) END 
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_VISTEON_LEGACY_ASN.SEG_N1('ST', 92, ah.ShipTo)
						 				for xml raw ('LOOP-N1'), type
						 			)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_VISTEON_LEGACY_ASN.SEG_N1('SF', 92, ah.SupplierCode)
						 				for xml raw ('LOOP-N1'), type
						 			)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_VISTEON_LEGACY_ASN.SEG_N1('SU', 92, ah.SupplierCode)
						 				for xml raw ('LOOP-N1'), type
						 			)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_VISTEON_LEGACY_ASN.SEG_N1('IC', 92, ah.FordMotorCosignee)
						 				for xml raw ('LOOP-N1'), type
						 			)
				 				for xml raw ('LOOP-HL'), type
				 			)
						,	(	select
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_VISTEON_LEGACY_ASN.SEG_HL(1+al.RowNumber, 1, 'I')
								,	[EDI_XML_VISTEON_LEGACY_ASN].[SEG_LIN2]( al.customerPO,  'BP', al.CustomerPart) --Andre S. Boulanger 09/13/2017 - Found TP requires
								,	EDI_XML_VISTEON_LEGACY_ASN.SN1(null, al.ShipQty, 'EA', al.AccumQty)
								,	EDI_XML_VISTEON_LEGACY_ASN.SEG_PRF(al.CustomerPO)
								,	EDI_XML_VISTEON_LEGACY_ASN.SEG_REF('PK', ah.ShipperID)
									--CLD Loop
								,	(	select
											EDI_XML.LOOP_INFO('CLD')
										,	EDI_XML_VISTEON_LEGACY_ASN.SEG_CLD(alpqd.PackCount, alpqd.PackQty, ah.PackageType)
										,	EDI_XML_VISTEON_LEGACY_ASN.udf_OrderSerials(ah.ShipperID, al.CustomerPart,  alpqd.PackQty)
										from
											EDI_XML_VISTEON_LEGACY_ASN.ASNLinePackQtyDetails alpqd
										where
											alpqd.ShipperID = al.ShipperID
											and alpqd.CustomerPart = al.CustomerPart
										for xml raw ('LOOP-CLD'), type
									)	
								from
									EDI_XML_VISTEON_LEGACY_ASN.ASNLines al
								where
									al.ShipperID = @ShipperID
								order by
									al.RowNumber
				 				for xml raw ('LOOP-HL'), type
							)
						,	EDI_XML_VISTEON_LEGACY_ASN.SEG_CTT(1 + @ItemLoops, @TotalQuantity)
						from
							EDI_XML_VISTEON_LEGACY_ASN.ASNHeaders ah
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
