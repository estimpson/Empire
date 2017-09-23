SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [EEIUser].[acctg_inv_sp_reconciliation_specific_part] @fiscal_year int, @period int as

-- exec eeiuser.acctg_inv_sp_reconciliation_specific_part 2015, 9

 declare @partlist table (part varchar(50));
 
 insert into @partlist
 select part from eeiuser.acctg_transfer_price_corrections where fiscal_year = @fiscal_year and period = @period

 declare @start_date date
 select @start_date = convert(varchar(4),@fiscal_year)+'-'+convert(varchar(2),@period)+'-01'
;

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
where	pshd.time_stamp >= @start_date
AND		phd.type not in ('','R','W')
AND		pshd.part <> 'PALLET' 
AND		pshd.part not like 'ECS%'
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
)
SELECT	distinct(ps.product_line)
		,ps.type
		,ps.part
		,ps.price
		,ps.material_cum
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
 FROM cte ps
 LEFT JOIN eehsql1.monitor.dbo.ENG_WOEngineer WO on ps.part = WO.part
 LEFT JOIN eeiuser.qt_quotelog Q on	WO.QuoteNumber = Q.QuoteNumber 
 LEFT JOIN order_header OH on ps.part = OH.blanket_part


 WHERE  ps.RN_ASC = 1 
	AND ps.part in (select distinct(part) from @partlist)
 ORDER BY ps.product_line, ps.type, ps.part
 



GO
