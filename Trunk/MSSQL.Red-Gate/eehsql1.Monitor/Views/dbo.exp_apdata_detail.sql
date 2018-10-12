SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[exp_apdata_detail] as
select	*
from	EEH.[dbo].[exp_apdata_detail] with (READUNCOMMITTED)
GO
