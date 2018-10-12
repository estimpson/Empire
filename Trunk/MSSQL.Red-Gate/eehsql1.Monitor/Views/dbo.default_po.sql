SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[default_po] as
select	*
from	EEH.[dbo].[default_po] with (READUNCOMMITTED)
GO
