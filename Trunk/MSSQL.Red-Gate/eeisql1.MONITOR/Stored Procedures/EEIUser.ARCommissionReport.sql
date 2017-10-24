SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [EEIUser].[ARCommissionReport] @as_fiscalyear varchar(5),
                                    @ai_period integer
AS

BEGIN

  DECLARE @c_amount decimal(18,6),
          @s_document varchar(25),
          @s_customer varchar(25),
          @d_documentdate datetime
         
  DECLARE commcursor CURSOR FOR
    SELECT ar_headers.document, 
           ar_headers.amount, 
           ar_headers.bill_customer,
           ar_headers.document_date
     FROM ar_headers, ar_applications
    WHERE ar_headers.document_type = ar_applications.document_type AND
          ar_headers.document = ar_applications.document AND
          ar_headers.document_type = 'I' AND
          (ar_headers.amount - ar_headers.applied_amount = 0) AND
          ar_applications.fiscal_year = @as_fiscalyear
    GROUP BY ar_headers.document, 
             ar_headers.amount, 
             ar_headers.bill_customer,
             ar_headers.document_date
    HAVING MAX(ar_applications.period) = @ai_period
    ORDER BY ar_headers.document

  CREATE TABLE #ar_commission_rpt
          (bill_customer CHAR(25) NULL,
          bill_customer_name CHAR(100) NULL,
          account_manager CHAR(25) NULL,
          item CHAR(50) NULL,
          item_description TEXT NULL,
          document CHAR(25) NULL,
          document_date DATETIME NULL,
          document_line SMALLINT,
          last_applied_date DATETIME NULL,
          extended_amount DECIMAL(18,6) NULL,
          cash_applied_amount DECIMAL(18,6) NULL,
          credit_applied_amount DECIMAL(18,6) NULL)

  OPEN commcursor

  WHILE 1 = 1 
      BEGIN
      FETCH commcursor INTO @s_document, @c_amount, @s_customer, @d_documentdate

--      /* MS SQL Server only
      IF @@fetch_status <> 0 BREAK
--        End MS SQL Server only */

--      IF @@sqlstatus <> 0 BREAK

      INSERT INTO #ar_commission_rpt

      SELECT ar_headers.bill_customer,
             customer_name,
             ar_headers.account_manager,
             item,
             '',
             ar_headers.document,
             ar_headers.document_date,
             ar_items.document_line,
             MAX(ar_applications.applied_date), 
             MAX(extended_amount),
             (SELECT SUM(ar_applications.applied_amount) 
              FROM ar_applications
              WHERE ar_applications.document_type = 'I' AND
                    ar_applications.document = @s_document AND
                    ar_applications.application_type = 'CHECK'),
             (SELECT SUM(ar_applications.applied_amount) 
               FROM ar_applications
              WHERE ar_applications.document_type = 'I' AND
                    ar_applications.document = @s_document AND
                    ar_applications.application_type <> 'CHECK')
        FROM ar_applications, ar_items, ar_customers, ar_headers
        WHERE ar_headers.document = @s_document AND
            ar_headers.document_type = 'I' AND
            ar_customers.customer = @s_customer AND
            ar_headers.document = ar_applications.document AND
            ar_headers.document_type = ar_applications.document_type AND
            ar_headers.document = ar_items.document AND
            ar_headers.document_type = ar_items.document_type AND
            ar_items.ledger_account_code IN 
            ('401011','401111','402011','402111',
             '401511','401611','405011','405111') AND
            ar_items.line_type = 'IT'
        GROUP BY ar_headers.bill_customer,
            customer_name,
            ar_headers.account_manager,
            item,
            ar_headers.document,
            ar_headers.document_date,
            ar_items.document_line,
            extended_amount
   END 

CLOSE commcursor
--/* MS SQL Server only
      DEALLOCATE commcursor
--   End MS SQL Server only */


SELECT  bill_customer,
        bill_customer_name,
        account_manager,
        #ar_commission_rpt.item,
        ar_items.item_description,
        #ar_commission_rpt.document,
        document_date,
        #ar_commission_rpt.document_line,
        last_applied_date,
        #ar_commission_rpt.extended_amount,
        IsNull(cash_applied_amount,0),
        IsNull(credit_applied_amount,0),
        @as_fiscalyear,
        @ai_period
    FROM #ar_commission_rpt, ar_items
    WHERE #ar_commission_rpt.document = ar_items.document AND
        #ar_commission_rpt.document_line = ar_items.document_line AND
        ar_items.document_type = 'I'
    ORDER BY account_manager,
        bill_customer,
        #ar_commission_rpt.document,
        #ar_commission_rpt.item

END

GO
