SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[ftvwCustomers] as
select	*
from	EEH.[FT].[ftvwCustomers] with (READUNCOMMITTED)
GO
