SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EDI_XML_YAZAKI_ASN].[ASNHeaders]
as
select
	ShipperID = s.id 
,	IConnectID = es.IConnectID
,	TradingPartner = coalesce(es.trading_partner_code, 'YazakiTest')
,	ASNDate = getdate()
,	ASNTime = getdate()
,	ShipDateTime = s.date_shipped
,	ArrivalDateTime = dateadd(dd,1, s.date_shipped)
,	TimeZoneCode = [dbo].[udfGetDSTIndication](s.date_shipped)
,	NetWeightLbs = convert(char,s.staged_objs*6)
,	PackCount = s.staged_objs
,	SCAC = s.ship_via 
,	TransMode = coalesce(case when s.trans_mode like '%E%' then 'E' else 'LT' end,  s.trans_mode,'M')
,	REFBMValue = coalesce(s.bill_of_lading_number, id) 
,	PaymentMethod = case when s.freight_type =  'Collect' then 'CC' when s.freight_type in  ('Consignee Billing', 'Third Party Billing') then 'TP' when s.freight_type  in ('Prepaid-Billed', 'PREPAY AND ADD') then 'PA' when s.freight_type = 'Prepaid' then 'PP' else '' end
,	TransCode = case when 1=1 then 'FOB' when s.freight_type like '%[*]%' then substring(s.freight_type, patindex('%[*]%',s.freight_type)+1, 3) else s.freight_type end
,	SupplierCode = coalesce(es.supplier_code, 'Empire')
,	ShipToID = coalesce(es.EDIShipToID, es.parent_destination, es.destination)
,	ShipToName =  d.name
,	DockCode = coalesce(s.shipping_dock,'')
,	EquipmentIntial = left(coalesce('001', s.truck_number, convert(varchar(25),s.id)),3)
,	EquipmentNumber = coalesce('001', s.truck_number, convert(VARCHAR(25),s.id))
,	SealNumber = coalesce(s.seal_number,'')
from
	dbo.shipper s
	join dbo.edi_setups es 
		on s.destination = es.destination
	join dbo.destination d 
		on es.destination = d.destination
	join dbo.customer c 
		on c.customer = s.customer
GO
