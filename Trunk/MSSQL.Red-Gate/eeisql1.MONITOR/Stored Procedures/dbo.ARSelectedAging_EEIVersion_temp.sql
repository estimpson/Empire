SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[ARSelectedAging_EEIVersion_temp]
/* 10-Jul-02 In the final sort, included customer after sort2 so that*/
/*           when sort2 is customer_name, customers with the same name*/
/*           but a different ID are treated separately.*/
/* 01-Jul-02 When selecting from the bank_register, select checks that*/
/*           were NSF'ed after the select date. Previously, NSF checks*/
/*           were not selected.*/
/* 30-Jan-02 Modified the update that updates sort_2 with customer_name*/
/*           to update sort_2 with an empty string if customer_name is*/
/*           null because Brazosport was getting an error about trying to*/
/*           insert a null value into sort_2 even though none of their*/
/*           customer names were null.*/
/* 09-Nov-01 When selecting from the bank_register, use the new*/
/*           column application_check_amount rather than document_amount.*/
/*           Application_check_amount is in the currency of the*/
/*           applications, whereas document_amount may no longer be in*/
/*           the currency of the applications.*/
/* 02-Jul-01 Set dayspastdoc for checks. Previously, it was set to 0.*/
/* 01-Mar-01 Changed the STR function in the select statement for*/
/*           checks to CONVERT. STR is a SQL server only function*/
/*           and did not work in SQL Anywhere. Also changed ledger*/
/*           account in bank register to offset_ledger_account.*/
/* 16-Nov-00 Added arguments as_begledgeraccount, as_endledgeraccount*/
/*               and as_pageby.*/
/* 23-Oct-00 Added arguments as_agedby, as_sortby, as_agecustomer,*/
/*           is_bucket1, is_bucket2 and is_bucket3.*/
/* 12-May-00 Reworked UPDATE statements to not use left outer joins in*/
/*           the subqueries. MS SQL Server 7.0 didn't like the LOJ's.*/
/* 03-Dec-99 Return currency.*/
/* 27-Jul-99 Don't include intercompany ar_headers.*/
as
begin
Truncate table [dbo].ar_customer_aging
end
begin
   /*  Select invoices and credit memos along with associated summed 
  application rows for the appropriate selection date into a temporary
  table.  Later we'll return a result set from this table.
  */
      insert into [dbo].ar_customer_aging
        select ar_headers.document_type,
          ar_headers.document,
          ar_headers.bill_unit,
          ar_headers.bill_customer,
          ar_headers.due_date,
          ar_headers.document_date,
          ar_headers.gl_date,
          ar_headers.ledger_account_code,
          as_of_date='2007-04-30',
          select_date='2007-04-30',
          ar_headers.amount,
          IsNull(SUM(ar_applications.applied_amount),0),
          DateDiff(day,ar_headers.due_date,'2007-04-30'),
          DateDiff(day,ar_headers.document_date,'2007-04-30'),
          Min(ar_customers.customer_name),
          ar_headers.exchanged_amount,
          IsNull(SUM(ar_applications.offset_exchanged_amount*-1),0),
          ar_headers.contract_po,
          '',
          '',
		  ar_headers.ee_scheduled_date,
		  ar_headers.ee_confirmed,
		  ar_headers.ee_overdue_reason,
		  ar_headers.ee_comment,
          NULL
          from
			ar_headers
			join ar_applications
				on ar_headers.document=ar_applications.document
				and ar_headers.document_type=ar_applications.document_type
			left join ar_customers
				on ar_headers.bill_customer=ar_customers.customer
          where 
          convert(char(10),ar_headers.gl_date,111)          
          <=convert(char(10),'2007-04-30',111)
		  and ar_headers.gl_date > '2005-01-01'
          and ar_headers.amount<>0
          and ar_headers.intercompany<>'Y'
          and convert(char(10),ar_applications.applied_date,111)
          <=convert(char(10),'2007-04-30',111)
          and ar_applications.application_type<>'OVERPY'
          and(ar_headers.bill_unit='11')
          and(ar_headers.ledger_account_code='121011')
          group by ar_headers.document_type,
          ar_headers.document,
          ar_headers.bill_unit,
          ar_headers.bill_customer,
          ar_headers.amount,
          ar_headers.due_date,
          ar_headers.document_date,
          ar_headers.gl_date,
          ar_headers.ledger_account_code,
          ar_headers.exchanged_amount,
          ar_headers.contract_po,
		  ar_headers.ee_scheduled_date,
		  ar_headers.ee_confirmed,
		  ar_headers.ee_overdue_reason,
		  ar_headers.ee_comment
          
    end
 
  /*  Move the summed exchanged amount for credit memos to the exchanged
  amount column used for invoices and checks.  Since we don't have an
  IF statement this will have to do.

  Trash what was summed above and start over by summing the normal 
  credit memo to invoice applications.  

  While we're working on credit memos, set the days past due to 0
  because credit memos aren't ever past due. */
  update [dbo].ar_customer_aging set
    exchanged_applied_amount
    =IsNULL((select SUM(IsNull(ar_applications.exchanged_amount*-1,0))
      from ar_applications
      where ar_applications.document_type
      =[dbo].ar_customer_aging.document_type
      and ar_applications.document=[dbo].ar_customer_aging.document
      and ar_applications.application_type<>'CHECK'
      and convert(char(10),ar_applications.applied_date,111)<=convert(char(10),'2007-04-30',111)),0)
    where document_type='C'
  /*  Now update the summed total with credit memo to check applications */
  update [dbo].ar_customer_aging set
    exchanged_applied_amount=exchanged_applied_amount
    +IsNull((select SUM(IsNull(ar_applications.offset_exchanged_amount*-1,0))
      from ar_applications
      where ar_applications.document_type
      =[dbo].ar_customer_aging.document_type
      and ar_applications.document=[dbo].ar_customer_aging.document
      and ar_applications.application_type='CHECK'
      and convert(char(10),ar_applications.applied_date,111)<=convert(char(10),'2007-04-30',111)),0)
    where document_type='C'
  /*  Select approriate check and summed application rows into the temporary
  table as well.
  */
  insert into [dbo].ar_customer_aging
    select 'A',
      LTrim(convert(char(25),bank_register.document_id3)),
      bank_register.document_id1,
      bank_register.document_id2,
      bank_register.document_date,
      bank_register.document_date,
      bank_register.gl_date,
      bank_register.offset_ledger_account_code,
      getdate(),
      getdate(),
      bank_register.application_check_amount*-1,
      IsNull(SUM(ar_applications.applied_amount)*-1,0),
      0,
      DateDiff(day,bank_register.document_date,'2007-04-30'),
      ar_customers.customer_name,
      bank_register.exchanged_amount*-1,
      IsNull(SUM(ar_applications.exchanged_amount)*-1,0),'','','','','','','',NULL
      from
		bank_register
		left join ar_applications
			on bank_register.document_id3=ar_applications.check_number
			and bank_register.document_id2=ar_applications.bill_customer
		left join ar_customers
			on bank_register.document_id2=ar_customers.customer
      where bank_register.document_class='AR'
      and bank_register.check_void_nsf='C'
      and(bank_register.document_type<>'N'
      or(bank_register.document_type='N'
      and exists(select 1 from bank_register as br_voids
        where br_voids.document_class='AR'
        and br_voids.check_void_nsf='N'
        and br_voids.document_id3=bank_register.document_id3
        and br_voids.document_id2=bank_register.document_id2
        and convert(char(10),br_voids.gl_date,111)  >convert(char(10),'2007-04-30',111))))
      and(ar_applications.applied_date is null
      or convert(char(10),ar_applications.applied_date,111) <=convert(char(10),'2007-04-30',111))
      and ar_applications.application_type not in('DISCNT','ADJUST','WRTOFF')
      and convert(char(10),bank_register.gl_date,111) <=convert(char(10),'2007-04-30',111)
      and bank_register.document_id2<>'NON-AR'
      and(bank_register.document_id1='11')
      and(bank_register.offset_ledger_account_code='121011')
      group by bank_register.document_id3,
      bank_register.document_id2,
      bank_register.document_id1,
      bank_register.application_check_amount,
      bank_register.document_date,
      bank_register.gl_date,
      bank_register.offset_ledger_account_code,
      ar_customers.customer_name,
      bank_register.exchanged_amount
     
  /* put the appropriate columns into the sort columns in the temporary table */
  begin
    update [dbo].ar_customer_aging set
      sort_1=ledger_account_code
  end
  
  /* Return those document rows from the temporary table that have 
  unapplied balances
  */
GO
