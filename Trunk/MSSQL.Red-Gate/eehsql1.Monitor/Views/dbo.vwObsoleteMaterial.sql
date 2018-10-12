SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vwObsoleteMaterial] as
select	*
from	EEH.[dbo].[vwObsoleteMaterial] with (READUNCOMMITTED)
GO
