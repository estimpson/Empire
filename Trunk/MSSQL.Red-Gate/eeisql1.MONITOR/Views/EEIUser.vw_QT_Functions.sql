SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create view [EEIUser].[vw_QT_Functions]
as
select
	f.FunctionCode
,	row_number() over(order by f.FunctionCode) as RowId
from 
	eeiuser.QT_Functions f



GO
