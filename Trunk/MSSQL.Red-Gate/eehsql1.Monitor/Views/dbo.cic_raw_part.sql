SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[cic_raw_part] as
select	*
from	EEH.[dbo].[cic_raw_part] with (READUNCOMMITTED)
GO
