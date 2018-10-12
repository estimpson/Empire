SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[eeivw_ars_exception_noorderstatus] as
select	*
from	EEH.[dbo].[eeivw_ars_exception_noorderstatus] with (READUNCOMMITTED)
GO
