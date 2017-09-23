SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE view [EEIUser].[ST_CustomersAll]
as
select
	isnull(row_number() OVER (ORDER BY sls.Customer), - 1) AS RowNumber 
,	sls.Customer
,	sls.Region
from 
	EEIUser.ST_LightingStudy_2016 sls 
group by
	sls.Customer
,	sls.Region



GO
