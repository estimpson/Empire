SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



--  execute	EEIUser.acctg_intercompany_reconcile_shipper_receipt @Fiscal_year = '2017', @Fiscal_period = 6, @Beg_Date = '2017-06-01',	@End_date = '2017-06-20'


CREATE procedure [EEIUser].[acctg_intercompany_reconcile_shipper_receipt]
	(@fiscal_year varchar(4), @fiscal_period varchar(2), @beg_date date, @end_date date)

as
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET transaction isolation level read uncommitted



--------------------------------------------------------------------------------------
--1.  A setting necessary when using VS2010 table adapters with temp tables:
--------------------------------------------------------------------------------------

IF 1=0 BEGIN
	SET FMTONLY OFF
END


--------------------------------------------------------------------------------------
--2. Format dates for use later on in the procedure (need a varchar for the openquery)
--------------------------------------------------------------------------------------

-- DECLARE	@BEG_DATE DATE = '2017-06-01'
--		   ,@END_DATE DATE = '2017-06-27'

DECLARE @beg_datetime datetime = @beg_date
	   ,@end_datetime datetime = dateadd(d,1,@end_date)

-- SELECT @beg_datetime
-- SELECT @end_datetime

DECLARE @beg_datetime_varchar varchar(19) = @beg_datetime
	   ,@end_datetime_varchar varchar(19) = @end_datetime

-- SELECT @Beg_DateTime
-- SELECT @End_DateTime


--------------------------------------------------------------------------------------
-- 3. Create the temp tables
--------------------------------------------------------------------------------------

create table #TransDetailsShipping
(	Invoice varchar(25),
	GLDate datetime,
	Item varchar (25),
	ItemPrice numeric (20,6),
	ItemQtyShipped numeric (20,6),
	ItemExtendedPrice numeric (20,6),
	glaccount varchar(25))

create table #TransDetailsReceiving
(	Invoice varchar(25),
	GLDate datetime,
	Item varchar (25),
	ItemCost numeric (20,6),
	ItemQtyReceived numeric (20,6),
	ItemExtendedCost numeric (20,6))



-- 3. Need to check for ar posted to 121012 or 121008 that is not posted to one of the sales accounts checked by the inventory reconciliation procedure above
-- and stop and return the invoice(s) that are posted in error

--select * from ar_headers join ar_items on ar_headers.document = ar_items.document and ar_headers.document_type = ar_items.document_type   
-- where ar_headers.ledger_account_code = '121012' and ar_items.ledger_account_code not in ('401012','401112','402012','402112','403012','403112','404012','404112',
-- '405012','405112','406012','406112','407012','407112','408008','408108') and fiscal_year = '2016'


-- 4. Get Shipouts from EEH database (Sales Accounts)

