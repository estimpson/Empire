SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[edi_830_work] as
select	*
from	EEH.[dbo].[edi_830_work] with (READUNCOMMITTED)
GO
