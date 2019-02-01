SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QL_QuoteTransfer_Complete_UpdateSendEmail]
	@OperatorCode varchar(5)
,	@QuoteNumber varchar(30)
,	@Complete char(1)
,	@CompletedDate datetime = null
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
	@trancount int = @@trancount
if	@trancount > 0
	save transaction @ProcName
else
	begin transaction @ProcName


---	<ArgumentValidation>
--- Operator is valid
if not exists (
		select
			1
		from
			dbo.employee e
		where
			e.operator_code = @OperatorCode ) begin

	set @Result = -1
	raiserror ('Invalid operator.', 16, 1)
	rollback transaction @ProcName
	return
end
---	</ArgumentValidation>



--- <Body>
--- <Update Rows="1">
set	@TableName = 'EEIUser.QT_QuoteLog'
update 
	EEIUser.QT_QuoteLog
set
	QuoteTransferComplete = @Complete
,	QuoteTransferCompletedDate = @CompletedDate
,	RowModifiedUser = @OperatorCode
where
	QuoteNumber = @QuoteNumber

select
	@RowCount = @@Rowcount
				
if	@RowCount != 1 begin
	set @Result = -2
	raiserror ('Error updating table %s in procedure %s.  Rows updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback transaction @ProcName
	return
end
--- </Update Rows>


--- If the quote transfer has been completed, send an email notification
if (@Complete = 'Y') begin

	declare
		@OperatorName varchar(50)

	select
		@Operatorname = e.name
	from
		dbo.employee e
	where
		e.operator_code = @OperatorCode


	declare
		@EmailBody nvarchar(max)
	,	@EmailHeader nvarchar(max) = 'Quote Transfer Completed' 

	select
		@EmailBody = @OperatorName + 
		N' has marked quote ' + @QuoteNumber +
		N' as transfer complete.' +
		N'<br /><br />'  

	exec msdb.dbo.sp_send_dbmail
			@profile_name = 'DBMail'-- sysname
	,		@recipients = 'dwest@empireelect.com'
	--,		@copy_recipients = 'gurbina@empireelect.com;dwest@empireelect.com' -- varchar(max)
	, 		@subject = @EmailHeader
	,  		@body = @EmailBody
	,  		@body_format = 'HTML'
	,		@importance = 'Normal'  -- varchar(6)	

end
--- </Body>


if @trancount = 0  
    commit transaction @ProcName;  
GO
