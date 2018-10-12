SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[cic_fin_part] as
select	*
from	EEH.[dbo].[cic_fin_part] with (READUNCOMMITTED)
GO
