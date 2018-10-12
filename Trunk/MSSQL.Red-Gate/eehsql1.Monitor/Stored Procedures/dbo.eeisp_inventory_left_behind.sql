SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[eeisp_inventory_left_behind]
as

declare @dates table (first_of_week datetime, oh_time_stamp datetime)

declare @i int;
declare @f datetime;
select @i = 0
select @f = ft.fn_truncdate_monday('wk',getdate())

While		 @i < 12
Begin	

		insert into @dates
		select @f, MAX(time_stamp) from object_historical_daily where time_stamp < @f

		select @i = @i+1
		select @f = DATEADD(d,-7,@f)

END


select ohd.time_stamp, left(ohd.part,3) as customer, ohd.part, ohd.location, SUM(ohd.quantity) as quantity, SUM(ohd.quantity/pi.standard_pack) as boxes 
from object_historical_daily ohd
left join part_inventory pi on ohd.part = pi.part
where ohd.time_stamp in (select oh_time_stamp from @dates) and ohd.location like '%LEFT%' and ohd.part <> 'PALLET' and ohd.status <> 'PRE-STOCK'
group by ohd.time_stamp, left(ohd.part,3), ohd.part, ohd.location 













GO
