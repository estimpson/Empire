SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[edi_hw830_header] as
select	*
from	EEH.[dbo].[edi_hw830_header] with (READUNCOMMITTED)
GO
