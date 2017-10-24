SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [FT].[usp_EmailFailedFTP]

as

Begin
Select 
	iConnectFileName = [filename],
	FileDate = RowCreateDT,
	Data,
	note = convert(varchar(255), 'If Data column is empty, find file(s) in iExchange just prior to RowCreateDT time and reporcess. If there is data in the data column, forward this email to iConnect support and ask that they correct the trading partner subscription / mapping.' )
into #MissingData

 from EDI.EDIDocuments where  RowCreateDT>= dateadd(hour, -36, getdate()) and status = 0 
 --if exists ( Select 1 from #MissingData)
 Begin
 DECLARE
			@html NVARCHAR(MAX),
			@EmailTableName sysname  = N'#MissingData'
		
		EXEC [FT].[usp_TableToHTML]
				@tableName = @Emailtablename
			,	@OrderBy = '[FileDate]'
			,	@html = @html OUT
		
		DECLARE
			@EmailBody NVARCHAR(MAX)
		,	@EmailHeader NVARCHAR(MAX) = 'FTP failed -  You must reprocess edi documents from iConnect' 

		SELECT
			@EmailBody =
				N'<H1>' + @EmailHeader + N'</H1>' +
				@html

	--print @emailBody

EXEC		[eeisql1].msdb.dbo.sp_send_dbmail
			@profile_name = 'DBMail'-- sysname
	,		@recipients = 'Gurbina@empireelect.com' -- varchar(max)
	,		@copy_recipients = 'aboulanger@fore-thought.com;dwest@empireelect.com' -- varchar(max)
	, 		@subject = @EmailHeader
	,  		@body = @EmailBody
	,  		@body_format = 'HTML'
	,		@importance = 'High' 

	End

	End
GO
