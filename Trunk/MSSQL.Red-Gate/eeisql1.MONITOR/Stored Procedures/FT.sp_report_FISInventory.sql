SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create	procedure [FT].[sp_report_FISInventory]
as
select	last_date LastDate,
			Serial,
			operator,
			location,
			part,
			quantity
from		dbo.object
where	location like '%FIS%' and
			part != 'PALLET'

GO
