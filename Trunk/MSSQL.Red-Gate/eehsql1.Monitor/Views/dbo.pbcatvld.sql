SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[pbcatvld] as
select	*
from	EEH.[dbo].[pbcatvld] with (READUNCOMMITTED)
GO
