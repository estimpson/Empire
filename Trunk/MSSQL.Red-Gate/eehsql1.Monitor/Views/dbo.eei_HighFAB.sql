SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[eei_HighFAB] as
select	*
from	EEH.[dbo].[eei_HighFAB] with (READUNCOMMITTED)
GO
