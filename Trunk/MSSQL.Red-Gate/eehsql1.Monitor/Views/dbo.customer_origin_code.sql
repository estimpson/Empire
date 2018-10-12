SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[customer_origin_code] as
select	*
from	EEH.[dbo].[customer_origin_code] with (READUNCOMMITTED)
GO
