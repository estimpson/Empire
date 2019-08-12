SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [EEIUser].[acctg_EMailAlert_IntercompanyTransferPriceDiscrepancy]

--	@Part varchar(50)
--,	@EEITransferPrice decimal(18,4)
--,	@EEHTransferPrice decimal(18,4)
AS
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
SET	ANSI_WARNINGS ON



-- 1. Populate Temp Table with Results

IF OBJECT_ID('tempdb..#Discrepancies') IS NOT NULL
    DROP TABLE #Discrepancies
	
select	eeh_part as [Part], price as [EEH Transfer Price], material_cum as [EEI Transfer Price] 
INTO #discrepancies
from
(select eeh_ps.part as eeh_part, price from eehsql1.eeh.dbo.part_standard eeh_ps join eehsql1.eeh.dbo.part eeh_p on eeh_ps.part = eeh_p.part where eeh_p.type = 'F') a
full outer join 
(select eei_ps.part as eei_part, material_cum from monitor.dbo.part_standard eei_ps join monitor.dbo.part eei_p on eei_ps.part = eei_p.part where eei_p.type = 'F') b
on a.eeh_part = b.eei_part
where a.price <> b.material_cum --and a.eeh_part in (select part from monitor.dbo.object group by part having sum(quantity) >0) 

--select * from #discrepancies		


	
-- 2. Create HTML and E-Mail

IF EXISTS ( SELECT 1 FROM #Discrepancies )	

BEGIN	
		DECLARE
			@html NVARCHAR(MAX),
			@EmailTableName sysname  = N'#Discrepancies'

		EXEC [FT].[usp_TableToHTML]
			  @tableName = @Emailtablename
			, @OrderBy = '[Part]'
			, @html = @html OUT
		
		DECLARE
			@EmailBody NVARCHAR(MAX)
		,	@EmailHeader NVARCHAR(MAX) = 'Intercompany Transfer Price Discrepancy' 

		SELECT
			@EmailBody =
						N'<H1>' + @EmailHeader + N'</H1>' +
						@html +  
						N'<br />' +
						N'The EEH Transfer Price has been updated to match the EEI Transfer Price.'

	--print @emailBody

		EXEC msdb.dbo.sp_send_dbmail
				@profile_name = 'DBMail'-- sysname
	,			@recipients = 'dwest@empireelect.com' -- varchar(max)
--	,			@copy_recipients = 'dwest@empireelect.com -- varchar(max)
	, 			@subject = @EmailHeader
	,  			@body = @EmailBody
	,  			@body_format = 'HTML'
	,			@importance = 'High'  -- varchar(6)	


update a
set a.transfer_price = b.[EEI Transfer Price]
from eehsql1.eeh.dbo.part_standard a join #discrepancies b on a.part = b.part


update a
set a.price = b.[EEI Transfer Price]
	,a.alternate_price = b.[EEI Transfer Price]
from eehsql1.eeh.dbo.order_header a join #discrepancies b on a.blanket_part = b.part

update a
set a.price = b.[EEI Transfer Price]
	,a.alternate_price = b.[EEI Transfer Price]
from eehsql1.eeh.dbo.order_detail a join #discrepancies b on a.part_number = b.part

update a
set a.blanket_price = b.[EEI Transfer Price]
from eehsql1.eeh.dbo.part_customer a join #discrepancies b on a.part = b.part

update a
set a.price = b.[EEI Transfer Price]
	,a.alternate_price = b.[EEI Transfer Price]
from eehsql1.eeh.dbo.part_customer_price_matrix a join #discrepancies b on a.part = b.part

END

GO
