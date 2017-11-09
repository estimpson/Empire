SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [EDI_XML_DELPHI_ASN].[udf_Root]
(	@ShipperID int
,	@Purpose char(2)
,	@partialComplete int
)
returns xml
as
begin
--- <Body>
	declare
		@al table
	(	ShipperID int
	,	PackageType varchar(25)
	,	DockCode varchar(15)
	,	CustomerPart varchar(30)
	,	CustomerPO varchar(25)
	,	StorageLocation varchar(35)
	,	QtyShipped int
	,	AccumShipped int
	,	RowNumber int
	,	CustomerECL varchar(35)
	)

	insert
		@al
	select
		ShipperID = s.id
	,	PackageType = coalesce(pm.name,'CTN90')
	,	DockCode = max(s.shipping_dock)
	,	CustomerPart = sd.customer_part
	,	CustomerPO = max(sd.customer_po)
	,	StorageLocation = coalesce(oh.line11,'0001')
	,	QtyShipped = convert(int, max(sd.qty_packed))
	,	AccumShipped = convert(int, max(sd.accum_shipped))
	,	RowNumber = row_number() over (partition by s.id order by sd.customer_part)
	,	CustomerECL = max(coalesce(oh.engineering_level, oh.customer_part,''))
	from
		dbo.shipper s
		join dbo.shipper_detail sd
			on sd.shipper = s.id
		join dbo.audit_trail at
			on at.type ='S'
			and at.shipper = convert(varchar, sd.shipper)
			and at.part = sd.part
		join dbo.order_header oh
			on oh.order_no = sd.order_no
		join dbo.edi_setups es
			on es.destination = s.destination
		left join dbo.package_materials pm 
			on pm.type = s.type
	where
		coalesce(s.type, 'N') in ('N', 'M')
		and s.id = @ShipperID
	group by
		s.id
	,	sd.customer_part
	,	at.package_type
	,	at.parent_serial
	,	oh.line11
	,	pm.name

	declare
		@xmlOutput xml

	set
		@xmlOutput =
			(	select
					(	select
							EDI_XML.TRN_INFO('00D97A', 'DESADV', ah.TradingPartner, ah.IConnectID, ah.ShipperID, null)
						,	EDI_XML_VD97A.SEG_BGM(null, 'DESADV', ah.ShipperID, '9')
						,	EDI_XML_VD97A.SEG_DTM('137', ah.ASNDate, '203')
						,	EDI_XML_VD97A.SEG_DTM('11', ah.ShipDateTime, '203')
						,	EDI_XML_VD97A.SEG_DTM('132', ah.ArrivalDate, '203')
						,	EDI_XML_VD97A.SEG_MEA('AAX', 'G', 'LBR', ah.GrossWeightLbs)
						,	EDI_XML_VD97A.SEG_MEA('AAX', 'N', 'LBR', ah.NetWeightLbs)
						,	EDI_XML_VD97A.SEG_MEA('AAX', 'SQ', 'C62', ah.LadingQty)
						,	(	select
						 			EDI_XML.LOOP_INFO('RFF')
								,	EDI_XML_VD97A.SEG_RFF('CN', ah.REFCNValue)
						 		for xml raw ('LOOP-RFF'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('RFF')
								,	EDI_XML_VD97A.SEG_RFF('COF', ah.REFCOFValue)
						 		for xml raw ('LOOP-RFF'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('NAD')
								,	EDI_XML_VD97A.SEG_NAD('MI', ah.MaterialIssuerID, null, '16')
						 		for xml raw ('LOOP-NAD'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('NAD')
								,	EDI_XML_VD97A.SEG_NAD('ST', ah.ShipToID, null, '92')
								,	EDI_XML_VD97A.SEG_LOC('11', ah.ShipToID2)
						 		for xml raw ('LOOP-NAD'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('NAD')
								,	EDI_XML_VD97A.SEG_NAD('SU', ah.SupplierCode, null, '16')
						 		for xml raw ('LOOP-NAD'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('NAD')
								,	EDI_XML_VD97A.SEG_NAD('SF', ah.SupplierCode2, null, '16')
						 		for xml raw ('LOOP-NAD'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('TDT')
								,	EDI_XML_DELPHI_ASN.SEG_TDT('12', null, ah.TransMode, ah.SCAC, null, '182')
						 		for xml raw ('LOOP-TDT'), type
						 	)
						,	(	select
						 			EDI_XML.LOOP_INFO('EQD')
								,	EDI_XML_VD97A.SEG_EQD('TL', ah.TrailerNumber)
						 		for xml raw ('LOOP-EQD'), type
						 	)
							--CPS Loop
						,	(	select
						 			EDI_XML.LOOP_INFO('CPS')
								,	EDI_XML_VD97A.SEG_CPS(al.RowNumber, null, '4')
								--PAC Loop
								,	(	select
						 					EDI_XML.LOOP_INFO('PAC')
										,	EDI_XML_VD97A.SEG_PAC('1', al.PackageType)
										,	EDI_XML_VD97A.SEG_QTY('52', al.QtyShipped, 'C62')
										--PCI Loop
										,	(	select
						 							EDI_XML.LOOP_INFO('PCI')
												,	EDI_XML_DELPHI_ASN.SEG_PCI('16', al.StorageLocation)
												,	EDI_XML_DELPHI_ASN.SEG_GIR('3', '0000000', 'AL')
						 						for xml raw ('LOOP-PCI'), type
						 					)
						 				for xml raw ('LOOP-PAC'), type
						 			)
								--LIN Loop
								,	(	select
						 					EDI_XML.LOOP_INFO('LIN')
										,	EDI_XML_VD97A.SEG_LIN(al.RowNumber, null, al.CustomerPart, 'IN')
										,	EDI_XML_DELPHI_ASN.SEG_PIA('1', '0', 'RY', al.CustomerECL, 'EC')
										,	EDI_XML_VD97A.SEG_QTY('3', al.AccumShipped, 'C62')
										,	EDI_XML_VD97A.SEG_QTY('12', al.QtyShipped, 'C62')
										
										--RFF Loop
										,	(	select
						 							EDI_XML.LOOP_INFO('RFF')
												,	EDI_XML_VD97A.SEG_RFF('ON', al.CustomerPO)
						 						for xml raw ('LOOP-RFF'), type
						 					)
						 				for xml raw ('LOOP-LIN'), type
						 			)
								from
									EDI_XML_DELPHI_ASN.ASNLines al
								where
									al.ShipperID = @ShipperID
						 		for xml raw ('LOOP-CPS'), type
						 	)
						from
							EDI_XML_DELPHI_ASN.ASNHeaders ah
						where
							ah.ShipperID = @ShipperID
						for xml raw ('TRN-DESADV'), type
					)
				for xml raw ('TRN'), type
			)
--- </Body>

---	<Return>
	return
		@xmlOutput
end

GO
