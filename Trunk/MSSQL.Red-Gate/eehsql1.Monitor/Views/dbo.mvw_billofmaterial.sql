SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[mvw_billofmaterial] as
select	*
from	EEH.[dbo].[mvw_billofmaterial] with (READUNCOMMITTED)
GO
