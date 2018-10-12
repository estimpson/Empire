SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[sqlanyap_headersissue] as
select	*
from	EEH.[dbo].[sqlanyap_headersissue] with (READUNCOMMITTED)
GO
