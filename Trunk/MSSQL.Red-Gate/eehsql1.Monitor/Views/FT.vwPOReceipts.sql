SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwPOReceipts] as
select	*
from	EEH.[FT].[vwPOReceipts] with (READUNCOMMITTED)
GO
