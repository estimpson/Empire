SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure  [dbo].[eeisp_rpt_compareMonInvoicetoGL_test] (	@begindate datetime,
															@enddate	datetime,
															@fiscalYear  varchar(5),
															@fiscalPeriod smallint)
as
begin
select	GLFiscalYear =GLCostTransactions.fiscal_year,		
		GLPeriod = GLCostTransactions.period,		
		GLTransactionDate = GLCostTransactions.transaction_date,	
		DocumentType = GLCostTransactions.document_type, 	
		Documentid1 = GLCostTransactions.docid1, 		
		DocumentRedf1 = GLCostTransactions.document_reference1,			
		DocumentLine = GLCostTransactions.document_line,	
		arItem = GLCostTransactions.item,	
		DocumentRemarks = document_remarks,
		dbAccount ,
		dbQty  ,
		dbPrice  ,
		dbAmount ,
		crAccount ,
		crQty ,
		crPrice ,
		crAmount,
		DateShipped = ShipperDetail.date_shipped,
		Customer=ShipperDetail.customer,
		Shipper = ShipperDetail.shipper,
        SDAccount=ShipperDetail.account_code,
		EEIPart = ShipperDetail.part_original,
		SDPrice= ShipperDetail.Alternate_price,
		SDQty=ShipperDetail.qty_packed,
		SDExtended=round(ShipperDetail.Alternate_price*ShipperDetail.qty_packed,2),
		Variance=ISNULL(round(ShipperDetail.Alternate_price*ShipperDetail.qty_packed,2),0)+ISNULL(crAmount,0)+ISNULL(dbAmount,0)

from	(	select	fiscal_year = min (gl_cost_transactions.fiscal_year), 
					period = min (gl_cost_transactions.period), 
					gl_cost_transactions.transaction_date,
					document_type = min (gl_cost_transactions.document_type), 
					[docid1]=convert(varchar(20),gl_cost_transactions.document_id1), 
					document_reference1 = min (gl_cost_transactions.document_reference1),
					document_line = min (gl_cost_transactions.document_line),
					ar_items.item,
					document_remarks = min (convert (varchar (1000),gl_cost_transactions.document_remarks)),
					dbAccount =min (case when (ISNULL(GL_Cost_Transactions.amount,0) >= 0) then GL_Cost_Transactions.ledger_account else '' end),
					dbQty = sum (case when (ISNULL(GL_Cost_Transactions.amount,0) >= 0) then GL_Cost_Transactions.quantity else 0 end) ,
					dbPrice = min (case when (ISNULL(GL_Cost_Transactions.amount,0) >= 0) then ar_items.item_price else NULL end) ,
					dbAmount=sum (case when (ISNULL(GL_Cost_Transactions.amount,0) >= 0) then GL_Cost_Transactions.amount else 0 end) ,
					crAccount=min (case when (GL_Cost_Transactions.amount < 0) then GL_Cost_Transactions.ledger_account else '' end) ,
					crQty=sum (case when (GL_Cost_Transactions.amount < 0) then GL_Cost_Transactions.quantity else 0 end) ,
					crPrice=min (case when (GL_Cost_Transactions.amount < 0) then ar_items.item_price else NULL end) ,
					crAmount=min (case when (GL_Cost_Transactions.amount < 0) then GL_Cost_Transactions.amount else 0 end),
					update_balance = min (gl_cost_transactions.update_balances)
			from	gl_cost_transactions
			left outer join ar_items	on	gl_cost_transactions.document_id2 = ar_items.document_type and 
										gl_cost_transactions.document_id1 = ar_items.document and 
										gl_cost_transactions.document_line = ar_items.document_line
			where	gl_cost_transactions.update_balances = 'Y' and
					gl_cost_transactions.fiscal_year = @fiscalYear  and 
					gl_cost_transactions.period = @fiscalPeriod  and
					gl_cost_transactions.document_type in ('AR CREDIT MEMO', 'AR INVOICE', 'BANK EFT', 'Journal Entry')
			group by
					convert (varchar (20),gl_cost_transactions.document_id1),
					ar_items.item, 
					gl_cost_transactions.transaction_date
					
					) GLCostTransactions
	full  join		
		(	select	shipper_detail.shipper,
					date_shipped = min (shipper.date_shipped),
					customer = min (shipper.customer),
					customer_part = min (customer_part),
					account_code = min (account_code),
					qty_packed = sum (qty_packed),
					alternate_price = min (alternate_price),
					extended=sum (alternate_price*qty_packed),
					plant = min (shipper.plant),
					type = min (shipper.type),
					[InvOrCM]=min (case ISNULL(shipper.type,'0') when '0' then 'AR INVOICE' when 'R' then 'AR CREDIT MEMO' else '' end),
					shipper_detail.part_ORIGINAL,
					part = min (shipper_detail.part)
			from	shipper_detail
			join		shipper on shipper_detail.shipper = shipper.id
			where	shipper.date_shipped >= @begindate and
					shipper.date_shipped< dateadd(dd,1,@enddate) and
					shipper.destination<>'EMPHOND' and
					isNULL(shipper.type,'Y')!='T'
			group by
					shipper_detail.shipper,
					shipper_detail.part_original) ShipperDetail  on GLCostTransactions.docid1 = convert(varchar(20),ShipperDetail.Shipper) and
																GLCostTransactions.document_type = ShipperDetail.InvorCM and
																isNULL(GLCostTransactions.item, 'XXXX') = ShipperDetail.Part_original  and
																convert(datetime,convert(varchar(20),shipperDetail.date_shipped, 102) )=  convert(datetime,convert(varchar(20),GLCostTransactions.transaction_date,102))
order by 5,7
end
GO
