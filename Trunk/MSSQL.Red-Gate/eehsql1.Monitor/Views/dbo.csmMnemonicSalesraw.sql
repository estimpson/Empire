SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[csmMnemonicSalesraw] as
select	*
from	EEH.[dbo].[csmMnemonicSalesraw] with (READUNCOMMITTED)
GO
