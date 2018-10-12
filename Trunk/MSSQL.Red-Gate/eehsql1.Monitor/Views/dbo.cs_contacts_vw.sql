SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[cs_contacts_vw] as
select	*
from	EEH.[dbo].[cs_contacts_vw] with (READUNCOMMITTED)
GO
