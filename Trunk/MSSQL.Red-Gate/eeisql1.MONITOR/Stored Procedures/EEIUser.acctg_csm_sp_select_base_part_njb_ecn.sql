SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[acctg_csm_sp_select_base_part_njb_ecn] (@Base_part varchar(25))
as 

-- exec eeiuser.acctg_csm_sp_select_base_part_Njb_ECN @base_part = 'AUT0290'

select 
WOEngineerID
,(case when WOType='N' then 'NJB' else (case when WOType='E' then 'ECN' else WOType end)end) as WOType 
,Part
,OldPart
,TransDt
,Status
,Customer
,PEM
,ProgramEngineer
,Comments
,DocumentID 
,CustomerPrice
,SalesOrder
,PONumber
,Approved
,OEM
,Platform
,YearModel
,Vehicle
,ContPrice
,SalePrice
,Tooltagrequired
,Mold
,Machine
,AssyStations
,ToolingPO
,ToolingQuote
,QuoteNumber
,QuotedPrice
,CommentChangePrice
,PlanoVI
,Print_no
,Print_date
,ImpactCost
from eehsql1.eeh.dbo.eng_woEngineer WITH (INDEX(idx1_WOEngineer))
where	left(part,7) like '%'+@base_part+'%'
order by TransDt


GO
