SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[addresses_geocode] as
select	*
from	EEH.[dbo].[addresses_geocode] with (READUNCOMMITTED)
GO
