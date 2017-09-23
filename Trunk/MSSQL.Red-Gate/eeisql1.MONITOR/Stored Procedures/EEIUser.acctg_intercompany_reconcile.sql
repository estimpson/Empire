SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE PROCEDURE [EEIUser].[acctg_intercompany_reconcile] 
(@fiscalyear varchar(4), @fiscalperiod varchar(2), @Beg_date date, @End_date date)

as

-- Exec eeiuser.acctg_intercompany_reconcile 2017, '08', '2017-08-01', '2017-08-31'

-- evision/empireweb/fixtransferprice.aspx

-- update eeiuser.acctg_inv_reconciliation set PS_material_cum = round(PS_Price*.83,2) where isnull(date_updated,'') = '' and isnull(OH_qty_on_hand,0) = 0 

-- select p_part, count(*) from ( select distinct(tpc.p_part), tpc.ps_price, tpc.ps_material_cum from eeiuser.acctg_inv_reconciliation tpc where tpc.date_updated is null group by p_part, ps_price, ps_material_cum)a  group by p_part having count(p_part)>=2

-- Exec [EEIUser].[acctg_intercompany_reconcile_update_transfer_pricing] @fiscal_year = 2017, @period = '08', @beg_date = '2017-08-01', @Result = 99999

-- update eeiuser.acctg_inv_reconciliation set date_updated = NULL where date_updated >= '2017-09-01'

-- delete from eeiuser.acctg_inv_reconciliation where isnull(date_updated,'') = '' and p_part in ('NAL0231-ASA02','NALB274-ASA03')

-- select distinct(time_stamp), reason from historicaldata.dbo.object_historical where time_Stamp >= '2017-08-31'

-- select distinct(P_Part) as P_Part, PS_Price, PS_material_cum from eeiuser.acctg_inv_reconciliation where isnull(date_updated,'') = ''




--SELECT [id], [P_ProductLine],  
--[P_part], [PS_price], [SO_price], [PS_Price]-[SO_price] as pricetoshippervariance,
--[PS_Material_Cum],[OH_TransferPrice], [OH_TransferPrice]-[PS_material_cum] as trfpricetohistoricaltrfpricevariance, [OH_qty_on_hand], [OH_Qty_on_hand]*([OH_TransferPrice]-[PS_material_cum]) as invimpact,
--[PS_frozen_material_cum],[date_updated],
--[NJB_Number],[NJB_QuoteNumber],[NJB_ProductionSelling],[NJB_SellingPrice],
--[QL_Part],[QL_ProductionPrice],[QL_PrototypePrice],[QL_TransferPrice],[QL_LTAs],
--[SO_order_no],[SO_customer_part],[SO_customer],[SO_destination],[SO_price],
--[OH_qty_on_hand],[OH_price],[OH_TransferPrice]
--FROM [eeiuser].[acctg_inv_reconciliation]
-- WHERE [date_updated] is null
-- AND [PS_price]-[SO_price] <> 0
---- AND  [OH_TransferPrice]-[PS_material_cum]<>0
--AND [OH_qty_on_hand] = 0
-- ORDER BY [P_ProductLine], [P_type], [P_part]




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
-- 3. Check for mis-posted A/R
--------------------------------------------------------------------------------------

-- Need to check for ar posted to 121012 or 121008 that is not posted to one of the sales accounts checked by the inventory reconciliation procedure above
-- and stop and return the invoice(s) that are posted in error

-- select * from ar_headers join ar_items on ar_headers.document = ar_items.document and ar_headers.document_type = ar_items.document_type   
-- where ar_headers.ledger_account_code = '121012' and ar_items.ledger_account_code not in ('401012','401112','402012','402112','403012','403112','404012','404112',
-- '405012','405112','406012','406112','407012','407112','408008','408108') and fiscal_year = '2016'

--------------------------------------------------------------------------------------
-- 4. Create the temp tables
--------------------------------------------------------------------------------------

create table #TransDetailsShipping
(	Invoice varchar(25),
	GLDate datetime,
	Item varchar (25),
	ItemPrice numeric (20,6),
	ItemQtyShipped numeric (20,6),
	ItemExtendedPrice numeric (20,6))

create table #TransDetailsReceiving
(	Invoice varchar(25),
	GLDate datetime,
	Item varchar (25),
	ItemCost numeric (20,6),
	ItemQtyReceived numeric (20,6),
	ItemExtendedCost numeric (20,6))
	

-- 5. Get Shipouts from EEH database (Sales Accounts)

