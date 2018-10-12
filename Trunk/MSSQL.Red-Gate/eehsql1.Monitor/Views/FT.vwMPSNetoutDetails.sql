SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwMPSNetoutDetails] as
select	*
from	EEH.[FT].[vwMPSNetoutDetails] with (READUNCOMMITTED)
GO
