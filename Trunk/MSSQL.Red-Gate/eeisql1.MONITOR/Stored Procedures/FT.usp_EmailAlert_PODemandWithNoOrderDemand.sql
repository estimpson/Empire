SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [FT].[usp_EmailAlert_PODemandWithNoOrderDemand]

as
BEGIN

DECLARE @POList TABLE
	(	POnumber INT,
		PartNumber VARCHAR(25),
		Scheduler VARCHAR(25)
	)


DECLARE @EmailPOList TABLE
	(	POnumber INT,
		PartNumber VARCHAR(25)
	)

DECLARE @scheduler VARCHAR(25),
		@EmailAddress VARCHAR(max),
		@html NVARCHAR(MAX),
		@EmailTableName sysname  = N'ft.EmailPoList',
		@EmailBody NVARCHAR(MAX),
		@EmailHeader NVARCHAR(MAX) = 'EEH PO Demand Without Sales Order Demand' 

SELECT	@scheduler = '',
		@EmailAddress = '',
		@html = '',
		@EmailBody = ''


INSERT @POList
        ( POnumber, PartNumber, Scheduler )

SELECT 
	DISTINCT 
	po_number,
	part_number,
	COALESCE((SELECT MAX(scheduler) FROM destination WHERE destination IN (SELECT destination FROM order_header WHERE blanket_part = pod.part_number)),'N/A') AS Scheduler
FROM 
	po_detail pod

WHERE 
	date_due >= GETDATE()-30 and
	balance > 0  AND 
	part_number NOT IN  ( SELECT part_number FROM order_detail ) AND
	Part_number NOT IN (SELECT part FROM part WHERE type = 'R')


DECLARE
	SchedulerAlert CURSOR LOCAL FOR
SELECT
	DISTINCT Scheduler
FROM
	@POList
ORDER BY
	Scheduler

OPEN
	SchedulerAlert
WHILE
	1 = 1 BEGIN
	
	FETCH
		SchedulerAlert
	INTO
		@scheduler
			
	IF	@@FETCH_STATUS != 0 BEGIN
		BREAK
	END

	DELETE @EmailPOList

	INSERT @EmailPOList
	        ( POnumber, PartNumber )
	
	SELECT 
		 POnumber ,
		 PartNumber
	FROM
		@POList
	WHERE 
		Scheduler = @scheduler

	SELECT @EmailAddress = FT.[fn_ReturnSchedulerEMailAddress] (@scheduler)

	TRUNCATE TABLE ft.EmailPoList
	
	INSERT ft.EmailPoList
	        ( POnumber, PartNumber )

	SELECT 
		 POnumber ,
		 PartNumber
		#EmailPOList
	FROM
		@EmailPOList

	
		EXEC [FT].[usp_TableToHTML]
				@tableName = @Emailtablename
			,	@OrderBy = '[PartNumber]'
			,	@html = @html OUT
		
		

		SELECT
			@EmailBody =
				N'<H1>' + @EmailHeader + N'</H1>' +
				@html

	--print @emailBody

EXEC msdb.dbo.sp_send_dbmail
			@profile_name = 'DBMail'-- sysname
	,		@recipients = @EmailAddress -- varchar(max)
	,		@copy_recipients = 'aboulanger@fore-thought.com;dwest@empireelect.com' -- varchar(max)
	, 		@subject = @EmailHeader
	,  		@body = @EmailBody
	,  		@body_format = 'HTML'
	,		@importance = 'High' 



SELECT 	@EmailAddress = '',
		@html = '',
		@EmailBody = ''




	END

CLOSE	Scheduleralert 
DEALLOCATE	Scheduleralert
        

END


GO
