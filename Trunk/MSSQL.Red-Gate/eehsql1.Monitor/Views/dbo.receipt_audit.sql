SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[receipt_audit] as
select	*
from	EEH.[dbo].[receipt_audit] with (READUNCOMMITTED)
GO