declare	@Syntax nvarchar (4000)
set	@Syntax = N'delete	#TransDetailsShipping

				insert	#TransDetailsShipping
				select	*
				from	OpenQuery ( [EEHSQL1], ''SELECT       adi.ar_document,
															  ad.gl_date,
															  adi.item,
														  avg(adi.unit_cost),
														  sum(adi.quantity),
														  -sum(gct.ledger_amount) 
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
																			    ''''408008'''')
													and gct.fiscal_year = '''''+ @FiscalYear + '''''
													and gct.period = ' + convert(char, @FiscalPeriod) + '
													and	gcd.gl_date >= ''''' + @beg_datetime_varchar + '''''
													and gcd.gl_date <  ''''' + @end_datetime_varchar + '''''
												group by	adi.ar_document, 
															ad.gl_date,
															adi.item

									''
						)'

execute	sp_executesql
	@Syntax


-- 6.  Get receipts from the EEI database (Intercompany Inventory Accounts)

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
where	gct.posting_account in ('215011', '215060') and
		gct.fiscal_year =  @FiscalYear
	and gct.period = @FiscalPeriod
	and gct.monitor_transaction_date >= @beg_datetime
	and gct.monitor_transaction_date <  @end_datetime
group by	at.shipper,
		    gct.monitor_transaction_date,
			gct.monitor_part


-- 7.  Checkpoint for debug

--select * from #TransDetailsReceiving
--select * from #TransDetailsShipping


-- 8.  Create table variable for distinct list of parts returned from all subqueries 

declare @ShipperReceiptPartList table (part varchar(50), invoice varchar(50))

insert into @ShipperReceiptPartList
select distinct(item), invoice from
	(
	select distinct(item), invoice from #TransDetailsShipping
	union
	select distinct(item), right(invoice,5) from #TransDetailsReceiving
	) a


-- 9. Return the full reconciliation results

declare @partlista table (part varchar(50));

insert @partlista

select		distinct PartCostList.part

from	@ShipperReceiptPartList PartCostList
	left join #TransDetailsShipping TransDetailsShipping on PartCostList.Part = TransDetailsShipping.Item and PartCostList.Invoice = TransDetailsShipping.Invoice
	left join #TransDetailsReceiving TransDetailsReceiving on PartCostList.Part = TransDetailsReceiving.Item and PartCostList.Invoice = Right(TransDetailsReceiving.Invoice,5)

WHERE	coalesce (TransDetailsShipping.ItemPrice, 0) <> coalesce (TransDetailsReceiving.ItemCost, 0) -- to limit results to only the errors
	or	coalesce (TransDetailsShipping.ItemPrice, 0) = 0
	or  coalesce (TransDetailsReceiving.ItemCost, 0) = 0


-- 10.  Create the temp tables

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


-- 11. Get RMAs from EEH database (Sales Return Accounts)

	declare	@SyntaxB nvarchar (4000)
    set	@SyntaxB = N'
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
													and gct.fiscal_year = '''''+ @FiscalYear + '''''
													and gct.period = ' + convert(char, @FiscalPeriod) + '
													and	gcd.gl_date >= ''''' + @beg_datetime_varchar + '''''
													and gcd.gl_date <  ''''' + @end_datetime_varchar + '''''
												group by adi.ar_document,
														 ad.gl_date,
														 adi.item

									''
						)'


execute	sp_executesql @SyntaxB


-- 12.  Get RTVs from the EEI database (Intercompany Inventory Accounts)

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
	and gct.fiscal_year = @fiscalyear 
	and gct.period = @fiscalperiod
	and gct.monitor_transaction_date >= @beg_datetime
	and gct.monitor_transaction_date <  @end_datetime
group by	at.invoice_number,
			at.shipper, 
		    gct.monitor_transaction_date,
			gct.monitor_part

-- 13.  Checkpoint for debug

--select * from #TransDetailsRTV
--select * from #TransDetailsRMA


-- 14.  Create table variable for distinct list of parts returned from all subqueries 

declare @rmartvpartlist table (part varchar(50), EEHInvoice varchar(50))

insert into @rmartvpartlist
select distinct(item), EEHinvoice from
	(
	select distinct(item) as item, right(EEHinvoice,5) as EEHInvoice from #TransDetailsRMA
	union
	select distinct(item) as item, right(EEHinvoice,5) as EEHINvoice from #TransDetailsRTV
	) a


-- 15. Return the full reconciliation results

insert	@partlista 

select	distinct PartCostList.part

from	@rmartvpartlist PartCostList

	left join #TransDetailsRMA TransDetailsRMA on PartCostList.Part = TransDetailsRMA.Item and PartCostList.EEHInvoice = TransDetailsRMA.EEHInvoice
	left join #TransDetailsRTV TransDetailsRTV on PartCostList.Part = TransDetailsRTV.Item and PartCostList.EEHInvoice = TransDetailsRTV.EEHInvoice

WHERE	(coalesce (TransDetailsRMA.ItemPrice, 0) <> coalesce (TransDetailsRTV.ItemCost, 0) -- to limit results to only the errors
	or	coalesce (TransDetailsRMA.ItemPrice, 0) = 0
	or  coalesce (TransDetailsRTV.ItemCost, 0) = 0
		)
	AND PartCostlist.part not in (select part from @partlista)


