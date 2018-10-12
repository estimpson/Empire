SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [eeiuser].[acctg_sales_reconciliation] @fiscal_year varchar(4), @period char(2)
as 

-- exec EEIUser.acctg_sales_reconciliation '2013','2'

declare @from_date datetime;
declare	@to_date datetime;
		
select @from_date =  CONVERT(datetime,@period+'/01/'+@fiscal_year)
select @to_date = DATEADD(M,1,@from_date)

select	aa.product_line,
		aa.account_code,
		aa.shipper,
		aa.type,
		aa.part_original,
		isnull(aa.qty_packed,0) as qty_packed,
		aa.alternate_price,
		isnull(aa.ext_amount,0) as ext_amount,
		bb.ledger_account,
		bb.document_id1,
		bb.document_id2,
		bb.item,
		isnull(bb.quantity,0) as quantity,
		bb.item_price,
		isnull(bb.document_amount,0) as document_amount,
		isnull(aa.ext_amount,0)+isnull(bb.document_amount,0) as variance 
from 		
	(	
	select	
		product_line, 
		account_code, 
		convert(varchar(50),shipper) as shipper, 
		isnull(a.type,'S') as type, 
		part_original, 
		qty_packed, 
		alternate_price, 
		qty_packed * alternate_price as ext_amount 
	from	[monitor].[dbo].[shipper] a 
		join [monitor].[dbo].[shipper_detail] b on a.id = b.shipper
		left join [monitor].[dbo].part c on b.part_original =  c.part
	where	a.date_shipped >= @from_date 
		and a.date_shipped < @to_date
		and isnull(a.type,'x') <> 't' 
		and a.destination <> 'EMPHOND'
	) aa	
full outer join		
	(	
	select	left(ledger_account,4) as ledger_account, 
		convert(varchar(50),document_id1) as document_id1, 
		document_id2, 
		item, 
		b.quantity,
		item_price, 
		document_amount 
	from	[monitor].[dbo].[gl_cost_transactions] gct 
		left outer join [monitor].[dbo].[ar_items] b on gct.document_id1 = b.document and gct.document_line = b.document_line 
	where	gct.ledger_account like ('40%')
		and gct.fiscal_year = @fiscal_year
		and gct.period = @period		
		and gct.update_balances = 'Y'
	) bb	
on	aa.account_code = left(bb.ledger_account,4) 	
	and convert(varchar(50),aa.shipper) = bb.document_id1 	
	and aa.part_original = bb.item 	
	and aa.qty_packed = (case when bb.document_id2='C' then -bb.quantity else bb.quantity end) 
order by	isnull(aa.account_code,bb.ledger_account), 	
	isnull(aa.part_original, bb.item),
	isnull(aa.shipper, bb.document_id1) 





GO
