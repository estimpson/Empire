SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[edi_setups] as
select	*
from	EEH.[dbo].[edi_setups] with (READUNCOMMITTED)
GO
