SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create view [EEIUser].[vw_web_psf_1] 
	(
	team,
	basepart,
	qty_shipped,
	extended)
as 
select
team,
basepart,
sum(qty_shipped),
sum(extended)
from vw_eei_sales_history
group by 
team,
basepart


GO
