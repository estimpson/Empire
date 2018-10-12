SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[SqlAnyWkNMPS] as
select	*
from	EEH.[dbo].[SqlAnyWkNMPS] with (READUNCOMMITTED)
GO
