SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create view [dbo].[vw_eei_BasePart_Description]
as

Select Left(Part,7) BasePart,
	max(name) PartDescription
from Part
where	part.class = 'P' and
		part.type = 'F'  
group by  Left(Part,7)
GO
