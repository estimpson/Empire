SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[edi_po] as
select	*
from	EEH.[dbo].[edi_po] with (READUNCOMMITTED)
GO
