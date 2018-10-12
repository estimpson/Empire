SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[XRt] as
select	*
from	EEH.[FT].[XRt] with (READUNCOMMITTED)
GO
