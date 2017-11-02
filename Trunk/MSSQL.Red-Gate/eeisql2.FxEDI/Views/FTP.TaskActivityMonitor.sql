SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FTP].[TaskActivityMonitor]
as
select
	TaskName = 'Retrieve XML'
,	LastRunOutcome = 'unavailable'
,	LastRun = null
,	NextRun = null
,	RowID = 1
union all
select
	TaskName = 'Monitor iExchangeWeb Inbound EDI Archive Folder'
,	LastRunOutcome = 'Success'
,	LastRun =
		(	select
				max(rdp.ScheduledPollDT)
			from
				FTP.ReceivedDirectoryPoll rdp
			where
				rdp.Status = 1
				and rdp.ScheduledPollDT > getdate() - 1
		)
,	NextRun =
		(	select
				case when min(rdp.ScheduledPollDT) < getdate() then getdate() else min(rdp.ScheduledPollDT) end
			from
				FTP.ReceivedDirectoryPoll rdp
			where
				rdp.Status = 0
				and rdp.ScheduledPollDT >
					(	select
							max(rdp2.ScheduledPollDT)
						from
							FTP.ReceivedDirectoryPoll rdp2
						where
							rdp2.Status > 0
				
					)
		)
,	RowID = 2
union all
select
	TaskName = 'Retrieve Missing File'
,	LastRunOutcome = 'Success'
,	LastRun = dateadd(minute, floor(datediff(minute, dbo.udf_Today(), getdate()) / 5) * 5, dbo.udf_Today())
,	NextRun =
		case
			when exists
				(	select
						*
					from
						FTP.MissingFileList mfl
					where
						mfl.SourceFileDT < dateadd(minute, -5, getdate())
				) then getdate()
		end
,	RowID = 3
union all
select
	TaskName = 'Replace Bad/Corrupt File'
,	LastRunOutcome = 'Success'
,	LastRun = dateadd(minute, floor(datediff(minute, dbo.udf_Today(), getdate()) / 5) * 5, dbo.udf_Today())
,	NextRun =
		case
			when exists
				(	select
						*
					from
						FTP.BadFileList bfl
				) then getdate()
		end

,	RowID = 4
union all
select
	TaskName = 'Update Received Directory Poll'
,	LastRunOutcome = 'Success'
,	LastRun =
		(	select
				max(rdp.RowCreateDT)
			from
				FTP.ReceivedDirectoryPoll rdp
		)
,	NextRun =
		case
			when not exists
				(	select
						*
					from
						FTP.ReceivedDirectoryPoll rdp
					where
						rdp.PollWindowBeginDT > getdate() + 1
				) then getdate()
		end

,	RowID = 5
GO
