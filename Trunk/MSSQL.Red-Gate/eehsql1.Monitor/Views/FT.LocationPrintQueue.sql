SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[LocationPrintQueue] as
select	*
from	EEH.[FT].[LocationPrintQueue] with (READUNCOMMITTED)
GO
