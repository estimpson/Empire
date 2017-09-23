SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vw_aged_AR]
as
SELECT '0-30' as header, 
   sum(case when days_past_doc < 30 then amount-applied_amount end) as [0-30],
   0 as [30-60],
   0 as [60-90],
   0 as [Over 90]
from [dbo].ar_customer_aging
where applied_amount<>amount

union

SELECT '30-60' as header, 
   0 as [0-30],
   sum(case when days_past_doc BETWEEN 30 AND 60 then amount-applied_amount end) as [30-60],
   0 as [60-90],
   0 as [Over 90]
   from [dbo].ar_customer_aging
   where applied_amount<>amount


union


SELECT '60-90' as header, 
   0 as [0-30],
   0 as [30-60],
   sum(case when days_past_doc BETWEEN 60 AND 90 then amount-applied_amount end) as [60-90],
   0 as [Over 90]
   from [dbo].ar_customer_aging
   where applied_amount<>amount


union

SELECT 'Over 90' as header, 
   0 as [0-30],
   0 as [30-60],
   0 as [60-90],
   sum(case when days_past_doc > 90 then amount-applied_amount end) as [Over 90]
   from [dbo].ar_customer_aging
   where applied_amount<>amount
GO
