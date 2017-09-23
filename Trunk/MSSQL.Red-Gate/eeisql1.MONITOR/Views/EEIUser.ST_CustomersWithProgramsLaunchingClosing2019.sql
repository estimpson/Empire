SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




create view [EEIUser].[ST_CustomersWithProgramsLaunchingClosing2019]
as
select 
	isnull(row_number() over(order by ls.Customer), -1) as RowNumber
,	ls.Customer
,	ls.Region
from 
	EEIUser.vw_ST_LightingStudy_2016 ls
where
	ls.Volume2019 > 0
		and (year(ls.SOP) = 2019 or year(ls.EOP) = 2019)
group by
	ls.Customer
,	ls.Region



GO
