SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_top_RGNI] as
select	*
from	EEH.[dbo].[vw_top_RGNI] with (READUNCOMMITTED)
GO
