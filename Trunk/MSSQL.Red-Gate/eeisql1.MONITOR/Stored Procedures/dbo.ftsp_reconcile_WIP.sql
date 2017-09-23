SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE		PROCEDURE [dbo].[ftsp_reconcile_WIP]
										(@fromDate datetime, @throughDate datetime)
as
Begin
SELECT	* 

INTO		#Transactions
From

(SELECT	part AS JCpart,
				ft.fn_TruncDate('dd',date_stamp) AS JCDate,
				SUM(quantity) AS JCQty,
				Posted AS JCPosted
			
FROM	dbo.audit_trail
WHERE	date_stamp>= ft.fn_TruncDate('dd',@fromDate )and
			date_stamp< dateadd(dd, 1, ft.fn_TruncDate('dd',@throughDate)) AND
			type = 'J'
Group BY ft.fn_TruncDate('dd',date_stamp), part, posted) JC

LEFT JOIN

(SELECT	part AS MIPart,
				ft.fn_TruncDate('dd',date_stamp) AS MIdate,
				SUM(quantity) AS MIQty,
				Posted AS MIPosted
			
FROM	dbo.audit_trail
WHERE	date_stamp>= ft.fn_TruncDate('dd',@fromDate )and
			date_stamp< dateadd(dd, 1, ft.fn_TruncDate('dd',@throughDate)) AND
			type = 'M'
Group BY ft.fn_TruncDate('dd',date_stamp), part, posted) MI ON JC.JCDate = MIdate
ORDER BY JCDate

SELECT	*, ( SELECT  Quantity FROM [dbo].[vweeiBOM] vBOM WHERE vBOM.FinishedPart = JCPart AND vBOM.RawPart = MIpart) AS BOMQty
INTO		#TransactionsBOM
FROM	#Transactions

SELECT	*, 
			(BOMQty*JCQty) AS StandardMI, 
			(Select MAX(material_cum) FROM dbo.part_standard_historical_daily WHERE ft.fn_TruncDate('dd', time_stamp)  = MIdate AND part = MIPart) AS RawPartMaterialCUMCost, 
			(Select MAX(material_cum) FROM dbo.part_standard_historical_daily WHERE ft.fn_TruncDate('dd', time_stamp) = JCDate AND part = JCpart) AS FinGoodPartMaterialCUMCost
FROM	#TransactionsBOM
WHERE	BOMQty IS NOT NULL
ORDER BY JCDate, MIpart

End



--EXEC dbo.ftsp_reconcile_WIP '2010-10-01', '2010-10-31'
GO
