SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[contact_xref] as
select	*
from	EEH.[dbo].[contact_xref] with (READUNCOMMITTED)
GO
