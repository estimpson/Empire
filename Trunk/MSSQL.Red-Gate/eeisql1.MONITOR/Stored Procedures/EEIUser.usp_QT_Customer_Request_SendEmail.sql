SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[usp_QT_Customer_Request_SendEmail]
	@CustomerCode varchar(50)
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
	@OperatorName varchar(50)

select
	@Operatorname = e.name
from
	eeiuser.QT_CustomersNew cn
	join dbo.employee e
		on e.operator_code = cn.RowCreateUser
where
	cn.CustomerCode = @CustomerCode


declare
	@EmailBody nvarchar(max)
,	@EmailHeader nvarchar(max) = 'New Customer Request' 

select
	@EmailBody = @OperatorName + 
	N' has requested ' + @CustomerCode +
	N' as a new customer.' +
	N'<br /><br />' + 
	N'http://evision/webportal'  

exec msdb.dbo.sp_send_dbmail
		@profile_name = 'DBMail'-- sysname
,		@recipients = 'DWest@empireelect.com'
--,		@copy_recipients = 'gurbina@empireelect.com;dwest@empireelect.com' -- varchar(max)
, 		@subject = @EmailHeader
,  		@body = @EmailBody
,  		@body_format = 'HTML'
,		@importance = 'Normal'  -- varchar(6)	
--- </Body>	


if @initialtrancount = 0  
    commit transaction @ProcName;  

GO
