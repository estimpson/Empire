SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vdp_table] as
select	*
from	EEH.[dbo].[vdp_table] with (READUNCOMMITTED)
GO
