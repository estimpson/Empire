SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[eeisp_rpt_FAReview] (@documenttype varchar(25), @ledgerAccount varchar(25), @period int, @fiscalyear int)
as
Begin
select	document_id1, document_line, ledger_account, contract_account_id, period, amount, document_reference1, document_remarks, item, period, fiscal_year
from		gl_cost_transactions
join		po_items on gl_cost_transactions.document_id1 = po_items.purchase_order and  
			gl_cost_transactions.document_line = po_items.po_line 
where	document_type = @documenttype and 
			ledger_account = @ledgerAccount and 
			period = @period and fiscal_year = @fiscalyear
order by 2
End
GO
