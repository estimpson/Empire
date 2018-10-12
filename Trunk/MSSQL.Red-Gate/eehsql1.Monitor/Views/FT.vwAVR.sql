SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwAVR] as
select	*
from	EEH.[FT].[vwAVR] with (READUNCOMMITTED)
GO
