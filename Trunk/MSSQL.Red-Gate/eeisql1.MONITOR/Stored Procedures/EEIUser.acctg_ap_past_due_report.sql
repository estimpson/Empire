SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE Procedure [EEIUser].[acctg_ap_past_due_report]
as

begin

--Create temp table variables

Declare @ap_past_due_on_check_run Table
	-- using field types from ap_headers to ensure integrity
	(	pay_vendor varchar(25), 
		inv_cm_flag char(1), 
		invoice_cm varchar(25), 
		pay_unit varchar(25), 
		bank_alias varchar(25), 
		inv_cm_date datetime, 
		terms varchar(25), 
		due_date datetime, 
		open_amount decimal(18,6),
		check_selection_identifier varchar(25)
	)

Insert @ap_past_due_on_check_run
select pay_vendor, inv_cm_flag, invoice_cm, pay_unit, bank_alias, inv_cm_date, terms, due_date, exchanged_amount-applied_amount as open_amount, isnull(check_selection_identifier,'') as check_selection_identifier  from ap_headers where due_date <= GETDATE() and exchanged_amount-applied_amount <> 0 and buy_unit <> 70 and hold_inv_cm <> 'Y' and isnull(check_selection_identifier,'') <> '' 

--order by isnull(check_selection_identifier,''), bank_alias, pay_vendor

Declare @ap_past_due_not_on_check_run Table
	-- using field types from ap_headers to ensure integrity
	(	pay_vendor varchar(25), 
		inv_cm_flag char(1), 
		invoice_cm varchar(25), 
		pay_unit varchar(25), 
		bank_alias varchar(25), 
		inv_cm_date datetime, 
		terms varchar(25), 
		due_date datetime, 
		open_amount decimal(18,6),
		check_selection_identifier varchar(25)
	)

Insert @ap_past_due_not_on_check_run
select pay_vendor, inv_cm_flag, invoice_cm, pay_unit, bank_alias, inv_cm_date, terms, due_date, exchanged_amount-applied_amount as open_amount, isnull(check_selection_identifier,'') as check_selection_identifier  from ap_headers 
where due_date <= GETDATE() and exchanged_amount-applied_amount <> 0 and buy_unit <> 70 and hold_inv_cm <> 'Y' and isnull(check_selection_identifier,'') = '' and pay_vendor not in 
(select pay_vendor from ap_headers where due_date <= GETDATE() and exchanged_amount-applied_amount <> 0 and buy_unit <> 70 and hold_inv_cm <> 'Y' and isnull(check_selection_identifier,'') = '' group by pay_vendor having SUM(exchanged_amount-applied_amount) <= 0)

--order by isnull(check_selection_identifier,''), bank_alias, pay_vendor


Declare @ap_past_due_on_hold Table
	-- using field types from ap_headers to ensure integrity
	(	pay_vendor varchar(25), 
		inv_cm_flag char(1), 
		invoice_cm varchar(25), 
		pay_unit varchar(25), 
		bank_alias varchar(25), 
		inv_cm_date datetime, 
		terms varchar(25), 
		due_date datetime, 
		open_amount decimal(18,6),
		check_selection_identifier varchar(25) 
	)

Insert @ap_past_due_on_hold
select pay_vendor, inv_cm_flag, invoice_cm, pay_unit, bank_alias, inv_cm_date, terms, due_date, exchanged_amount-applied_amount as open_amount, isnull(check_selection_identifier,'') as check_selection_identifier  from ap_headers where due_date <= GETDATE() and exchanged_amount-applied_amount <> 0 and buy_unit <> 70 and hold_inv_cm = 'Y' 

--order by isnull(check_selection_identifier,''), bank_alias, pay_vendor


If Exists (Select 1 from @ap_past_due_on_check_run)
Begin

DECLARE @tableHTMLA  NVARCHAR(MAX) ;

