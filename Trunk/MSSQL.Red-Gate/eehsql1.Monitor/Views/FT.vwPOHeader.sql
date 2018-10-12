SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vwPOHeader] as
select	*
from	EEH.[FT].[vwPOHeader] with (READUNCOMMITTED)
GO
