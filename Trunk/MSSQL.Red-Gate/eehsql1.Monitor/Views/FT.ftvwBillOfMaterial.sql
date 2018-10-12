SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[ftvwBillOfMaterial] as
select	*
from	EEH.[FT].[ftvwBillOfMaterial] with (READUNCOMMITTED)
GO
