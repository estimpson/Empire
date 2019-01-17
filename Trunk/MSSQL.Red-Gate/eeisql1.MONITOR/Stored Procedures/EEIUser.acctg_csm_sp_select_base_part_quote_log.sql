SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE proc [EEIUser].[acctg_csm_sp_select_base_part_quote_log] (@base_part varchar(30)) 
as 

--For Testing:

-- exec eeiuser.acctg_csm_sp_select_base_part_quote_log @base_part = 'AUT0290' 


--declare @base_part varchar(20)
--declare @release_id varchar(8)
--select @base_part = 'TRW1152' 
--select @release_id = '2018-10'

select	 [Customer]	
		,[ReceiptDate]		
		,[CustomerQuoteFilePath]
		,[PrintNo]
		,[PrintDate]		
		,[PrintFilePath]		
		,[Notes]			
		,[QuoteNumber]
		,[Requote]		
		,(select b.QuoteNumber from eeiuser.qt_quotelog b where b.RowID = qt_quotelog.[ParentQuoteID]) as [ParentQuoteNumber]
		,(select b.CustomerQuoteFilePath from eeiuser.qt_quotelog b where b.RowID = qt_quotelog.[ParentQuoteID]) as [ParentQuoteFilePath]
		,[QuoteStatus]		
		,[CustomerQuoteDate]		
		,[Awarded]
		,[AwardedDate]
		,[ApplicationName]
		,[FunctionName]
		,[OEM]		
		,[Program]		
		,[ModelYear]		
		,[Nameplate]
		,[SOP]
		,[EOP]
		,[EAU]		
		,[QuotePrice]
		,[StraightMaterialCost]
		,(case when isnull([QuotePrice],0)=0 then 0 else [StraightMaterialCost]/[QuotePrice] end) as [Quoted MC %]
		,[TotalQuotedSales]
		,[PrototypePrice]
		,[LTAPercentage]
		,[LTAYears]		
		,[Tooling]
from	eeiuser.qt_quotelog
where	EEIPartnumber like  '%'+@base_part+'%' 
order by [CustomerQuoteDate], [RowID]


GO
