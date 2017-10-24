
/*
Create View.MONITOR.FT.Empower_EditPOs_POItems.sql
*/

use MONITOR
go

--drop table FT.Empower_EditPOs_POItems
if	objectproperty(object_id('FT.Empower_EditPOs_POItems'), 'IsView') = 1 begin
	drop view FT.Empower_EditPOs_POItems
end
go

create view FT.Empower_EditPOs_POItems
as
select
	PONumber = pi.purchase_order
,	POLine = pi.po_line
,	Item = pi.item
,	ItemDescription = pi.item_description
,	DRLedgerAcct = pi.ledger_account_code
from
	dbo.po_items pi
go

select
	eepopi.PONumber
,	eepopi.POLine
,	eepopi.Item
,	eepopi.ItemDescription
,	eepopi.DRLedgerAcct
from
	FT.Empower_EditPOs_POItems eepopi
where
	eepopi.PONumber = 'EEI0369'
order by
	eepopi.POLine

select
	eepopi.PONumber
,	count(*)
from
	FT.Empower_EditPOs_POItems eepopi
group by
	eepopi.PONumber
order by
	2 desc