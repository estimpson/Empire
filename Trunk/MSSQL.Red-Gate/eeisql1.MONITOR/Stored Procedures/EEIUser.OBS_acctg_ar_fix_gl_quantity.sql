SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [EEIUser].[OBS_acctg_ar_fix_gl_quantity]
as 

update	gct 
set		gct.quantity = ai.quantity 
from	gl_cost_transactions gct 
	join ar_items ai on gct.document_id2 = ai.document_type and gct.document_id1 = ai.document and gct.document_line = ai.document_line 
where	gct.quantity = 0
	and gct.document_type in ('AR INVOICE', 'AR CREDIT MEMO')
	and gct.transaction_date >= '2013-11-01'





GO
