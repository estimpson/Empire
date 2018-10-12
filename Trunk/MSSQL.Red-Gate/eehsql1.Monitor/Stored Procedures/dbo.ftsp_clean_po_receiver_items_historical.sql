SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[ftsp_clean_po_receiver_items_historical] @DateStamp DATETIME, @TransactionDate Datetime
AS
-- ftsp_clean_po_receiver_items_historical '2011-01-31 23:59:01.250', '2011-02-01'


-- Get records from po_receiver_items_historical that need to be cleaned
SELECT *
INTO #po_receiver_items_historical
FROM dbo.po_receiver_items_historical
WHERE time_stamp >= @DateStamp AND
period = 1 AND
fiscal_year = '2011' AND
changed_date >= @TransactionDate


-- Get list if receivers (receipts) to delete that have occured >= '2011-02-01'
SELECT receiver
INTO #ReceiversToDelete
FROM #po_receiver_items_historical
LEFT JOIN (SELECT sum(quantity) Qty, ISNULL(shipper, ' _NoShipper') AS Shipper, part
FROM dbo.audit_trail
WHERE type = 'R' AND date_stamp >= @TransactionDate
GROUP BY ISNULL(shipper, ' _NoShipper'), part ) Receipts ON (CASE WHEN bill_of_lading LIKE '%[_]%' THEN SUBSTRING(bill_of_lading, 1, PATINDEX('%[_]%', bill_of_lading)-1) ELSE bill_of_lading END) = Receipts.shipper AND item = Receipts.part
ORDER BY 1


--SELECT * FROM #ReceiversToDelete




--Delete Receivers received after transaction cut off date ('2011-02-01')
DELETE dbo.po_receiver_items_historical
WHERE time_stamp = @DateStamp AND
period = 1 AND
fiscal_year = '2011' AND
changed_date >= @TransactionDate AND
receiver IN ( SELECT receiver FROM #ReceiversToDelete)
-- Get list of invoices that have been invoiced after '2011-02-01'
SELECT invoice_cm
INTO #InvoicedReceivers
FROM dbo.ap_headers
WHERE gl_date >= @TransactionDate AND
invoice_cm IN (SELECT invoice FROM #po_receiver_items_historical)


--SELECT * FROM #InvoicedReceivers




--Delete Invoiced receivers invoice after transaction cut off date '2011-02-01'


Delete dbo.po_receiver_items_historical
WHERE time_stamp = @DateStamp AND
period = 1 AND
fiscal_year = '2011' AND
changed_date >= @TransactionDate AND
invoice IN ( SELECT invoice_cm FROM #InvoicedReceivers)
GO
