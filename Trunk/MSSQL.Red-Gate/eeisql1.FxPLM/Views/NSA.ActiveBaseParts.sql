SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [NSA].[ActiveBaseParts]
as
select
	BaseParts.BasePart
,	RowID = isnull(row_number() over (order by BaseParts.BasePart), 0)
from
	(	select distinct
			BasePart = left(p.part, 7)
		from
			MONITOR.dbo.part p
		where
			p.part like '[A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9]-H%'
	) BaseParts
GO
