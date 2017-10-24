SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [FT].[ftvwPart]
(	Part )
as
--	Description:
--	Get a list of parts.
select	Part = part.part
from	dbo.part
GO
