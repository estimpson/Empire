SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--exec eeiuser.acctg_nal_material_cost 2011, 12

CREATE procedure [eeiuser].[acctg_nal_material_cost] @fiscal_year int, @period int
as

--select * from 
	(
	select	(case when part.product_line in ('Bulbed ES3 Components','Bulbed Wire Harn-EEH') then 'Yes' else 'No' end) as Produced_in_AL,
			part.product_line,
			gct.ledger_account,
			gct.document_reference1 as part,
			sum(gct.quantity) as quantity,
			sum(gct.amount) as amount
	from	gl_cost_transactions gct
			left join part on gct.document_reference1 = part.part
	where	gct.fiscal_year = @fiscal_year 
		and gct.period = @period
		and gct.ledger_account in ('501012','501112','501312','501512')
		and gct.update_balances = 'Y'
		and LEFT(gct.document_reference1,3) in ('NAL','FNG')
		group by (case when part.product_line in ('Bulbed ES3 Components','Bulbed Wire Harn-EEH') then 'Yes' else 'No' end),
		part.product_line,
		gct.ledger_account,
		gct.document_reference1
	) 

union
	(
	select	(case when part.product_line in ('Bulbed ES3 Components','Bulbed Wire Harn-EEH') then 'Yes' else 'No' end) as Produced_in_AL,
			part.product_line,
			gct.ledger_account,
			ar_items.item as part, 
			-sum(ar_items.quantity) as quantity,
			sum(gct.amount) as amount
	from	gl_cost_transactions gct 
			left join ar_items on gct.document_id1 = ar_items.document and gct.document_line = ar_items.document_line 
			left join part on ar_items.item = part.part
	where	gct.fiscal_year = @fiscal_year
		and gct.period = @period
		and gct.ledger_account in ('401012','401112','401212','401312','401412','401512','401612','401712','401812','401912','402012','402112','402212','402312','402412','402512','401712','401912') 
		and gct.update_balances = 'Y'
		and LEFT(ar_items.item,3) in ('NAL','FNG')
	group by (case when part.product_line in ('Bulbed ES3 Components','Bulbed Wire Harn-EEH') then 'Yes' else 'No' end),
			part.product_line,
			gct.ledger_account,
			ar_items.item
	) 
	
--on a.Produced_in_AL = b.Produced_in_AL and a.product_line = b.product_line and a.part = b.part

GO
