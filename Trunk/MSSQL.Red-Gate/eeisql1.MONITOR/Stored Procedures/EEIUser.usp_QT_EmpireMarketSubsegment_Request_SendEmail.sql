SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[usp_QT_EmpireMarketSubsegment_Request_SendEmail]
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
	@OperatorName varchar(50)

select
	@Operatorname = e.name
from
	eeiuser.QT_EmpireMarketSubsegment ems
	join dbo.employee e
		on e.operator_code = ems.RowCreateUser
where
	ems.EmpireMarketSubsegment = @EmpireMarketSubsegment


declare
	@EmailBody nvarchar(max)
,	@EmailHeader nvarchar(max) = 'New Empire Market Subsegment Request' 

select
	@EmailBody = @OperatorName + 
	N' has requested ' + @EmpireMarketSubsegment +
	N' as a new Empire Market Subsegment.' +
	N'<br /><br />' + 
	N'http://evision/webportal'  

exec msdb.dbo.sp_send_dbmail
		@profile_name = 'DBMail'-- sysname
,		@recipients = 'kdoman2@empireelect.com'
--,		@copy_recipients = 'gurbina@empireelect.com;dwest@empireelect.com' -- varchar(max)
, 		@subject = @EmailHeader
,  		@body = @EmailBody
,  		@body_format = 'HTML'
,		@importance = 'Normal'  -- varchar(6)	
--- </Body>	


if @initialtrancount = 0  
    commit transaction @ProcName;  

GO
