SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[edi_setups_eei] as
select	*
from	EEH.[dbo].[edi_setups_eei] with (READUNCOMMITTED)
GO
