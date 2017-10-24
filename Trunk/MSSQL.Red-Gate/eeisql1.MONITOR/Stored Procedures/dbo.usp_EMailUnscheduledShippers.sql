SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



Create procedure [dbo].[usp_EMailUnscheduledShippers]
	@TranDT datetime = null out
,	@Result integer = null out
,	@DBMail tinyint = 1
as
set nocount on
set ansi_warnings off
set	@Result = 999999
set	ansi_warnings ON

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname  = N'#UnscheduledShippingRequirements',
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer,
	@SchedulerEmailAddress varchar(255),
	@SchedulerInitials varchar(25)

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. <schema_name, sysname, dbo>.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>

	--Get Unscheduled Shippers
	
		
	select 
		od.order_no,
		od.destination,
		od.part_number,
		od.customer_part,
		od.due_date,
		od.quantity as Qty_Due,
		coalesce(od.committed_qty,0) as Qty_Scheduled,
		(Select sum(quantity) from object where status = 'A' and part = part_number and plant not like '%TRAN%') as ApprovedInventory,
		coalesce(nullif(d.scheduler,''),'NotDefined') as Scheduler
  into
	#UnscheduledShippingRequirements	
	from
		order_detail od
	join
		order_header oh on oh.order_no = od.order_no
	join
		destination d on d.destination =oh.destination
	where
		od.due_date <= dateadd(dd, 1, getdate())
		and od.quantity > coalesce(od.committed_qty,0) 
		and oh.customer not in (Select distinct customer from order_header where customer like 'EE%')
		--and od.destination not like 'VT%'
	
		
		-- Create HTML and E-Mail
If exists ( Select 1 from #UnscheduledShippingRequirements )	
and @DBMail = 1



SELECT @SchedulerInitials
		= MIN(Scheduler)
	FROM
		#UnscheduledShippingRequirements

		SELECT @SchedulerEmailAddress
		= [FT].[fn_ReturnSchedulerEMailAddress] ( @SchedulerInitials)

Begin	
		declare
			@html nvarchar(max),
			@EmailTableName sysname  = N'#UnscheduledShippingRequirements'


			exec [FT].[usp_TableToHTML]
			@tableName = @Emailtablename
		,   @OrderBy = '[Scheduler],[destination], [part_number], [due_date]'
		,	@html = @html out
		
		declare
			@EmailBody nvarchar(max)
		,	@EmailHeader nvarchar(max) = 'Unscheduled Shipping Requirements Alert (SQLJob:EMailUnscheduledShippingRequirements)' 

		select
			@EmailBody =
				N'<H1>' + @EmailHeader + N'</H1>' +
				@html

	--print @emailBody

	exec msdb.dbo.sp_send_dbmail
		@profile_name = 'DBMail'-- sysname
	,	@recipients = @SchedulerEmailAddress -- varchar(max)
	,	@copy_recipients = 'dwest@empireelect.com;aboulanger@fore-thought.com;gurbina@empireelect.com' -- varchar(max)
	, 	@subject = @EmailHeader
	,  	@body = @EmailBody
	,  	@body_format = 'HTML'
	,	@importance = 'High'  -- varchar(6)	



		
		
End					

--- </Body>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>

/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go


begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_EMailUnscheduledShippers
	@TranDT = @TranDT out
,	@Result = @ProcResult out
,	@dbMail = 1


set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

if	@@trancount > 0 begin
	commit
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/









GO
