SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FTP].[usp_ReceiveCustomerEDI_OutboundErrorFolderNotEmpty_Notification]
	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_warnings off
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. FTP.usp_Test
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
set ansi_warnings on

declare
	@errorFileCount int

select
	@errorFileCount = uds.RootFileCount + uds.RootSubFolderCount
from
	RAWEDIDATA_FS.udf_DIR_Summary('\CustomerEDI\Outbound\Error') uds

if	@errorFileCount = 0 begin
	/*	Nothing to do here. */
	set ansi_warnings off
	rollback tran @ProcName
	set	@Result = 100
	return
		@Result
end

/*	Generate email notification and send.*/
select
	ud.CreateDT
,	ud.WriteDT
,	ud.AccessDT
,	ud.IsDir
,	ud.Name
,	ud.Path
,	ud.FileSize
into
	#ErrorFolderContents
from
	RAWEDIDATA_FS.udf_DIR('\CustomerEDI\Outbound\Error',1) ud
where
	ud.Name not in ('.', '..')

declare @html nvarchar(max)
		
exec
	FxEDI.FT.usp_TableToHTML
	@tableName = '#ErrorFolderContents'
,   @html = @html out
,	@orderBy = 'CreateDT desc'

declare
	@EmailBody nvarchar(max)
,   @EmailHeader nvarchar(max) = '(' + convert(varchar, @errorFileCount) + ') Files/Folders in CustomerEDI\Outbound\Error folder' 

select
	@EmailBody = N'<H1>' + @EmailHeader + N'</H1>' + @html

select
	*
from
	#ErrorFolderContents
print @emailBody

exec msdb.dbo.sp_send_dbmail
	@profile_name = 'SRVSQL2dBMail'
,   @recipients = 'SQLServeralert@empireelect.com'
,	@copy_recipients = 'spetrovski@empireelect.com;estimpson@fore-thought.com;aboulanger@fore-thought.com;dwest@empireelect.com' -- varchar(max)
,   @subject = @EmailHeader
,   @body = @EmailBody
,   @body_format = 'HTML'
,   @importance = 'High'  -- varchar(6)	
--- </Body>
set ansi_warnings off

---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>

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
	@ProcReturn = FTP.usp_ReceiveCustomerEDI_OutboundErrorFolderNotEmpty_Notification
	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

if	@@trancount > 0 begin
	rollback
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
