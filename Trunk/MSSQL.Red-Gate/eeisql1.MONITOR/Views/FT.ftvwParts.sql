SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[ftvwParts]
(	Code,
	Name,
	CrossRef,
	Class,
	Type,
	ProductLine,
	Commodity,
	GroupTech )
as
select	part, name, cross_ref, class, type, product_line, commodity, group_technology
from	dbo.part
where	class != 'O'
GO
