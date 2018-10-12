SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[OMARawParts] as
select	*
from	EEH.[FT].[OMARawParts] with (READUNCOMMITTED)
GO
