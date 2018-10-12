SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[web_sales_rec_1] as
select	*
from	EEH.[dbo].[web_sales_rec_1] with (READUNCOMMITTED)
GO
