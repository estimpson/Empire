SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[cdi_vprating] as
select	*
from	EEH.[dbo].[cdi_vprating] with (READUNCOMMITTED)
GO
