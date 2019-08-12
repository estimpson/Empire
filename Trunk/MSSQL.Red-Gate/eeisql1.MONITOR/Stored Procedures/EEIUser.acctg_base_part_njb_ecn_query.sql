SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- DW 2019-07-31 Added Time Base Pricing table to this query



CREATE procedure [EEIUser].[acctg_base_part_njb_ecn_query] @base_part varchar(7)
as 


SELECT	distinct(p.product_line)
		,p.type
		,WO.WOEngineerID
	    , p.Part
	   -- ,WO.Part
		,OH.Customer_Part
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
		,aa.customer as TBP_Customer
		,aa.part as TBP_Part
		,aa.effect_date as TBP_EffectiveDate
		,aa.price as TBP_Price
		--,TransferPrice=ROUND(WO.ContPrice *0.83,2)
FROM part p
	LEfT JOIN part_standard ps on ps.part = p.part
	LEFT JOIN eehsql1.eeh.dbo.ENG_WOEngineer WO on ps.part = WO.part
	LEFT JOIN eeiuser.qt_quotelog Q on	WO.QuoteNumber = Q.QuoteNumber 
	LEFT JOIN order_header OH on ps.part = OH.blanket_part
	--LEFT JOIN (	select	Part,TransferPrice=AVG(ROUND(ContPrice *0.83,2)),TransDT=Max(TransDT )
	--			from	eehsql1.eeh.dbo.ENG_WOEngineer 
	--			where	ContPrice>0 AND Status in ('A','D') -- and part='ALC0818-DV02'
	--			group by Part) WOAPQP ON WOAPQP.part= p.part
	LEFT JOIN (select a.customer, a.part, a.customer_part_number, a.effect_date, a.price from part_customer_tbp a 

join (select customer, part, max(effect_date) as effect_date from part_customer_tbp group by customer, part) b

on a.customer = b.customer and a.part = b.part

) aa on p.part = aa.part

where left(ps.part,7) = @base_part
	
	

GO
