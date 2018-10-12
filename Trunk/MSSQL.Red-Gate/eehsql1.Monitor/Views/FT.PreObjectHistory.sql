SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[PreObjectHistory] as
select	*
from	EEH.[FT].[PreObjectHistory] with (READUNCOMMITTED)
GO
