SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwPRt] as
select	*
from	EEH.[FT].[vwPRt] with (READUNCOMMITTED)
GO
