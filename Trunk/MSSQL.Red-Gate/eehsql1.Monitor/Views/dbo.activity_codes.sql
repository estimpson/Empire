SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[activity_codes] as
select	*
from	EEH.[dbo].[activity_codes] with (READUNCOMMITTED)
GO
