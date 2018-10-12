SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[OMAEarlyReceipts] as
select	*
from	EEH.[FT].[OMAEarlyReceipts] with (READUNCOMMITTED)
GO
