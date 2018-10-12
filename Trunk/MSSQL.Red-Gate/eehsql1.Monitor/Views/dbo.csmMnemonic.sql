SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[csmMnemonic] as
select	*
from	EEH.[dbo].[csmMnemonic] with (READUNCOMMITTED)
GO
