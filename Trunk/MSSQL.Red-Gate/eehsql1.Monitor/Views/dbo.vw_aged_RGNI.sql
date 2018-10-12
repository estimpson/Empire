SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_aged_RGNI] as
select	*
from	EEH.[dbo].[vw_aged_RGNI] with (READUNCOMMITTED)
GO
