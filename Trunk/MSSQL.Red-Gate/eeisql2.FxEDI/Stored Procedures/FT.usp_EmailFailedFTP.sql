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
	Data = left(isNULL(Nullif(convert(varchar(max), DATA),''),'   '),100) ,
	note = convert(varchar(max), 'If trading partner or version is blank forward this email to iConnect support and ask that they correct the trading partner subscription / mapping and reprocess the files affected. The case where the trading partner and version are not blank indicates that processing of these documents either is not configured or there is an issue processing documents. Please contact aboulanger@fore-thought.com for these cases'),
	TradingPartner = TradingPartner,
	[Version] = [Version]
into  #MissingData
 from EDI.EDIDocuments 
 where  
	RowCreateDT>= dateadd(MINUTE, -30, getdate()) and 
	[status] = 0 and
	convert(varchar(max), DATA) is Not Null and
	[type] is Not NULL
	and TradingPartner not in ('Chrysler', 'Pilot', 'Stanley Electric U.S. Co. Inc')
 
 
 if exists ( Select 1 from #MissingData)
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
		,	@EmailHeader NVARCHAR(MAX) = 'EDI File processing failed' 

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
