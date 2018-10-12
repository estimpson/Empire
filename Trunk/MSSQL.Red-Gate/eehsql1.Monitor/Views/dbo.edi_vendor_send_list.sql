SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[edi_vendor_send_list] as
select	*
from	EEH.[dbo].[edi_vendor_send_list] with (READUNCOMMITTED)
GO
