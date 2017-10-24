SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






create view [EEIUser].[ST_CustomersWithProgramsLaunchingClosing2017]
as
select 
	isnull(row_number() over(order by ls.Customer), -1) as RowNumber
,	ls.Customer
,	ls.Region
from 
	EEIUser.vw_ST_LightingStudy_2016 ls
where
	ls.Volume2017 > 0
	and (year(ls.SOP) = 2017 or year(ls.EOP) = 2017)
group by
	ls.Customer
,	Region



GO
