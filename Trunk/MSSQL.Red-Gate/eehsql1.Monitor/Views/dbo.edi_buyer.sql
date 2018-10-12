SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[edi_buyer] as
select	*
from	EEH.[dbo].[edi_buyer] with (READUNCOMMITTED)
GO
