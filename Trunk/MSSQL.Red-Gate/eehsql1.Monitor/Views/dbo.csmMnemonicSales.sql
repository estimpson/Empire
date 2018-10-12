SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[csmMnemonicSales] as
select	*
from	EEH.[dbo].[csmMnemonicSales] with (READUNCOMMITTED)
GO
