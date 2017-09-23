SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EDI_XML_LEAR_ASN].[ASNHeaders]
as
select
	ShipperID = s.id 
,	IConnectID = es.IConnectID
,	TradingPartner	= es.trading_partner_code
,	ASNDate = getdate()
,	ASNTime = getdate()
,	ShipDateTime = s.date_shipped
,	GrossWeightLbs = convert(int, s.gross_weight)
,	NetWeightLbs = convert(int, s.net_weight)
,	PackCount = s.staged_objs
,	SCAC = s.ship_via
,	TransMode = s.trans_mode
,	TrailerNumber = coalesce(s.truck_number, s.id)
,	REFBMValue =  coalesce(s.bill_of_lading_number, id)
,	ShipFromIDtype = case when datalength(es.supplier_code) =  9 then 1 else 92 end
,	ShipFromID = coalesce(es.supplier_code, '047380894')
,	ShipToID = COALESCE(es.parent_destination, es.destination)
,	FOB01 = case when freight_type =  'Collect' then 'CC' when freight_type in  ('Consignee Billing', 'Third Party Billing') then 'TP' when freight_type  in ('Prepaid-Billed', 'PREPAY AND ADD') then 'PA' when freight_type = 'Prepaid' then 'PP' else 'CC' end
from 
	dbo.shipper s
	join dbo.edi_setups es
		on es.destination = s.destination
GO
