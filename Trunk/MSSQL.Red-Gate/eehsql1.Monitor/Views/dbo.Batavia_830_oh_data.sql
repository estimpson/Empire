SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[Batavia_830_oh_data] as
select	*
from	EEH.[dbo].[Batavia_830_oh_data] with (READUNCOMMITTED)
GO
