SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[vweMinOnHand] as
select	*
from	EEH.[FT].[vweMinOnHand] with (READUNCOMMITTED)
GO
