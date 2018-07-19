
/*
Create View.EEH.SupplierEDI.TradingPartnerOverlayGroups.sql
*/

use EEH
go

--drop table SupplierEDI.TradingPartnerOverlayGroups
if	objectproperty(object_id('SupplierEDI.TradingPartnerOverlayGroups'), 'IsView') = 1 begin
	drop view SupplierEDI.TradingPartnerOverlayGroups
end
go

create view SupplierEDI.TradingPartnerOverlayGroups
as
select
	TradingPartnerCode = ev.trading_partner_code
,	OverlayGroup =
		case
			when ev.trading_partner_code in
				(	'ARROWCORP'
				,	'TTI'
				,	'MCMASTERS'
				,	'3M'
				,	'GPOLYMER'
				,	'PSG'
				,	'NEXEO'
				,	'DELFINGEN'
				,	'ARROW'
				,	'FUTURE'
				,	'KOSTAL'
				) then 'NET'
			when
				ev.trading_partner_code like '%DIXIE%'
					or ev.trading_partner_code like '%AEES%'
					or ev.trading_partner_code like '%THERMOLINK%'
				then 'DIXIE'
			when ev.trading_partner_code in
				(	'TE'
				) then 'TE'
			when ev.trading_partner_code is not null then 'ACCUM'
			else 'UNDEFINED'
		end
from
	dbo.edi_vendor ev
group by
	ev.trading_partner_code
go

select
	sog.TradingPartnerCode
,	sog.OverlayGroup
from
	SupplierEDI.TradingPartnerOverlayGroups sog
