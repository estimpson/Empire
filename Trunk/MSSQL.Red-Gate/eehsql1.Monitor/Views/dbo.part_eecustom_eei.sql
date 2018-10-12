SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[part_eecustom_eei] as
select	*
from	EEH.[dbo].[part_eecustom_eei] with (READUNCOMMITTED)
GO
