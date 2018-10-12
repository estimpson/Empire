SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- exec [eeiuser].[acctg_DataValidation_PartSetup]

CREATE procedure [eeiuser].[acctg_DataValidation_PartSetup]

as
Begin


Declare @DataAlert table (
							[part] [varchar](25) NULL
							,[part_type] varchar(2) NULL
							,[audit_trail_type] varchar(2) NULL
							,[material_cum] [decimal] (18,6) NULL
						  )
		
insert into @DataAlert
select distinct(audit_trail.part), part.type, audit_trail.type, part_standard.material_cum from audit_trail 
left join part on audit_trail.part = part.part
left join part_standard on audit_trail.part = part_standard.part
left join monitor_inventory_accounts on audit_trail.type = monitor_inventory_accounts.audit_trail_type and part.type = monitor_inventory_accounts.part_type and part.product_line = monitor_inventory_accounts.product_line and monitor_inventory_accounts.fiscal_year = YEAR(audit_trail.date_stamp)
where	audit_trail.date_stamp >= dateadd(d,-1,GETDATE()) 
	and audit_trail.date_stamp < GETDATE()
	and monitor_inventory_accounts.empower_interface = 'Y'
	and audit_trail.part in (select part from part_standard where material_cum < .001)
	and left(audit_trail.part,4) <> 'ZERO'

--select * from @DataAlert order by 2, 1, 3, 4


DECLARE @tableHTML  NVARCHAR(MAX) ;

SET @tableHTML =
    N'<H1>Part Setup Alert!!</H1>' +
    N'<H2>Error: Parts Without a Material Cost' +
    N'<br />In the past day, transactions have occured within Monitor for parts that may be missing material costs.</H2>' +
    N'<p></br/><b>1)</b> The following part numbers need to be reviewed for proper material costs:' +
    N'<br />--open item: will need to find the wip and finished goods that contain these raw parts, execute a rollup of these parts and reimport the inventory transactions--</p>' +
    N'<table border="1">' +
    N'<tr><th>Part</th><th>Part Type</th><th>Audit Trail Type</th><th>Material Accum</th></tr>' +
    CAST ( ( select td = da.part, '',
					td = da.part_type, '',
					td = da.audit_trail_type, '',
					td = da.material_cum, ''
			  from @DataAlert da 
			  order by 2 , 1, 3, 4
              FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    --N'</table>' +
	--N'<br>' +
	--N'<p><b>2)</b> The following WIP parts may need to be rolled up:' +
	--N'<br />--open item: may need to find the finished goods that contain these raw parts and execute a rollup--</p>' +
	--N'<table border="1">' +
 --   N'<tr><th>Part</th><th>Part Type</th><th>Audit Trail Type</th><th>Material Accum</th></tr>' +
 --   CAST ( ( select td = da.part, '',
	--				td = da.part_type, '',
	--				td = da.audit_trail_type, '',
	--				td = da.material_cum, ''
	--		  from @DataAlert da 
	--		  where da.part_type = 'W'
	--		  order by 2 , 1, 3, 4
 --             FOR XML PATH('tr'), TYPE 
 --   ) AS NVARCHAR(MAX) ) +
 --   N'</table>' +  
	--N'<br>' +
	--N'<p><b>3)</b> The following FG parts need to be rolled up:</p>' +
	--N'<table border="1">' +
 --   N'<tr><th>Part</th><th>Part Type</th><th>Audit Trail Type</th><th>Material Accum</th></tr>' +
 --   CAST ( ( select td = da.part, '',
	--				td = da.part_type, '',
	--				td = da.audit_trail_type, '',
	--				td = da.material_cum, ''
	--		  from @DataAlert da 
	--		  where da.part_type = 'F'
	--		  order by 2 , 1, 3, 4
 --             FOR XML PATH('tr'), TYPE 
 --   ) AS NVARCHAR(MAX) ) +
    N'</table>' ;     
exec msdb.dbo.sp_send_dbmail @profile_name = 'SendEmailfromSQL', -- sysname
    @recipients = 'dwest@empireelect.com', -- varchar(max)
   -- @copy_recipients = 'cdempsey@empireelect.com;criveria@empireelect.hn;rhernandez@empireelect.hn', -- varchar(max)
    --@blind_copy_recipients = 'aboulanger@fore-thought.com;estimpson@fore-thought.com', -- varchar(max)
    @subject = N'Data Exception - Parts Without a Material Cost', -- nvarchar(255)
    @body = @TableHTML, -- nvarchar(max)
    @body_format = 'HTML', -- varchar(20)
    @importance = 'High' -- varchar(6)
    
end



GO
