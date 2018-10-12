SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[edi_ff_layout] as
select	*
from	EEH.[dbo].[edi_ff_layout] with (READUNCOMMITTED)
GO
