SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[machine_data_1050] as
select	*
from	EEH.[dbo].[machine_data_1050] with (READUNCOMMITTED)
GO
