SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[BOM] as
select	*
from	EEH.[FT].[BOM] with (READUNCOMMITTED)
GO
