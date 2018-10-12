SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_eei_noATforSerial] as
select	*
from	EEH.[dbo].[vw_eei_noATforSerial] with (READUNCOMMITTED)
GO
