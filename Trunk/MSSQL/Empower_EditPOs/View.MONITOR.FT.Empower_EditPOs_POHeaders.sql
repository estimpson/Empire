
/*
Create View.MONITOR.FT.Empower_EditPOs_POHeaders.sql
*/

use MONITOR
go

--drop table FT.Empower_EditPOs_POHeaders
if	objectproperty(object_id('FT.Empower_EditPOs_POHeaders'), 'IsView') = 1 begin
	drop view FT.Empower_EditPOs_POHeaders
end
go

create view FT.Empower_EditPOs_POHeaders
as
select
	PONumber = ph.purchase_order
,	Vendor = ph.buy_vendor
,	GLDate = ph.gl_date
,	Terms = ph.terms
,	CRLedgerAcct = v.hdr_ledger_account_code
,	BuyUnit = ph.buy_unit
,	PayUnit = ph.pay_unit
from
	dbo.po_headers ph
	left join dbo.vendors v
		on v.vendor = ph.pay_vendor
where
	ph.po_type = 'MONITOR'
go

select
	eepph.PONumber
,	eepph.Vendor
,	eepph.GLDate
,	eepph.Terms
,	eepph.CRLedgerAcct
,	eepph.BuyUnit
,	eepph.PayUnit
from
	FT.Empower_EditPOs_POHeaders eepph
order by
	eepph.PONumber
go


