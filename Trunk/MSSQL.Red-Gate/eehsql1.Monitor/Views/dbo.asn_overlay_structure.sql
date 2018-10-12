SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[asn_overlay_structure] as
select	*
from	EEH.[dbo].[asn_overlay_structure] with (READUNCOMMITTED)
GO
