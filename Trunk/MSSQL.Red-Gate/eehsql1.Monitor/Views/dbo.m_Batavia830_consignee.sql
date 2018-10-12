SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[m_Batavia830_consignee] as
select	*
from	EEH.[dbo].[m_Batavia830_consignee] with (READUNCOMMITTED)
GO
