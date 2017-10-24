SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwPartBasePart_Crossref]
as
select	BasePart = BaseParts.BasePart,
	PartECN = part.part
from	FT.BaseParts BaseParts
	join part on part.part like BaseParts.BasePart + '%'
where	part.type = 'F'
GO
