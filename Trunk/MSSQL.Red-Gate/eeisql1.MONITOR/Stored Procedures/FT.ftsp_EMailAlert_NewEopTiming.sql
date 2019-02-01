SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [FT].[ftsp_EMailAlert_NewEopTiming]

--Returns new EOP timing for a base part in an EMail alert
	@BasePart varchar(50)
,	@NewTiming varchar(50)
,	@PriorTiming varchar(50)
,	@Reason varchar(50)
AS
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
SET	ANSI_WARNINGS ON


--- <Body>	
-- Create HTML and E-Mail		
DECLARE
	@EmailBody NVARCHAR(MAX)
,	@EmailHeader NVARCHAR(MAX) = 'New EOP Timing' 

SELECT
	@EmailBody = @BasePart + 
	N'<br /><br />' +
	N'Old Timing: ' + @PriorTiming +
	N'<br />' +
	N'New Timing: ' + @NewTiming +
	N'<br />' +
	N'Reason: ' + @Reason


EXEC msdb.dbo.sp_send_dbmail
		@profile_name = 'DBMail'-- sysname
,		@recipients = 'kdoman2@empireelect.com'
--,		@copy_recipients = 'gurbina@empireelect.com;dwest@empireelect.com' -- varchar(max)
, 		@subject = @EmailHeader
,  		@body = @EmailBody
,  		@body_format = 'HTML'
,		@importance = 'High'  -- varchar(6)				
--- </Body>

GO
