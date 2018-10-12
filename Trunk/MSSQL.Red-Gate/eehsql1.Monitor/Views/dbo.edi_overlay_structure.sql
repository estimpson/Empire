SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[edi_overlay_structure] as
select	*
from	EEH.[dbo].[edi_overlay_structure] with (READUNCOMMITTED)
GO
