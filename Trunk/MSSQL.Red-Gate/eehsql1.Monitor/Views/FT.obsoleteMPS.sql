SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[obsoleteMPS] as
select	*
from	EEH.[FT].[obsoleteMPS] with (READUNCOMMITTED)
GO
