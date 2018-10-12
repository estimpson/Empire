SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [FT].[ftvwPartCustomer] as
select	*
from	EEH.[FT].[ftvwPartCustomer] with (READUNCOMMITTED)
GO
