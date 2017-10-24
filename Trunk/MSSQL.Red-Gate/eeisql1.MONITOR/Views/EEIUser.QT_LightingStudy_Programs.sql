SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [EEIUser].[QT_LightingStudy_Programs]
as
select
	sls.Program
,	isnull(row_number() over(order by sls.Program), -1) as RowId
from 
	eeiuser.ST_LightingStudy_2016 sls
group by 
	sls.Program 
GO
