SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [HN].[Customer_Destination] as
select	*
from	EEH.[HN].[Customer_Destination] with (READUNCOMMITTED)
GO
