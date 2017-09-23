SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [FT].[sp_rpt_OnHoldInventorybyLocation]
as 

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

declare	@Date		date

select		@Date =getdate()

select	location,
			part,
			quantity,
			parent_serial,
			serial,
			status
from		dbo.object o
where	status!= 'A' and exists (select 1 from order_detail where part_number = o.part and due_date < dateadd(dd,15,@date) and quantity >1)
order	by	part,
					location,
					serial
GO
