use msdb
go

alter procedure dbo.usp_EDI_MonitorLongRunningJobs
as
set nocount on
create table
	#RunningJobInfo
(	job_id uniqueidentifier
,	originating_server nvarchar(30)
,	name sysname
,	enabled tinyint
,	description nvarchar(512)
,	start_step_id int
,	category sysname
,	owner sysname
,	notify_level_eventlog int
,	notify_level_email int
,	notify_level_netsend int
,	notify_level_page int
,	notify_email_operator sysname
,	notify_netsend_operator sysname
,	notify_page_operator sysname
,	delete_level int
,	date_created datetime
,	date_modified datetime
,	version_number int
,	last_run_date int
,	last_run_time int
,	last_run_outcome int
,	next_run_date int
,	next_run_time int
,	next_run_schedule_id int
,	current_execution_status int
,	current_execution_step sysname
,	current_retry_attempt int
,	has_step int
,	has_schedule int
,	has_target int
,	type int
)

insert
	#RunningJobInfo
exec loopback.msdb.dbo.sp_help_job @execution_status = 1

select
	LastRunDT = sjob.start_execution_date
,	RunTimeMinutes = datediff(minute, sjob.start_execution_date, getdate())
,	JobName = rji.name
,   Description = rji.description
,   CurrentStep = rji.current_execution_step
into
	#AutoTermLongRunningJobs
from
	#RunningJobInfo rji
	cross apply
		(	select top 1
				*
			from
				msdb.dbo.sysjobactivity s
			where
				s.job_id = rji.job_id
				and s.session_id =
					(	select top 1
							ss.session_id
						from
							msdb.dbo.syssessions ss
						order by
							ss.agent_start_date desc
					)
				and coalesce(s.start_execution_date, s.run_requested_date) is not null
				and s.job_history_id is null
			order by
				s.start_execution_date desc
		) sjob
where
	datediff(minute, sjob.start_execution_date, getdate()) > 5
	and rji.name in
		(	select
				lrjatjl.JobName
			from
				dbo.LongRunningJobAutoTermJobList lrjatjl
		)

/*	Send email notification. */
if	@@ROWCOUNT > 0 begin
	declare @html nvarchar(max)
		
	exec
		FxEDI.FT.usp_TableToHTML
		@tableName = '#AutoTermLongRunningJobs'
	,   @html = @html out
		
	declare
		@EmailBody nvarchar(max)
	,   @EmailHeader nvarchar(max) = 'Terminating EDI Jobs - Compare Sent/Received Documents to iConnect'

	select
		@EmailBody = N'<H1>' + @EmailHeader + N'</H1>' + @html

	--print @emailBody

	exec msdb.dbo.sp_send_dbmail
		@profile_name = 'SRVSQL2dBMail'
	,   @recipients = 'SQLServeralert@empireelect.com'
	,	@copy_recipients = 'spetrovski@empireelect.com;estimpson@fore-thought.com;aboulanger@fore-thought.com;dwest@empireelect.com;gurbina@empireelect.com' -- varchar(max)
	,   @subject = @EmailHeader
	,   @body = @EmailBody
	,   @body_format = 'HTML'
	,   @importance = 'High'  -- varchar(6)	

	/*	Terminate the jobs. */
	declare
		TerminateJobs cursor local for
	select
		atlrj.JobName
	from
		#AutoTermLongRunningJobs atlrj

	open
		TerminateJobs

	while
		1 = 1 begin

		declare
			@JobName sysname

		fetch
			TerminateJobs
		into
			@JobName

		if	@@FETCH_STATUS != 0 begin
			break
		end

		exec dbo.sp_start_job
			@job_name = 'EDI: Terminate Long Running EDI Job'
	
	end

	close
		TerminateJobs
	end
go

