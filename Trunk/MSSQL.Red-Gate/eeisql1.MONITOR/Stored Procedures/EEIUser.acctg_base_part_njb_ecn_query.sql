SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

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
where left(ps.part,7) = @base_part
	
	

GO
