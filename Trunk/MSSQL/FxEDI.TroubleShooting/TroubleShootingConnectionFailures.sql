select
	*
from
	FTP.LogHeaders lh
	join FTP.LogDetails ld
		on ld.FLHRowID = lh.RowID
where
	lh.RowCreateDT > getdate() - 100
	and ld.CommandOutput like '%Connection failed.%'
order by
	ld.RowCreateDT desc

select
	Date = convert(date,min(ld.RowCreateDT))
,	FTPConnectionFailureCount = count(*)
from
	FTP.LogHeaders lh
	join FTP.LogDetails ld
		on ld.FLHRowID = lh.RowID
where
	lh.RowCreateDT > getdate() - 1000
	and ld.CommandOutput like '%Connection failed.%'
group by
	datediff(day, getdate(), lh.RowCreateDT)
having
	count(*) > 10
order by
	datediff(day, getdate(), lh.RowCreateDT) desc

