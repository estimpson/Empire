SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[quote] as
select	*
from	EEH.[dbo].[quote] with (READUNCOMMITTED)
GO
