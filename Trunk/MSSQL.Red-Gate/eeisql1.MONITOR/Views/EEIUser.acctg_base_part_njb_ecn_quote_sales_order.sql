SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE View [EEIUser].[acctg_base_part_njb_ecn_quote_sales_order] 
as 


-- select * from eeiuser.acctg_base_part_njb_ecn_quote_sales_order

SELECT	distinct(p.product_line)
		,p.type
		,OH.Customer_Part	
		,WO.Part   		
		
		,c.[Quote Number] as [NSA_QuoteNumber]		
		,c.[Quoted Selling Price] as [NSA_QuotedPrice] 
		,c.[Quoted Material Cost] as [NSA_QuotedMC]
		,c.[Quoted EAU] as [NSA Quoted EAU]
		,c.[Customer Annual Capacity Planning Volume] as [NSA ACPV]
		,c.[SOP Date] as [NSA SOP]
				
		,WO.WOEngineerID as WO_WorkOrderID
	    ,WO.QuoteNumber as WO_QuoteNumber
	    ,round(WO.ContPrice,4) as NJB_ProductionPrice 	    
		,round(WO.QuotedPrice,4) as NJB_PrototypePrice
		,round(WO.ContPrice*.83,2) as NJB_TransferPrice
		
		,q.QuoteNumber as QL_QuoteNumber
		,q.CustomerQuoteDate as QL_CustomerQuoteDate
		,round(q.quoteprice,4) as QL_ProductionPrice
		,round(q.prototypeprice,4) as QL_PrototypePrice
		,round(Q.QuotePrice*.83,2) as QL_TransferPrice
		,round(Q.StraightMaterialCost,6) as QL_StraightMaterialCost
		,round(q.tooling,2) as QL_Tooling
		,q.EAU as [QL EAU]
		,q.LTA as [QL LTAs]
		,q.Awarded as [QL Awarded?]
		,q.AwardedDate as [QL Awarded Date]

		,OH.order_no as SO_OrderNo
		,OH.customer_part as SO_CustomerPart
		,OH.customer as SO_Customer
		,OH.destination as SO_Destination
		,round(OH.price,4) as SO_SellingPrice
		,round(OH.price*.83,2) as SO_TransferPrice

FROM part p
	LEfT JOIN part_standard ps on ps.part = p.part
	LEFT JOIN eehsql1.eeh.dbo.ENG_WOEngineer WO on ps.part = WO.part
	LEFT JOIN eeiuser.acctg_sales_new_sales_awards c on left(ps.part,7) = c.[empire part number]
	LEFT JOIN eeiuser.qt_quotelog q on	WO.QuoteNumber = q.QuoteNumber 
	LEFT JOIN order_header OH on ps.part = OH.blanket_part	

GO
