use EEH
go

select
	1.0 * max(sys.sysindexes.rowcnt) / 45843458
		--(	select
		--		count(*)
		--	from
		--		dbo.po_receiver_items_historical_daily prihd
		--	where
		--		prihd.time_stamp > dateadd(month, -3, getdate())
		--)
,	convert(varchar, max(sys.sysindexes.rowcnt)) + ' of 45843458'
,	'Complete in ' + convert(varchar, convert(int, datediff(minute, '2014-02-03 14:42:54.760', getdate()) * 1.0 / max(sys.sysindexes.rowcnt) * (45843458 - max(sys.sysindexes.rowcnt)))) + ' minutes and '
	 + convert(varchar,convert(int,(datediff(minute, '2014-02-03 14:42:54.760', getdate()) * 1.0 / max(sys.sysindexes.rowcnt) * (45843458 - max(sys.sysindexes.rowcnt)) * 60) % 60)) + ' seconds.'
from
	sysindexes
where
	id = object_id('dbo.po_receiver_items_historical_daily_new')