SET @tableHTMLA =
    N'<H1>Alert for Past Due A/P (Not on hold and on a check run)</H1>' +
    N'<H2>Please approve check run(s) for payment</H2>' +
    N'<table border="1">' +
    N'<tr><th>pay_vendor</th><th>inv_cm_flag</th><th>invoice_cm</th>' +
    N'<th>pay_unit</th><th>bank_alias</th><th>inv_cm_date</th>' +
	N'<th>terms</th><th>due_date</th><th>open_amount</th>' +
    N'<th>check_selection_identifier</th></tr>' +
    CAST ( ( SELECT td = eo.pay_vendor, '',
					td = eo.inv_cm_flag, '',
					td = eo.invoice_cm, '',
					td = eo.pay_unit, '',
					td = eo.bank_alias, '',
					td = convert(varchar(15), eo.inv_cm_date, 110),'',
					td = eo.terms, '',
					td = CONVERT(varchar(15), eo.due_date, 110), '',
					td = eo.open_amount, '',
					td = eo.check_selection_identifier, ''
              FROM @ap_past_due_on_check_run  eo
            order by 1,3 desc 
              FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N'</table>' ;
    
exec msdb.dbo.sp_send_dbmail @profile_name = 'DBMail', -- sysname
    @recipients = 'dwest@empireelect.com', -- varchar(max)
    @copy_recipients = 'cdempsey@empireelect.com jmilicic@empireelect.com kdoman@empireelect.com', -- varchar(max)
    --@blind_copy_recipients = 'aboulanger@fore-thought.com;estimpson@fore-thought.com', -- varchar(max)
    @subject = N'Past Due A/P (Not on hold and on a check run)', -- nvarchar(255)
    @body = @TableHTMLA, -- nvarchar(max)
    @body_format = 'HTML', -- varchar(20)
    @importance = 'Normal' -- varchar(6)

End  

If Exists (select 1 from @ap_past_due_not_on_check_run)
Begin

DECLARE @tableHTMLB  NVARCHAR(MAX) ;

SET @tableHTMLB =
    N'<H1>Alert for Past Due A/P (Not on hold and not on a check run)</H1>' +
    N'<H2>Please prepare check run(s) and submit for approval<H2>'+
    N'<table border="1">' +
    N'<tr><th>pay_vendor</th><th>inv_cm_flag</th><th>invoice_cm</th>' +
    N'<th>pay_unit</th><th>bank_alias</th><th>inv_cm_date</th>' +
	N'<th>terms</th><th>due_date</th><th>open_amount</th>' +
    N'<th>check_selection_identifier</th></tr>' +
    CAST ( ( SELECT td = eo.pay_vendor, '',
					td = eo.inv_cm_flag, '',
					td = eo.invoice_cm, '',
					td = eo.pay_unit, '',
					td = eo.bank_alias, '',
					td = convert(varchar(15), eo.inv_cm_date, 110),'',
					td = eo.terms, '',
					td = CONVERT(varchar(15), eo.due_date, 110), '',
					td = eo.open_amount, '',
					td = eo.check_selection_identifier, ''
              FROM @ap_past_due_not_on_check_run  eo
            order by 1,3 desc 
              FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N'</table>' ;
    
exec msdb.dbo.sp_send_dbmail @profile_name = 'DBMail', -- sysname
    @recipients = 'dwest@empireelect.com', -- varchar(max)
    @copy_recipients = 'cdempsey@empireelect.com jmilicic@empireelect.com kdoman@empireelect.com', -- varchar(max)
    @subject = N'Past Due A/P (Not on hold and not on a check run)', -- nvarchar(255)
    @body = @TableHTMLB, -- nvarchar(max)
    @body_format = 'HTML', -- varchar(20)
    @importance = 'Normal' -- varchar(6)

End  

If Exists (select 1 from @ap_past_due_on_hold)
Begin

DECLARE @tableHTMLC  NVARCHAR(MAX) ;

SET @tableHTMLC =
    N'<H1>Alert for Past Due A/P (These invoices are on hold)</H1>' +
    N'<H2>Please resolve hold and prepare check run</H2>'+
    N'<table border="1">' +
    N'<tr><th>pay_vendor</th><th>inv_cm_flag</th><th>invoice_cm</th>' +
    N'<th>pay_unit</th><th>bank_alias</th><th>inv_cm_date</th>' +
	N'<th>terms</th><th>due_date</th><th>open_amount</th>' +
    N'<th>check_selection_identifier</th></tr>' +
    CAST ( ( SELECT td = eo.pay_vendor, '',
					td = eo.inv_cm_flag, '',
					td = eo.invoice_cm, '',
					td = eo.pay_unit, '',
					td = eo.bank_alias, '',
					td = convert(varchar(15), eo.inv_cm_date, 110),'',
					td = eo.terms, '',
					td = CONVERT(varchar(15), eo.due_date, 110), '',
					td = eo.open_amount, '',
					td = eo.check_selection_identifier, ''
              FROM @ap_past_due_on_hold  eo
            order by 1,3 desc 
              FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N'</table>' ;
    
exec msdb.dbo.sp_send_dbmail @profile_name = 'DBMail', -- sysname
    @recipients = 'dwest@empireelect.com', -- varchar(max)
    @copy_recipients = 'cdempsey@empireelect.com jmilicic@empireelect.com kdoman@empireelect.com', -- varchar(max)
    --@blind_copy_recipients = 'aboulanger@fore-thought.com;estimpson@fore-thought.com', -- varchar(max)
    @subject = N'Past Due A/P (On hold)', -- nvarchar(255)
    @body = @TableHTMLC, -- nvarchar(max)
    @body_format = 'HTML', -- varchar(20)
    @importance = 'Normal' -- varchar(6)

End 


End

GO
