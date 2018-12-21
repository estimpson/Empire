SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EEIUser].[vw_QT_ProductLines]
as
select
	pl.id as ProductLine
,	row_number() over(order by pl.id) as RowId
from 
	dbo.product_line pl

GO
