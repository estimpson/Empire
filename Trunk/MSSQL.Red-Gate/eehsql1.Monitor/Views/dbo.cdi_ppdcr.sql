SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[cdi_ppdcr] as
select	*
from	EEH.[dbo].[cdi_ppdcr] with (READUNCOMMITTED)
GO
