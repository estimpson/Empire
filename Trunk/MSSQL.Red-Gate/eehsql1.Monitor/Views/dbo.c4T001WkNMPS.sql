SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[c4T001WkNMPS] as
select	*
from	EEH.[dbo].[c4T001WkNMPS] with (READUNCOMMITTED)
GO
