SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [FT].[usp_Web_QuoteLog_NewCustomer_Deny_SendEmail]
	@OperatorCode varchar(5)
,	@CustomerCode varchar(50)
,	@ResponseNote varchar(250)
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
if (@ResponseNote <> '') begin

	--- <Update Rows="1">
	set	@TableName = 'eeiuser.QT_CustomersNew'
	update 
		cn
	set
		ResponseNote = @ResponseNote
	,	RowModifiedDT = getdate()
	,	RowModifiedUser = @OperatorCode
	from
		eeiuser.QT_CustomersNew cn
	where
		cn.CustomerCode = @CustomerCode
	
	select
		@RowCount = @@Rowcount
				
	if	@RowCount != 1 begin
		set @Result = -2
		raiserror ('Error updating table %s in procedure %s.  Rows updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback transaction @ProcName
		return
	end
	--- </Update Rows>

end


-- Send email notification
declare
	@Recipient nvarchar(100)

select
	@Recipient = coalesce(qel.EmailAddress, '')
from
	eeiuser.QT_CustomersNew cn
	left join eeiuser.QT_QuoteEmailList qel
		on qel.OperatorCode = cn.RowCreateUser
where
	cn.CustomerCode = @CustomerCode

if (@Recipient = '') begin
	set @Result = -1
	raiserror ('A confirmation email was not sent because the email address of the requestor is not in the system.', 16, 1)
	rollback transaction @ProcName
	return
end



declare
	@EmailBody nvarchar(max)
,	@EmailHeader nvarchar(max) = 'New Customer' 

select
	@EmailBody =  
	N'Customer ' + @CustomerCode +
	N' has been denied.' +
	N'<br /><br />' + 
	@ResponseNote

exec msdb.dbo.sp_send_dbmail
	@profile_name = 'DBMail'-- sysname
,	@recipients = @Recipient
--,	@copy_recipients = 'gurbina@empireelect.com;dwest@empireelect.com' -- varchar(max)
, 	@subject = @EmailHeader
,  	@body = @EmailBody
,  	@body_format = 'HTML'
,	@importance = 'Normal'  -- varchar(6)	
--- </Body>	


if @initialtrancount = 0  
    commit transaction @ProcName;   

GO
