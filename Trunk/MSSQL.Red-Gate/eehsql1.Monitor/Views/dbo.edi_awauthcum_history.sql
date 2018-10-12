SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[edi_awauthcum_history] as
select	*
from	EEH.[dbo].[edi_awauthcum_history] with (READUNCOMMITTED)
GO
