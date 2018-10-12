SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[XRt_old] as
select	*
from	EEH.[FT].[XRt_old] with (READUNCOMMITTED)
GO
