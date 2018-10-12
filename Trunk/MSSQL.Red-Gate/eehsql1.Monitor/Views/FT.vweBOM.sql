SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vweBOM] as
select	*
from	EEH.[FT].[vweBOM] with (READUNCOMMITTED)
GO
