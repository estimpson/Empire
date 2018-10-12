SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[phone] as
select	*
from	EEH.[dbo].[phone] with (READUNCOMMITTED)
GO
