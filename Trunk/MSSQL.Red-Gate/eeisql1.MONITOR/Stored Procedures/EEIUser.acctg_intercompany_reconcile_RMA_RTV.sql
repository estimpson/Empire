SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE procedure [EEIUser].[acctg_intercompany_reconcile_RMA_RTV]
(	@Fiscal_Year varchar (4),
	@Fiscal_Period varchar (2),
	@Beg_date date,
	@End_date date)
as
SET ANSI_NULLS ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET transaction isolation level read uncommitted


--  execute	EEIUser.acctg_intercompany_reconcile_RMA_RTV @Fiscal_Year = '2019',	@Fiscal_Period = '6', @Beg_date = '2019-06-01', @End_date = '2019-06-30'

--  select * from eeiuser.acctg_transfer_price_corrections where fiscal_year = '2016' and period = 4

--  delete from eeiuser.acctg_transfer_price_corrections where fiscal_year = '2016' and period = 4



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


create table #TransDetailsRMA
(	EEHInvoice varchar(25),
    GLDate datetime,
	Item varchar (25),
	ItemPrice numeric (20,6),
	ItemQtyRMA numeric (20,6),
	ItemExtendedPrice numeric (20,6))

create table #TransDetailsRTV
(	EEHInvoice varchar(25),
	EEIInvoice varchar(25),
    GLDate datetime,
	Item varchar (25),
	ItemCost numeric (20,6),
	ItemQtyReturned numeric (20,6),
	ItemExtendedCost numeric (20,6))


-- 3. Need to check for ar posted to 121012 or 121008 that is not posted to one of the sales accounts checked by the inventory reconciliation procedure above
-- and stop and return the invoice(s) that are posted in error

-- select * from ar_headers join ar_items on ar_headers.document = ar_items.document and ar_headers.document_type = ar_items.document_type   
-- where ar_headers.ledger_account_code = '121012' and ar_items.ledger_account_code not in ('401012','401112','402012','402112','403012','403112','404012','404112',
-- '405012','405112','406012','406112','407012','407112','408008','408108') and fiscal_year = '2015'

