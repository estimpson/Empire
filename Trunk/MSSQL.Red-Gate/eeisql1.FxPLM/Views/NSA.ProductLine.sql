SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




create view [NSA].[ProductLine]
as
select
	pl.id as ProductLine
,	RowID = isnull(row_number() over (order by pl.id), 0)
from
	MONITOR.dbo.product_line pl

GO
