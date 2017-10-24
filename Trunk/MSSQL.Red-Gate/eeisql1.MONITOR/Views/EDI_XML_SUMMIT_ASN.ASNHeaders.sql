SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE view [EDI_XML_SUMMIT_ASN].[ASNHeaders]
as

-- Select * from [EDI_XML_SUMMIT_ASN].[ASNHeaders]  where shipperID = 102536
select
	ShipperID = s.id
,	IConnectID = es.IConnectID
,	ASNDate = getdate()
,	ASNTime = getdate()
,	ArrivalDate = dateadd(dd,1,s.date_shipped)
,	ShipDateTime = s.date_shipped
,	TradingPartner	= es.trading_partner_code
,	GrossWeightLbs = convert(int,s.gross_weight)
,	NetWeightLbs = convert(int,s.net_weight)
,	ReferenceN = coalesce(s.bill_of_lading_number, s.id)
,	MaterialIssuerID = coalesce(es.material_issuer,'')
,	SupplierCode = coalesce(es.supplier_code, '00005981')
,	ShipToID = coalesce(nullif(es.parent_destination,''),es.destination)
,	TransMode = s.trans_mode
,	SCAC = s.ship_via
,	TrailerNumber = coalesce(nullif(s.truck_number,''), convert(varchar(25),s.id))
,	CarrierName = LEFT(coalesce(nullif(Carriers.name,''), s.ship_via),35)
from
	dbo.shipper s 
	join dbo.edi_setups es
		on es.destination = s.destination
	outer apply ( select top 1 name from  carrier where scac = s.ship_via ) Carriers --using outer apply becuase SCACs can be duplicated in Carrier Table
		


GO
