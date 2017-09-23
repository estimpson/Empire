SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [EDI_XML_NORPLAS_ASN].[ASNHeaders]
as
select
	ShipperID = s.id
,	IConnectID = es.IConnectID
,	ShipDateTime = s.date_shipped
,	ASNDate = getdate()
,	ASNTime = getdate()
,	TimeZoneCode = [dbo].[udfGetDSTIndication](getdate())
,	TradingPartner	= coalesce(nullif(trading_partner_code,''), 'Formet Testing')
,	ShipToCode = es.parent_destination
,	ShipToID = coalesce(es.parent_destination, '966850612')
,	ShipToName = d.name
,	SupplierCode = coalesce(nullif(es.supplier_code,''),'2485858130')
,	MaterialIssuerCode = coalesce(es.material_issuer,'966850612')
,	PackCount = s.staged_objs
,	GrossWeight = convert(int, round(coalesce(nullif(s.gross_weight,0),(s.staged_objs*1.1)+1), 0))
,	NetWeight =  convert(int, round(coalesce(nullif(s.net_weight,0),s.staged_objs), 0))
,	Carrier = s.ship_via
,	TrailerNumber = coalesce( nullif(s.truck_number,''), convert(varchar(max),s.id))
,	TransMode = s.trans_mode
,	PackingListNumber = s.id
,	REFBMValue = coalesce(s.bill_of_lading_number, id)
,	REFPKValue = s.id


from
	dbo.shipper s
	join dbo.edi_setups es
		on s.destination = es.destination
	join dbo.destination d
		on s.destination = d.destination
	left join dbo.bill_of_lading bol
		on s.bill_of_lading_number = bol_number

GO
