
/*
Create View.EEH.EDI_XML_NET_830.TradingPartnerInfo.sql
*/

use EEH
go

--drop table EDI_XML_NET_830.TradingPartnerInfo
if	objectproperty(object_id('EDI_XML_NET_830.TradingPartnerInfo'), 'IsView') = 1 begin
	drop view EDI_XML_NET_830.TradingPartnerInfo
end
go

create view EDI_XML_NET_830.TradingPartnerInfo
as
select distinct
	EmpireVendorCode = ev.vendor
,	TradingPartnerCode= ev.trading_partner_code
,	GenerationDT = convert(varchar(6), getdate(), 12)
,	HorizonStartDT = convert(varchar(6), getdate() + 1, 12)
,	HorizonEndDT = convert(varchar(6), FT.fn_TruncDate('wk', getdate()) + 1 + 7 * (case when ev.total_weeks > 0 then ev.total_weeks else 26 end), 12)
,	ReleaseNumber = /* ev.trading_partner_code + '-' + */ convert(varchar(6), getdate(), 12)
,	EDIVendorCode = coalesce(nullif(es.supplier_code, ''), ev.vendor)
,	EDIVendorCodeType = coalesce(nullif(es.id_code_type, ''), '92')
,	MaterialIssuer = es.material_issuer
,	MaterialIssuerType = case when ev.vendor = 'DIXIEHON' then '92' else '1' end
,	AutoCreate830Flag = case when ev.auto_create_po = 'Y' then 1 else 0 end
,	ReleaseSendDays = ev.send_days
,	tpog.OverlayGroup
,	xrpdrf.FunctionName
from
	dbo.edi_vendor ev
	join dbo.edi_setups es
		on ev.vendor = es.destination
	join SupplierEDI.TradingPartnerOverlayGroups tpog
		on tpog.TradingPartnerCode = ev.trading_partner_code
	left join SupplierEDI.XML_ReleasePlanDataRootFunctions xrpdrf
		on xrpdrf.OverlayGroup = tpog.OverlayGroup
where
	tpog.OverlayGroup = 'NET'
go

select
	*
from
	EDI_XML_NET_830.TradingPartnerInfo tpi
