SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create view [FT].[vwRansDiscretePOsShipped]
as
SELECT 'PO Number' as DiscreteType
		,[Qty]
		,[DiscretePONumber]
		,OrderNo
		,Shipper
  FROM [MONITOR].[dbo].[DiscretePONumbersShipped]
 union
SELECT 'RAN' as DiscreteType
      ,[Qty]
      ,[RanNumber]
      ,OrderNo
      ,Shipper
 
  FROM [MONITOR].[dbo].[AutoLivRanNumbersShipped]
 union
SELECT 'RAN' as DiscreteType
      ,[Qty]
      ,[RanNumber]
      ,OrderNo
      ,Shipper
 
  FROM [MONITOR].[dbo].[NALRanNumbersShipped] 
GO
