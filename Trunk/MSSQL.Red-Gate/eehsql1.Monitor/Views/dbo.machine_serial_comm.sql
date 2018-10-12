SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[machine_serial_comm] as
select	*
from	EEH.[dbo].[machine_serial_comm] with (READUNCOMMITTED)
GO
