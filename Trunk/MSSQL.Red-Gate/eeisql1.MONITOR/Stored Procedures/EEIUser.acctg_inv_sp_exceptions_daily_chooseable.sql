SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[acctg_inv_sp_exceptions_daily_chooseable] @begdate datetime, @enddate datetime 
as
declare	@rundate datetime;


select	@rundate = getdate();


create table #a 
	(
		serial varchar(10),
		part varchar(50),
		beg_bal decimal(18,6),
		r_qty decimal(18,6),
		u_qty decimal(18,6),
		a_qty decimal(18,6),
		s_qty decimal(18,6),
		v_qty decimal(18,6),
		d_serial varchar(50),
		d_qty decimal(18,6),
		q_serial varchar(50),
		q_qty decimal(18,6),
		sc_qty decimal(18,6),
		end_bal decimal(18,6),
		tie decimal(18,6),
		status varchar(50)
	)

insert into	#a (serial, part)
	(
		select	serial, 
				part
		from	object_historical_daily 
		where	time_stamp = @begdate 
				and part <> 'PALLET'
	union
		select	serial, 
				part 
		from	object_historical_daily 
		where	time_stamp = @enddate 
				and part <> 'PALLET'
	union
		select	serial, 
				part
		from	audit_trail 
		where	date_stamp >= @begdate 
				and date_stamp < @enddate
				and type in ('R','U','A','S','V','D','Q')
				and part <> 'PALLET'
	)


update		#a 
set			beg_bal = (select ISNULL(quantity,0) from object_historical_daily where time_stamp = @begdate and object_historical_daily.serial = #a.serial),
			end_bal = (select ISNULL(quantity,0) from object_historical_daily where time_stamp = @enddate and object_historical_daily.serial = #a.serial)


update		#a
set			r_qty = (select sum(quantity) from audit_trail at where date_stamp >= @begdate and date_stamp < @enddate and type = 'R' and at.serial = #a.serial),
			u_qty = (select sum(quantity) from audit_trail at where date_stamp >= @begdate and date_stamp < @enddate and type = 'U' and at.serial = #a.serial),
			a_qty = (select sum(quantity) from audit_trail at where date_stamp >= @begdate and date_stamp < @enddate and type = 'A' and at.serial = #a.serial),
			s_qty = (select sum(quantity) from audit_trail at where date_stamp >= @begdate and date_stamp < @enddate and type = 'S' and at.serial = #a.serial),
			v_qty = (select sum(quantity) from audit_trail at where date_stamp >= @begdate and date_stamp < @enddate and type = 'V' and at.serial = #a.serial),
			d_serial = (select max(serial) from audit_trail at where date_stamp >= @begdate and date_stamp < @enddate and type = 'D' and at.serial = #a.serial),
			d_qty = (select sum(quantity) from audit_trail at where date_stamp >= @begdate and date_stamp < @enddate and type = 'D' and at.serial = #a.serial),
			q_serial = (select max(serial) from audit_trail at where date_stamp >= @begdate and date_stamp < @enddate and type = 'Q' and at.serial = #a.serial),
			q_qty = (select sum(quantity) from audit_trail at where date_stamp >= @begdate and date_stamp < @enddate and type = 'Q' and at.serial = #a.serial)
from		#a,
			audit_trail
where		#a.serial = audit_trail.serial
			and audit_trail.date_stamp >= @begdate
			and audit_trail.date_stamp < @enddate


update		#a
set			sc_qty = (case d_serial when q_serial then ISNULL(q_qty,0) else 0 end)


update		#a
set			tie = (isnull(beg_bal,0)+isnull(r_qty,0)+isnull(u_qty,0)+isnull(a_qty,0)-isnull(s_qty,0)-isnull(v_qty,0)-isnull(sc_qty,0))

update		#a
set			status = (case ISNULL(tie,0) when ISNULL(end_bal,0) then 'OK' else 'NOT OK' end)

insert into eeiuser.acctg_inv_exceptions_daily
select @rundate as rundate, @begdate as begdate, @enddate as enddate, * from #a 
--where status <> 'OK'

select * from eeiuser.acctg_inv_exceptions_daily
GO
