SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- exec [dbo].[ftsp_DataValidation_SalesReturnAccount]

CREATE procedure [dbo].[ftsp_DataValidation_SalesReturnAccount]

as
Begin

Update a set sales_return_account = 4031 from part_eecustom a join part on a.part = part.part where part.product_line = 'WIRE HARN - EEH'
Update a set sales_return_account = 4041 from part_eecustom a join part on a.part = part.part where part.product_line = 'WIRE HARN - EEI'
Update a set sales_return_account = 4051 from part_eecustom a join part on a.part = part.part where part.product_line = 'ES3 COMPONENTS'
Update a set sales_return_account = 4061 from part_eecustom a join part on a.part = part.part where part.product_line = 'BULBED ES3 COMPONENTS'
Update a set sales_return_account = 4081 from part_eecustom a join part on a.part = part.part where part.product_line = 'PCB'

Declare @DataAlert table (
	
	[Part] [varchar](25) NULL
	
	)
		
		if exists (	select 1 
						from 
							part_eecustom peec
						join	
							part p on peec.part = p.part
						where 
							nullif(peec.sales_return_account, '') is null 
						and
							p.type = 'F'
						and
							p.class in ('P', 'M')
						and
							p.part not like '%-PT%')
		Begin
		insert	@DataAlert
		        (Part
		        )
		select		
			peec.part
		         
		from 
			part_eecustom peec
		join	
			part p on peec.part = p.part
		where 
			nullif(peec.sales_return_account, '') is null 
		and
			p.type = 'F'
		and
			p.class in ('P', 'M')
		and
			p.part not like '%-PT%'
				
	order by
		1
		
		DECLARE @tableHTML  NVARCHAR(MAX) ;

SET @tableHTML =
    N'<H1>Parts Without Sales Return Account Defined</H1>' +
    N'part_eecustom.sales_return_account'+
    N'<table border="1">' +
    N'<tr><th>Part</th></tr>' +
    CAST ( ( SELECT td = da.Part
              FROM @DataAlert  da
              order by 1
              FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N'</table>' ;
    
exec msdb.dbo.sp_send_dbmail @profile_name = 'DBMail', -- sysname
    @recipients = 'APellerito@empireelect.com', -- varchar(max)
    @copy_recipients = 'aboulanger@fore-thought.com;dwest@empireelect.com', -- varchar(max)
    --@blind_copy_recipients = 'aboulanger@fore-thought.com;estimpson@fore-thought.com', -- varchar(max)
    @subject = N'Data Exception - Parts without Sales Return Account Defined', -- nvarchar(255)
    @body = @TableHTML, -- nvarchar(max)
    @body_format = 'HTML', -- varchar(20)
    @importance = 'High' -- varchar(6)
    
		end
end

GO
