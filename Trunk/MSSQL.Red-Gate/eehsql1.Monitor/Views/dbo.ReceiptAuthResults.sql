SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[ReceiptAuthResults] as
select	*
from	EEH.[dbo].[ReceiptAuthResults] with (READUNCOMMITTED)
GO
