SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[ftvweBillOfMaterial] as
select	*
from	EEH.[FT].[ftvweBillOfMaterial] with (READUNCOMMITTED)
GO