-- 16. 

 declare @partlist table (part varchar(50));
 
 insert into @partlist
 select distinct(at.part) from audit_trail at join part p on at.part = p.part where p.type = 'F' and at.date_stamp >= @beg_datetime and at.date_stamp < @end_datetime
 insert into @partlist
 select distinct(part) from @partlista where part not in (select part from @partlist);

 --17.
 
with cte as (
select	phd.product_line
		,phd.type
		,pshd.part
		,pshd.price
		,pshd.material_cum
		,pshd.frozen_material_cum
		,ROW_NUMBER() OVER(PARTITION BY pshd.part order by pshd.time_stamp desc) as RN_ASC
from	[HistoricalData].dbo.part_standard_historical_daily pshd 
join	[HistoricalData].dbo.part_historical_daily phd on pshd.time_stamp = phd.time_stamp and pshd.part = phd.part
join	@partlist a on pshd.part = a.part
where	pshd.time_stamp >= @beg_datetime and pshd.time_stamp < @end_datetime
AND		phd.type not in ('','R','W')
AND		pshd.part <> 'PALLET' 
AND		pshd.part not like 'ECS%'
AND    (ISNULL(pshd.price,0) < .01 OR isnull(pshd.material_cum,0) < .01	OR	a.Part in (select aa.part from @partlista aa))
AND		a.part not in (select p_part from eeiuser.acctg_inv_reconciliation b where isnull(date_updated,'') = '')
)


insert into eeiuser.acctg_inv_reconciliation (
P_ProductLine
      ,P_type
      ,P_part
      ,PS_price
      ,PS_material_cum
      ,PS_frozen_material_cum
      ,date_updated
      ,NJB_Number
      ,NJB_Part
      ,NJB_QuoteNumber
      ,NJB_ProductionSelling
      ,NJB_SellingPrice
      ,NJB_TransferPrice
      ,QL_QuoteNumber
      ,QL_CustomerQuoteDate
      ,QL_Part
      ,QL_ProductionPrice
      ,QL_PrototypePrice
      ,QL_TransferPrice
      ,QL_LTAs
      ,SO_order_no
      ,SO_customer_part
      ,SO_customer
      ,SO_destination
      ,SO_price
      ,SO_TransferPrice
	  ,OH_Qty_on_Hand
	  ,OH_price
	  ,OH_TransferPrice
)
SELECT	distinct(ps.product_line)
		,ps.type
		,ps.part
		,ps.price
		,(case when psh.material_cum is not null then psh.material_cum else ps.material_cum end)
		,ps.frozen_material_cum
		,NULL
		,WO.WOEngineerID
	    ,WO.Part
	    ,WO.QuoteNumber
	    ,round(WO.ContPrice,4) as NJB_ProductionPrice 	    
		,round(WO.QuotedPrice,4) as NJB_PrototypePrice
		,round(WO.ContPrice*.83,2) as NJB_TransferPrice
		,q.quoteNumber
		,q.CustomerQuoteDate
		,q.EEIPartNumber
		,round(q.quoteprice,4) as QL_ProductionPrice
		,round(q.prototypeprice,4) as QL_PrototypePrice
		,round(Q.QuotePrice*.83,2) as QL_TransferPrice
		,q.LTA
		,OH.order_no
		,OH.customer_part
		,OH.customer
		,OH.destination
		,round(OH.price,4) as SO_SellingPrice
		,round(OH.price*.83,2) as SO_TransferPrice
		,OSH.quantity as OH_Qty_on_Hand
		,round(PSH.price,4) as OH_SellingPrice
		,round(PSH.material_cum,2) as OH_TransferPrice
FROM cte ps
	LEFT JOIN eehsql1.eeh.dbo.ENG_WOEngineer WO on ps.part = WO.part
	LEFT JOIN eeiuser.qt_quotelog Q on	WO.QuoteNumber = Q.QuoteNumber 
	LEFT JOIN order_header OH on ps.part = OH.blanket_part
	LEFT JOIN historicaldata.dbo.part_standard_historical_daily PSH on ps.part = psh.part and psh.time_stamp = (select max(time_stamp) from historicaldata.dbo.part_standard_historical_daily where time_stamp >= dateadd(d,-1,@beg_datetime) and time_stamp < @beg_datetime)
	LEFT JOIN (select part, sum(quantity) as quantity from historicaldata.dbo.object_historical_daily OSH where time_stamp = (select max(time_stamp) from historicaldata.dbo.object_historical_daily where time_stamp >= dateadd(d, -1, @beg_datetime) and time_stamp < @beg_datetime) and user_defined_status NOT IN ('PRESTOCK','PREOBJECT') group by part) OSH on ps.part = OSH.part 

ORDER BY ps.product_line, ps.type, ps.part
 
 















GO
