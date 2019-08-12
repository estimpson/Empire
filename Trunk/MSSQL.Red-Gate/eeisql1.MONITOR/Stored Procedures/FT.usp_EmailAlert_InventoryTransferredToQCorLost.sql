SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [FT].[usp_EmailAlert_InventoryTransferredToQCorLost]

as
BEGIN

DECLARE @SerialsTransferred TABLE
	(	Serial INT,
		PartNumber VARCHAR(25),
		NewLocation VARCHAR(50),
		Quantity Numeric (20,6),
		Operator varchar(255),		
		Scheduler VARCHAR(255)
	)


DECLARE @EmailSerialList TABLE
	(	Serial INT,
		PartNumber VARCHAR(25),
		NewLocation VARCHAR(50),
		Quantity Numeric (20,6),
		Operator varchar(255),		
		Scheduler VARCHAR(255)
	)

	

DECLARE @scheduler VARCHAR(25),
		@EmailAddress VARCHAR(max),
		@html NVARCHAR(MAX),
		@EmailTableName sysname  = N'ft.EmailTransferredSerialsList',
		@EmailBody NVARCHAR(MAX),
		@EmailHeader NVARCHAR(MAX) = 'Inevntory Transferred to Lost or QC Location' 

SELECT	@scheduler = '',
		@EmailAddress = '',
		@html = '',
		@EmailBody = ''


INSERT @SerialsTransferred
        ( Serial, PartNumber, NewLocation, Quantity, Operator, Scheduler  )

SELECT 
	Serial = serial,
	PartNumber = part,
	NewLocation = to_loc,
	Quantity = at.quantity,
	Operator = COALESCE(NULLIF(e.name,''), at.operator),
	Scheduler = COALESCE(scheduler_at.field_desc9 , scheduler_pc.field_desc9 , 'LNava@empireelect.com' )
	  
FROM 
	audit_trail at
Left join
	employee e on e.operator_code = at.operator
outer apply ( Select 
				top 1 field_desc9 
			from destination_a1 d
			join	audit_trail at2 on at2.type = 'S'
					and at2.part= at.part 
					and at2.to_loc = d.destination
					and d.field_desc9 like '%@%.com%'
					and at2.date_stamp> getdate() - 365)  as scheduler_at
outer apply ( Select 
				top 1  field_desc9 
			from destination_a1 d
			join destination d0 on d0.destination = d.destination and d.field_desc9 like '%@%.com%'
			join	customer c on c.customer = d0.customer
			join part_customer pc on pc.part = at.part and pc.customer = d0.customer )  as scheduler_pc


WHERE 
	at.date_stamp >= dateadd(hour, -24, getdate()) and
	at.type = 'T'  AND 
	( at.to_loc like  '%QC%' or at.to_loc like '%LOST%' )


DECLARE
	SchedulerAlert CURSOR LOCAL FOR
SELECT
	DISTINCT Scheduler
FROM
	@SerialsTransferred
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

	DELETE  @EmailSerialList

	INSERT  @EmailSerialList
	        ( Serial, PartNumber, NewLocation, Quantity, Operator, Scheduler  )
	
	SELECT 
		  Serial, PartNumber, NewLocation, Quantity, Operator, Scheduler
	FROM
		@SerialsTransferred
	WHERE 
		Scheduler = @scheduler

	SELECT @EmailAddress = @scheduler

	TRUNCATE TABLE ft.EmailTransferredSerialsList
	
	INSERT ft.EmailTransferredSerialsList
	        (  Serial, PartNumber, NewLocation, Quantity, Operator, Scheduler  )

	SELECT 
		 Serial, PartNumber, NewLocation, Quantity, Operator, Scheduler
	FROM
		@EmailSerialList

	
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
	,		@copy_recipients = 'aboulanger@fore-thought.com;dwest@empireelect.com;LNava@empireelect.com' -- varchar(max)
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