-- 4. Get RMAs from EEH database (Sales Return Accounts)

	declare	@Syntax nvarchar (4000)
    set	@Syntax = N'
	delete	#TransDetailsRMA

	insert	#TransDetailsRMA
	select	*
	from	OpenQuery ( [EEHSQL1],			   ''SELECT   adi.ar_document,
														  ad.gl_date,
														  adi.item,
														  avg(adi.unit_cost),
														  sum(adi.quantity),
														  sum(gct.ledger_amount)
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
												WHERE	gct.posting_account in (''''403112'''',
																			    ''''404112'''',
																			    ''''405112'''',
																			    ''''406112'''',
																			    ''''408108'''')
													and gct.fiscal_year = '''''+ @Fiscal_Year + '''''
													and gct.period = ' + convert(char, @Fiscal_Period) + '
													and	gcd.gl_date >= ''''' + @beg_datetime_varchar + '''''
													and gcd.gl_date <  ''''' + @end_datetime_varchar + '''''
												group by adi.ar_document,
														 ad.gl_date,
														 adi.item

									''
						)'


execute	sp_executesql @Syntax


-- 5.  Get RTVs from the EEI database (Intercompany Inventory Accounts)

delete	#TransDetailsRTV

insert	into #TransDetailsRTV
select	EEHInvoice = at.invoice_number,
		EEIInvoice = at.shipper,
		GLDate = gct.Monitor_transaction_date,
		Item = gct.monitor_part,
		ItemCost = sum(gct.amount) / nullif (sum(gct.quantity), 0),
		ItemQtyReturned = sum (gct.quantity),
		ItemExtendedCost = sum (gct.amount)
from	monitor..vw_Empower_transactions_by_posting_account_intercompany gct
join	Monitor..audit_trail at on gct.monitor_audit_trail_id = at.id
where	gct.posting_account in ('215511', '215560') 
		and gct.fiscal_year = @Fiscal_Year
		and gct.period = @Fiscal_Period
		and gct.monitor_transaction_date >= @beg_datetime
		and gct.monitor_transaction_date <  @end_datetime
group by	at.invoice_number,
			at.shipper, 
		    gct.monitor_transaction_date,
			gct.monitor_part

-- 6.  Checkpoint for debug

--select * from #TransDetailsRTV
--select * from #TransDetailsRMA


-- 7.  Create table variable for distinct list of parts returned from all subqueries 

declare @partlist table (part varchar(50), EEHInvoice varchar(50))

insert into @partlist
select distinct(item), EEHinvoice from
	(
	select distinct(item) as item, right(EEHinvoice,5) as EEHInvoice from #TransDetailsRMA
	union
	select distinct(item) as item, right(EEHinvoice,5) as EEHINvoice from #TransDetailsRTV
	) a


-- 10. Return the full reconciliation results


-- DW 7/3/2019:  Replacing below logic with full outer join.  (The below fails when there isn't an EEHINvoice to Join on.)
--select		FiscalYear = @fiscal_year,
--			FiscalPeriod = @fiscal_period,
--			Part = PartCostList.part,

--			EEHRMA = TransDetailsRMA.EEHInvoice,
--			EEHRMAGLDATE = TransDetailsRMA.GLDate,
--			EEHQuantityRMA = coalesce (TransDetailsRMA.ItemQtyRMA, 0),
--			EEHTransferPriceRMA = coalesce (TransDetailsRMA.ItemPrice, 0),
--			EEHExtendedPriceRMA = coalesce (TransDetailsRMA.ItemExtendedPrice, 0),
			
--			EEIRTV = TransDetailsRTV.EEIInvoice,
--			EEHRMA = TransDetailsRTV.EEHInvoice,
--			EEIRTVGLDate = TransDetailsRTV.GLDate,
--			EEIQuantityReturned = coalesce (TransDetailsRTV.ItemQtyReturned, 0),
--			EEITransferPriceRTV = coalesce (TransDetailsRTV.ItemCost, 0),
--			EEIExtendedCostReturned = coalesce (TransDetailsRTV.ItemExtendedCost, 0),

--			RMARTVQtyVariance = coalesce (TransDetailsRMA.ItemQtyRMA,0) - coalesce(TransDetailsRTV.ItemQtyReturned,0),
--			RMARTVPriceVariance = coalesce (TransDetailsRMA.ItemPrice,0) - coalesce(TransDetailsRTV.ItemCost,0),
--			RMARTVExtVariance = coalesce (TransDetailsRMA.ItemExtendedPrice,0) - coalesce(TransDetailsRTV.ItemExtendedCost,0)


--from	@partlist PartCostList

--	left join #TransDetailsRMA TransDetailsRMA on PartCostList.Part = TransDetailsRMA.Item and PartCostList.EEHInvoice = TransDetailsRMA.EEHInvoice
--	left join #TransDetailsRTV TransDetailsRTV on PartCostList.Part = TransDetailsRTV.Item and PartCostList.EEHInvoice = TransDetailsRTV.EEHInvoice

----WHERE	coalesce (TransDetailsShipping.ItemQtyShipped, 0) <> coalesce (TransDetailsReceiving.ItemQtyReceived, 0) -- to limit results to only the errors

--order by part, isnull(TransDetailsRMA.GLDate,TransDetailsRTV.GLDate)




select		FiscalYear = @fiscal_year,
			FiscalPeriod = @fiscal_period,
			*
from 
(select EEHInvoice, GLDate, Item, Avg(ItemPrice) as ItemPrice, sum(ItemQtyRMA) as ItemQtyRMA, sum(ItemExtendedPrice) as ItemExtendedPrice from #TransDetailsRMA group by EEHInvoice, GLDate, Item) TransDetailsRMA
full outer join 
(select EEHInvoice, EEIInvoice, GLDate, Item, Avg(ItemCost) as ItemCost, sum(ItemQtyReturned) as ItemQtyReturned, sum(ItemExtendedCost) as ItemExtendedCost from #TransDetailsRTV group by EEIInvoice, EEHInvoice, GLDate, Item) TransDetailsRTV
on TransDetailsRMA.EEHInvoice = TransDetailsRTV.EEHInvoice and TransDetailsRMA.Item = TransDetailsRTV.Item
order by isnull(TransDetailsRMA.item, TransDetailsRTV.Item), isnull(TransDetailsRMA.GLDate,TransDetailsRTV.GLDate)



---- 11.  Populate the Transfer Price Correction Table for new discrepancies
	
--insert into acctg_transfer_price_corrections
--select		@fiscalyear,
--			@fiscalperiod,
--			PartCostList.part,
		
--			EEHTransferPrice = coalesce (avg(TransDetailsShipping.ItemPrice), 0),
--			EEHQuantityShipped = coalesce (sum(TransDetailsShipping.ItemQtyShipped), 0),				
--			EEHExtendedPriceShipped = coalesce (-sum(TransDetailsShipping.ItemExtendedPrice), 0),
						
--			EEITransferPrice = coalesce (avg(TransDetailsReceiving.ItemCost), 0),
--			EEIQuantityReceived = coalesce (sum(TransDetailsReceiving.ItemQtyReceived), 0),
--			EEIExtendedCostReceived = coalesce (sum(TransDetailsReceiving.ItemExtendedCost), 0),
			
--			EEHTransferPriceRMA = coalesce (avg(TransDetailsRMA.ItemPrice), 0),
--			EEHQuantityRMA = coalesce (sum(TransDetailsRMA.ItemQtyRMA), 0),
--			EEHExtendedPriceRMA = coalesce (-sum(TransDetailsRMA.ItemExtendedPrice), 0),
			
--			EEITransferPriceRTV = coalesce (avg(TransDetailsRTV.ItemCost), 0),
--			EEIQuantityReturned = coalesce (sum(TransDetailsRTV.ItemQtyReturned), 0),
--			EEIExtendedCostReturned = coalesce (sum(TransDetailsRTV.ItemExtendedCost), 0),
--			NULL,
--			NULL,
--			'N'
--from	(	select distinct(part) from 
--									   (	select	Part = Item
--											from	#TransDetailsShipping
--										   union
--											select	Item
--											from	#TransDetailsReceiving
--										   union
--											select	Item
--											from	#TransDetailsRMA
--										   union
--											select	Item
--											from	#TransDetailsRTV
--										)	Parts
--		)	PartCostList
--	left join #TransDetailsShipping TransDetailsShipping on PartCostList.Part = TransDetailsShipping.Item 
--	left join #TransDetailsReceiving TransDetailsReceiving on PartCostList.Part = TransDetailsReceiving.Item 
--	left join #TransDetailsRMA TransDetailsRMA on PartCostList.Part = TransDetailsRMA.Item 
--	left join #TransDetailsRTV TransDetailsRTV on PartCostList.Part = TransDetailsRTV.Item 
--where	((coalesce (-TransDetailsShipping.ItemExtendedPrice, 0) <> coalesce (TransDetailsReceiving.ItemExtendedCost, 0)) or 
--		(coalesce (-TransDetailsRMA.ItemExtendedPrice, 0) <> coalesce (TransDetailsRTV.ItemExtendedCost, 0)))
--		and PartCostList.part not in (select tpc.part from eeiuser.acctg_transfer_price_corrections tpc where tpc.fiscal_year = @fiscalyear and tpc.period = @fiscalperiod)
--group by partcostlist.part

---- 12.  If the part already exists in the month's transfer price correction table, update it with the latest discrepancy

--update		acctg_transfer_price_corrections
--set			EEH_xfr_price_shipped = xfr_price_shipped,
--			EEH_qty_shipped = qty_shipped,
--			EEH_ext_shipped = ext_shipped,
			
--			EEI_xfr_price_received = xfr_price_received,
--			EEI_qty_received = qty_received,
--			EEI_ext_received = ext_received,
			
--			EEH_xfr_price_rma = xfr_price_rma,
--			EEH_qty_rma = qty_rma,
--			EEH_ext_rma = ext_rma,
			
--			EEI_xfr_price_rtv = xfr_price_rtv,
--			EEI_qty_rtv = qty_rtv,
--			EEI_ext_rtv = ext_rtv

--from	acctg_transfer_price_corrections tpc
--	left join (select item, coalesce(avg(ItemPrice),0) as xfr_price_shipped, coalesce(sum(ItemQtyShipped),0) as qty_shipped, coalesce(sum(ItemExtendedPrice),0) as ext_shipped
--	from #TransDetailsShipping group by item) TransDetailsShipping on tpc.Part = TransDetailsShipping.Item 

--	left join (select item, coalesce(avg(ItemCost),0) as xfr_price_received, coalesce(sum(ItemQtyReceived),0) as qty_received, coalesce(sum(ItemExtendedCost),0) as ext_received
--	from #TransDetailsReceiving group by Item) TransDetailsReceiving on tpc.Part = TransDetailsReceiving.Item 
	
--	left join (select item, coalesce(avg(ItemPrice),0) as xfr_price_rma, coalesce(sum(ItemQtyRMA),0) as qty_rma, coalesce(sum(ItemExtendedPrice),0) as ext_rma
--	from #TransDetailsRMA group by Item) TransDetailsRMA on tpc.Part = TransDetailsRMA.Item 
	
--	left join (select item, coalesce(avg(ItemCost),0) as xfr_price_rtv, coalesce(sum(ItemQtyReturned),0) as qty_rtv, coalesce(sum(ItemExtendedCost),0) as ext_rtv
--	from #TransDetailsRTV group by Item) TransDetailsRTV on tpc.Part = TransDetailsRTV.Item 

--where	tpc.fiscal_year = @fiscalyear 
--		and tpc.period = @fiscalperiod


--update		acctg_transfer_price_corrections
--set			updated = 'N'
--from	acctg_transfer_price_corrections tpc
--	left join #TransDetailsShipping TransDetailsShipping on tpc.Part = TransDetailsShipping.Item 
--	left join #TransDetailsReceiving TransDetailsReceiving on tpc.Part = TransDetailsReceiving.Item 
--	left join #TransDetailsRMA TransDetailsRMA on tpc.Part = TransDetailsRMA.Item 
--	left join #TransDetailsRTV TransDetailsRTV on tpc.Part = TransDetailsRTV.Item 
--where	tpc.fiscal_year = @fiscalyear 
--		and tpc.period = @fiscalperiod
--		and ((coalesce (TransDetailsShipping.ItemExtendedPrice, 0) <> -coalesce (TransDetailsReceiving.ItemExtendedCost, 0)) or 
--		(coalesce (TransDetailsRMA.ItemExtendedPrice, 0) <> - coalesce (TransDetailsRTV.ItemExtendedCost, 0)))





GO
