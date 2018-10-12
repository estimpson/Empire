SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_RawQtyPerFinPart] as
select	*
from	EEH.[dbo].[vw_RawQtyPerFinPart] with (READUNCOMMITTED)
GO
