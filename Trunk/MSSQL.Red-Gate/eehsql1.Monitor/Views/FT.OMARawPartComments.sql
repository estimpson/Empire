SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[OMARawPartComments] as
select	*
from	EEH.[FT].[OMARawPartComments] with (READUNCOMMITTED)
GO
