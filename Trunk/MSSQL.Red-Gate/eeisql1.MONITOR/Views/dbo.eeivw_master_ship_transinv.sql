SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[eeivw_master_ship_transinv]
as
select	part,
	location,
	appinv,
	nonappinv,
	week_no,
	day_of_week,
	trans_ship_date = dateadd (dd, (week_no - 1) * 7 + day_of_week - datepart (dw,
	case	when week_no > datepart (wk, getdate()) then convert (varchar(4), datepart(yy, getdate()) - 1)
		else convert (varchar(4), datepart (yy, getdate()))
	end + '/01/01'),
	case	when week_no > datepart (wk, getdate()) then convert (varchar(4), datepart(yy, getdate()) - 1)
		else convert (varchar(4), datepart (yy, getdate()))
	end + '/01/01')
from(	select	part = object.part,
			location = object.location,
			appinv = isnull (
			(	select	sum (o2.std_quantity)
				from	object o2
				where	o2.part = object.part and
					o2.location = object.location and
					o2.status = 'A'), 0),
			nonappinv = isnull (
				(	select	sum (o3.std_quantity)
					from	object o3
					where	o3.part = object.part and
						o3.location= object.location and
						o3.status != 'A'), 0),
			week_no = convert (varchar, substring (object.location, patindex ('%-%', object.location) + 1, 2)),
			day_of_week =
			case	when right(object.location, 2) = 'SU' then 1
				when right(object.location, 2) = 'MO' then 2
				when right(object.location, 2) = 'TU' then 3
				when right(object.location, 2) in('WD' ,'WE') then 4
				when right(object.location, 2) = 'TH' then 5
				when right(object.location, 2) = 'FR' then 6
				when right(object.location, 2) = 'SA' then 7
				else 1
			end
		from	object
		where	object.location like '%TRAN[0-9]-[0-9][0-9]%' and object.serial not in (Select serial from [MONITOR].[dbo].[object_copy_tran_notes]) and
			object.part != 'PALLET' and object.part not in (select part from eeiVW_MG)
		group by
			object.part,
			object.location ) Intransit
union
select	part,
	location,
	appinv,
	nonappinv,
	week_no,
	day_of_week,
	trans_ship_date = dateadd (dd, (week_no - 1) * 7 + day_of_week - datepart (dw,	case	when week_no > datepart (wk, getdate()) then convert (varchar(4), datepart(yy, getdate()) - 1)		else convert (varchar(4), datepart (yy, getdate()))	end + '/01/01'),	case	when week_no > datepart (wk, getdate()) then convert (varchar(4), datepart(yy, getdate()) - 1)		else convert (varchar(4), datepart (yy, getdate()))	end + '/01/01')
from	(	select	part = object.part,
			location = object.location,
			appinv = isnull (
			(	select	sum (o2.std_quantity)
				from	object o2
				where	o2.part = object.part and
					o2.last_date= object.last_date and
					o2.location = object.location and
					o2.status = 'A'), 0),
			nonappinv = isnull (
			(	select	sum (o3.std_quantity)
				from	object o3
				where	o3.part = object.part and
					o3.last_date= object.last_date and
					o3.location = object.location and
					o3.status != 'A'), 0),
			week_no = datepart (wk, object.last_date),
			day_of_week = datepart (dw, object.last_date)
		from	object
		where	object.location like '%AIR%' and
			object.part != 'PALLET' and object.part not in (select part from eeiVW_MG)
		group by
			object.part,
			object.location,
			object.last_date ) AirTransit
GO
