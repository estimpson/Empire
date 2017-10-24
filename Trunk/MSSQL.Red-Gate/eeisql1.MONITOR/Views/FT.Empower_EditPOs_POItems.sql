SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[Empower_EditPOs_POItems]
as
select
	PONumber = pi.purchase_order
,	POLine = pi.po_line
,	Item = pi.item
,	ItemDescription = pi.item_description
,	DRLedgerAcct = pi.ledger_account_code
from
	dbo.po_items pi
GO
