SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[BillOfMaterial] as
select	*
from	EEH.[FT].[BillOfMaterial] with (READUNCOMMITTED)
GO
