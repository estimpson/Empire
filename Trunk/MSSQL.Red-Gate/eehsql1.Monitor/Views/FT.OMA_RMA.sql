SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[OMA_RMA] as
select	*
from	EEH.[FT].[OMA_RMA] with (READUNCOMMITTED)
GO
