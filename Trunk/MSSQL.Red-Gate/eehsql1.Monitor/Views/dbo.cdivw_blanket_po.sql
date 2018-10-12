SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[cdivw_blanket_po] as
select	*
from	EEH.[dbo].[cdivw_blanket_po] with (READUNCOMMITTED)
GO
