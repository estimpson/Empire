SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[serial_asn] as
select	*
from	EEH.[dbo].[serial_asn] with (READUNCOMMITTED)
GO
