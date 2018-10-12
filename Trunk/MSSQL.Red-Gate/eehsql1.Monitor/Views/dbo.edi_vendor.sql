SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[edi_vendor] as
select	*
from	EEH.[dbo].[edi_vendor] with (READUNCOMMITTED)
GO
