SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
create view [dbo].[vw_eei_customer_term]
as
Select	Customer, 
		description 
from		customer cross join term 
GO
