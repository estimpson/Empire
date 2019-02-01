SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [FT].[usp_Web_EmpireMarketSubsegment_ApproveDeny_SendEmail]
	@EmpireMarketSubsegment varchar(200)
,	@TranDT datetime = null out
,	@Result integer = null  out
as
set nocount on
set ansi_warnings on
set	@Result = 0

--- <Error Handling>
declare
	--@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	--@ProcReturn integer,
	--@ProcResult integer,
	--@Error integer,
	@RowCount integer


set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
set @TranDT = getdate()

declare
	@initialtrancount int = @@trancount
if	@initialtrancount > 0
	save transaction @ProcName
else
	begin transaction @ProcName
	 

--- <Body>	
declare
	@ApprovedDenied varchar(10)
,	@Note varchar(250)
,	@Recipient nvarchar(100)

select
	@ApprovedDenied = 
		case
			when ems.[Status] = 0 then 'approved'
			else 'denied'
		end
,	@Note = ems.ResponseNote
,	@Recipient = coalesce(qel.EmailAddress, '')
from
	eeiuser.QT_EmpireMarketSubsegment ems
	left join eeiuser.QT_QuoteEmailList qel
		on qel.OperatorCode = ems.RowCreateUser
where
	ems.EmpireMarketSubsegment = @EmpireMarketSubsegment

if (@Recipient = '') begin
	set @Result = -1
	raiserror ('A confirmation email was not sent because the email address of the requestor is not in the system.', 16, 1)
	rollback transaction @ProcName
	return
end



declare
	@EmailBody nvarchar(max)
,	@EmailHeader nvarchar(max) = 'Empire Market Subsegment Request' 

select
	@EmailBody =  
	N'Empire Market Subsegment ' + @EmpireMarketSubsegment +
	N' has been ' +
	@ApprovedDenied +
	N'.' +
	N'<br /><br />' + 
	@Note

exec msdb.dbo.sp_send_dbmail
		@profile_name = 'DBMail'-- sysname
,		@recipients = @Recipient
--,		@copy_recipients = 'gurbina@empireelect.com;dwest@empireelect.com' -- varchar(max)
, 		@subject = @EmailHeader
,  		@body = @EmailBody
,  		@body_format = 'HTML'
,		@importance = 'Normal'  -- varchar(6)	
--- </Body>	


if @initialtrancount = 0  
    commit transaction @ProcName;   

GO