declare	@Syntax nvarchar (4000)
set	@Syntax = N'delete	#TransDetailsShipping

				insert	#TransDetailsShipping
				select	*
				from	OpenQuery ( [EEHSQL1], ''SELECT       adi.ar_document,
															  ad.gl_date,
															  adi.item,
														  avg(adi.unit_cost),
														  sum(adi.quantity),
														  -sum(gct.ledger_amount),
														  gct.posting_account
												FROM	EEH_EMPOWER.dbo.ar_document_items adi
													  join EEH_EMPOWER.dbo.ar_documents ad
															 on  ad.ar_document = adi.ar_document
															 and ad.document_type = adi.document_type
													  join EEH_EMPOWER.dbo.gl_cost_transactions gct
															 on  adi.ar_document = gct.document_id1
															 and adi.document_type = gct.document_type
															 and adi.document_line = gct.document_line
													  join EEH_EMPOWER.dbo.gl_cost_documents gcd
															 on gct.document_type = gcd.document_type
															 and gct.document_id1 = gcd.document_id1
															 and gct.document_id2 = gcd.document_id2
															 and gct.document_id3 = gcd.document_id3
												WHERE	gct.posting_account in (''''403012'''',
																			    ''''404012'''',
																			    ''''405012'''',
																			    ''''406012'''',
																			    ''''408008'''',
																				''''408512'''')
													and gcd.fiscal_year = '''''+ @Fiscal_Year + '''''
													and gcd.period = ' + convert(char, @Fiscal_Period) + '
													and	gcd.gl_date >= ''''' + @beg_datetime_varchar + '''''
													and gcd.gl_date <  ''''' + @end_datetime_varchar + '''''
												group by	adi.ar_document, 
															ad.gl_date,
															adi.item,
															gct.posting_account

									''
						)'

execute	sp_executesql
	@Syntax


-- 5.  Get receipts from the EEI database (Intercompany Inventory Accounts)

delete	#TransDetailsReceiving

insert	into #TransDetailsReceiving
select	Invoice = at.shipper,
		GLDate = gct.Monitor_transaction_date,
		Item = gct.monitor_part,
		ItemCost = -sum(gct.amount) / nullif (sum(gct.quantity), 0),
		ItemQtyReceived = sum (gct.quantity),
		ItemExtendedCost = -sum (gct.amount)
from	Monitor..vw_Empower_transactions_by_posting_account_intercompany gct
join	Monitor..audit_trail at on gct.monitor_audit_trail_id = at.id
where	gct.posting_account in ('215011', '215060') 
		and gct.fiscal_year = @Fiscal_Year
		and gct.period = @Fiscal_Period
		and gct.monitor_transaction_date >= @beg_datetime
		and gct.monitor_transaction_date <  @end_datetime
		and gct.monitor_transaction_type not in ('D')
group by	at.shipper,
		    gct.monitor_transaction_date,
			gct.monitor_part


-- 6.  Checkpoint for debug

--select * from #TransDetailsShipping order by invoice, item
--select * from #TransDetailsReceiving order by invoice, item


-- 7.  Create table variable for distinct list of parts returned from all subqueries 

declare @partlist table (part varchar(50), invoice varchar(50))

insert into @partlist
select distinct(item), invoice from
	(
	select distinct(item), invoice from #TransDetailsShipping
	union
	select distinct(item), right(invoice,5) from #TransDetailsReceiving
	) a


-- 8. Return the full reconciliation results

select		FiscalYear = @fiscal_year,
			FiscalPeriod = @fiscal_period,
			Part = PartCostList.part,

			EEHInvoice = TransDetailsShipping.Invoice,
			EEHGLDate = TransDetailsShipping.GLDate,
			EEHQuantityShipped = coalesce (TransDetailsShipping.ItemQtyShipped, 0),
			EEHTransferPrice = coalesce (TransDetailsShipping.ItemPrice, 0),
			EEHExtendedPriceShipped = coalesce (TransDetailsShipping.ItemExtendedPrice, 0),
			
			EEIInvoice = TransDetailsReceiving.Invoice,
			EEIGLDate = TransDetailsReceiving.GLDate,
			EEIQuantityReceived = coalesce (TransDetailsReceiving.ItemQtyReceived, 0),
			EEITransferPrice = coalesce (TransDetailsReceiving.ItemCost, 0),
			EEIExtendedCostReceived = coalesce (TransDetailsReceiving.ItemExtendedCost, 0),

			QtyVariance = coalesce (TransDetailsShipping.ItemQtyShipped,0) - coalesce(TransDetailsReceiving.ItemQtyReceived,0),
			PriceVariance = coalesce (TransDetailsShipping.ItemPrice,0) - coalesce(TransDetailsReceiving.ItemCost,0),
			ExtVariance = coalesce (TransDetailsShipping.ItemExtendedPrice,0) - coalesce(TransDetailsReceiving.ItemExtendedCost,0)


from	@partlist PartCostList
	left join #TransDetailsShipping TransDetailsShipping on PartCostList.Part = TransDetailsShipping.Item and PartCostList.Invoice = TransDetailsShipping.Invoice
	left join #TransDetailsReceiving TransDetailsReceiving on PartCostList.Part = TransDetailsReceiving.Item and PartCostList.Invoice = Right(TransDetailsReceiving.Invoice,5)

--WHERE	coalesce (TransDetailsShipping.ItemPrice, 0) <> coalesce (TransDetailsReceiving.ItemCost, 0) -- to limit results to only the errors
--	or	coalesce (TransDetailsShipping.ItemPrice, 0) = 0
--	or  coalesce (TransDetailsReceiving.ItemCost, 0) = 0

order by part, isnull(TransDetailsShipping.GLDate,TransDetailsReceiving.GLDate)


GO
