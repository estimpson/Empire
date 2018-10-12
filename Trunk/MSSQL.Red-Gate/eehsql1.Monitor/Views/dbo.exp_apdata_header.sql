SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[exp_apdata_header] as
select	*
from	EEH.[dbo].[exp_apdata_header] with (READUNCOMMITTED)
GO
