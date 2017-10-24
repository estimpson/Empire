SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[Empower_EditPOs_POHeaders]
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
GO
