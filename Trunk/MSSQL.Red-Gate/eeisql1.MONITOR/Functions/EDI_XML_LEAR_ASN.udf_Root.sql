SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [EDI_XML_LEAR_ASN].[udf_Root]
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
		@al table
	(	ShipperID int
	,	CustomerPart varchar(30)
	,	CustomerPO varchar(25)
	,	VendorPart varchar(25)
	,	QtyPacked int
	,	PackCount int
	,	AccumShipped int
	,	RowNumber int
	)

	insert
		@al
	select
		ShipperID = s.id
	,	CustomerPart = sd.customer_part
	,	CustomerPO = max(sd.customer_po)
	,	VendorPart = at.part
	,	QtyPacked = max(convert(int, sd.alternative_qty))
	,	PackCount = count(distinct at.parent_serial)
	,	AccumShipped = max(convert(int, sd.accum_shipped))
	,	RowNumber = row_number() over (partition by s.id order by sd.customer_part)
	from
		dbo.shipper s
		join dbo.shipper_detail sd
			on sd.shipper = s.id
		join dbo.audit_trail at
			on at.type ='S'
			and at.shipper = convert(varchar, (sd.shipper))
			and at.part = sd.part
	where
		coalesce(s.type, 'N') in ('N', 'M')
		and s.id = @ShipperID
	group by
		s.id	
	,	sd.customer_part
	,	sd.customer_po
	,	at.std_quantity
	,	at.part

	declare
		@ItemLoops int
	,	@TotalQuantity int

	select
		@ItemLoops = max(al.RowNumber)
	,	@TotalQuantity = sum(al.QtyPacked)
	from
		@al al
	where
		al.ShipperID = @ShipperID

	set
		@xmlOutput =
			(	select
					(	select
							EDI_XML.TRN_INFO('002040', '856', ah.TradingPartner, ah.IConnectID, ah.ShipperID, @PartialComplete)
						,	EDI_XML_V4010.SEG_BSN(@Purpose, ah.ShipperID, ah.ASNDate, ah.ASNTime)
						,	EDI_XML_V4010.SEG_DTM('011', ah.ShipDateTime, null)
						,	(	select
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(1, null, 'S', null)
								,	EDI_XML_V4010.SEG_MEA('PD', 'G', ah.GrossWeightLbs, 'LB')
								,	EDI_XML_V4010.SEG_MEA('PD', 'N', ah.NetWeightLbs, 'LB')
								,	EDI_XML_V4010.SEG_TD1('CTN25', ah.PackCount)
								,	EDI_XML_V4010.SEG_TD5('B', '02', ah.SCAC, 'TL', null, null)
								,	EDI_XML_V4010.SEG_TD3(ah.TransMode, null, ah.TrailerNumber)
								,	EDI_XML_V4010.SEG_REF('BM', ah.REFBMValue)
								,	EDI_XML_V4010.SEG_REF('PK', ah.ShipperID)
								,	EDI_XML_LEAR_ASN.SEG_FOB(ah.FOB01)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_LEAR_ASN.SEG_N1('ST', 'ST', ah.ShipToID, null)
						 				for xml raw ('LOOP-N1'), type
						 			)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_LEAR_ASN.SEG_N1('SF', ah.ShipFromIDType, ah.ShipFromID, null)
						 				for xml raw ('LOOP-N1'), type
						 			)
				 				for xml raw ('LOOP-HL'), type
				 			)
						,	(	select
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(1+al.RowNumber, 1, 'I', null)
								,	EDI_XML_V4010.SEG_LIN(null, 'BP', al.CustomerPart, 'VP', al.VendorPart)
								,	EDI_XML_V4010.SEG_SN1(null, al.QtyPacked, 'EA', al.AccumShipped)
								,	EDI_XML_V4010.SEG_PRF(al.CustomerPO)
									--CLD Loop
								,	(	select
											EDI_XML.LOOP_INFO('CLD')
										,	EDI_XML_V4010.SEG_CLD(alpqd.PackCount, alpqd.PackQty, 'CTN90')
										from
											EDI_XML_PLEX_ASN.ASNLinePackQtyDetails alpqd
										where
											alpqd.ShipperID = al.ShipperID
											and alpqd.CustomerPart = al.CustomerPart
										for xml raw ('LOOP-CLD'), type
									)	
								from
									@al al
								where
									al.ShipperID = @ShipperID
								order by
									al.RowNumber
				 				for xml raw ('LOOP-HL'), type
								)
						,	EDI_XML_V4010.SEG_CTT(1 + @ItemLoops, @TotalQuantity)
						from
							EDI_XML_LEAR_ASN.ASNHeaders ah
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
