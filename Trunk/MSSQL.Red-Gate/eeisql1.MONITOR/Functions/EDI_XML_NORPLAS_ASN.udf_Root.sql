SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [EDI_XML_NORPLAS_ASN].[udf_Root]
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
		EDI_XML_NORPLAS_ASN.ASNLines al
	where
		al.ShipperID = @ShipperID
		
	declare
		@ItemsPack table
	(	ShipperID int
	,	CustomerPart varchar(35)
	,	PackType varchar(25)
	,	PackCount int
	,	PackQty int
	,	RowType varchar(1)
	,	RowID int identity(2, 1)
	)

	insert
		@ItemsPack
	(	ShipperID
	,	CustomerPart
	,	PackType
	,	PackCount
	,	PackQty
	,	RowType
	)
	select
		ShipperID
	,	CustomerPart
	,	''
	,	0
	,	0
	,	'i'
	from
		EDI_XML_NORPLAS_ASN.ASNLines al
	where
		ShipperID = @ShipperID
	union all
	select
		ShipperID
	,	CustomerPart
	,	PackType
	,	PackCount
	,	PackQty
	,	'p'
	from
		EDI_XML_NORPLAS_ASN.udf_ASNLinePackQtyDetails(@ShipperID) alpqd
	order by
		2
	,	5

	set
		@xmlOutput =
			(	select
					(	select
							EDI_XML.TRN_INFO('004010', '856', ah.TradingPartner, ah.IConnectID, ah.ShipperID, @partialComplete)
						,	EDI_XML_V4010.SEG_BSN(@Purpose, ah.ShipperID, ah.ASNDate, ah.ASNTime)
						,	EDI_XML_V4010.SEG_DTM('011', ah.ShipDateTime, null)
						,	(	select
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(1, null, 'S', null)
								,	EDI_XML_V4010.SEG_MEA('PD', 'G', ah.GrossWeight, 'LB')
								,	EDI_XML_V4010.SEG_MEA('PD', 'N', ah.NetWeight, 'LB')
								,	EDI_XML_V4010.SEG_TD1('CTN90', ah.PackCount)
								,	EDI_XML_V4010.SEG_TD5('B', '2', ah.Carrier, ah.TransMode, null, null)
								,	EDI_XML_V4010.SEG_TD3('TL', null, ah.TrailerNumber)
								,	EDI_XML_V4010.SEG_REF('BM', ah.REFBMValue)
								,	EDI_XML_V4010.SEG_REF('PK', ah.REFPKValue)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_NORPLAS_ASN.SEG_N1('MI', '92', ah.MaterialIssuerCode, 'NORPLAS INDUSTRIES INC.')
						 				for xml raw ('LOOP-N1'), type
						 			)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_NORPLAS_ASN.SEG_N1('SU', '92', ah.SupplierCode, 'EMPIRE ELECTRONICS, INC.')
						 				for xml raw ('LOOP-N1'), type
						 			)
								,	(	select
						 					EDI_XML.LOOP_INFO('N1')
										,	EDI_XML_NORPLAS_ASN.SEG_N1('ST', '92', ah.ShipToID, ah.ShipToName)
						 				for xml raw ('LOOP-N1'), type
						 			)
				 				for xml raw ('LOOP-HL'), type
				 			)
							--HL Order Loop
						,	(	select
				 					EDI_XML.LOOP_INFO('HL')
								,	EDI_XML_V4010.SEG_HL(ItemLevel.RowID, 1, 'O', null)
								,	EDI_XML_V4010.SEG_LIN(null, 'BP', al.CustomerPart, null, null)
								,	EDI_XML_V4010.SEG_SN1(null, al.QtyPacked, 'EA', al.AccumShipped)
								,	EDI_XML_V4010.SEG_PRF(al.CustomerPO)
								-- HL Item (CLD and Box Serials)
								,	(	select
				 							EDI_XML.LOOP_INFO('HL')
										,	EDI_XML_V4010.SEG_HL(PackLevel.RowID, ItemLevelPack.RowID, 'I', null)
										,	EDI_XML_V4010.SEG_CLD(PackLevel.PackCount, PackLevel.PackQty, PackLevel.PackType)
										,	EDI_XML_NORPLAS_ASN.udf_OrderSerials(ah.ShipperID, al.CustomerPart, PackLevel.PackType, PackLevel.PackQty)								
										from
											@ItemsPack PackLevel
											outer apply
												(	select top 1
														IP.RowID
													from
														@ItemsPack IP
													where
														IP.ShipperID = @ShipperID
														and IP.CustomerPart = PackLevel.CustomerPart 
														and IP.rowType = 'i'
												) ItemLevelPack
										where
											PackLevel.ShipperID = @ShipperID
											and PackLevel.rowType = 'p'
										for xml raw ('LOOP-HL'), type
									)
								from
									EDI_XML_NORPLAS_ASN.ASNLines al
									outer apply
										(	select top 1
												IP.RowID
											from
												@ItemsPack IP
											where
												IP.ShipperID = @ShipperID
												and IP.CustomerPart = al.CustomerPart
												and IP.rowType = 'i'
										) ItemLevel
								where
									al.ShipperID = @ShipperID
								order by
									al.RowNumber
				 				for xml raw ('LOOP-HL'), type
							)
						--Item (CLD) Loop
						,	EDI_XML_V4010.SEG_CTT( ItempackCount.maxRowID, @TotalQuantity)
						from
							EDI_XML_NORPLAS_ASN.ASNHeaders ah
							cross apply
								(	select
										max(RowID) maxRowID
									from
										@ItemsPack
								) as ItempackCount
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
