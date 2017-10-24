SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- eeiuser.acctg_freight_report '2014-04-01', '2014-04-30'

CREATE procedure [EEIUser].[acctg_freight_report] (@start_date datetime, @end_date datetime)
as 

--declare @start_date datetime;
--declare @end_date datetime;
--select @start_date = '2014-04-02'
--select @end_date = '2014-04-30'


declare @GLTransactions as Table (
FiscalYear varchar(5),
Period smallint,
GLDate datetime,
LedgerAcct varchar(50),
Vendor varchar(25),
Invoice varchar(25),
ContractAccountID varchar(25),
Amount decimal(18,6),
TrackingNumber varchar(50),
DocumentRemarks varchar(max)
)

update ap_items set item_description = Replace(convert(varchar(255),item_description),'"','') from ap_items ai join ap_headers ah on ah.vendor = ai.vendor and ah.invoice_cm = ai.invoice_cm and ah.inv_cm_flag = ai.inv_cm_flag
where ah.vendor = 'FEDERAL CR' and ah.gl_date >= @start_date and ah.gl_date < @end_date
	
insert into @gltransactions

SELECT	gl_cost_transactions.fiscal_year, 
		gl_cost_transactions.period, 
		gl_cost_transactions.transaction_date as 'GLDate', 
		gl_cost_transactions.ledger_account AS 'LedgerAcct', 
		gl_cost_transactions.document_id2 AS 'vendor', 
		gl_cost_transactions.document_id1 AS 'invoice', 
		gl_cost_transactions.contract_account_id, 
		gl_cost_transactions.amount,
		'', 
		gl_cost_transactions.document_remarks
FROM Monitor.dbo.gl_cost_transactions gl_cost_transactions
WHERE	gl_cost_transactions.ledger_account in ('504511', '505511','504560','504560','504521','505521')
		AND gl_cost_transactions.document_id2 not in ('FEDERAL CR')
		AND gl_cost_transactions.fiscal_year = datepart(yyyy,@start_date)
		AND gl_cost_transactions.update_balances='Y' 
		AND gl_cost_transactions.transaction_date >= @start_date
		AND gl_cost_transactions.transaction_date < dateadd(d,1,@end_date)




insert into @glTransactions
SELECT	ah.fiscal_year,
		ah.period,
		ah.gl_date as 'GLDate',
		ai.ledger_account_code as 'LedgerAcct',
		ah.vendor,
		ah.invoice_cm as 'Invoice',
		'' as contract_account_id,
		sum(ai.extended_amount) as 'ExtAmount',
        replace(left(convert(varchar(255),ai.item_description),(case when CHARINDEX('*',ai.item_description) = 0 then 0 else CHARINDEX('*',ai.item_description)-1 end)),'"','') AS 'TrackingNumber', 
        '' as document_remarks
FROM   Monitor.dbo.ap_headers ah
              join Monitor.dbo.ap_items ai on ah.vendor = ai.vendor and ah.invoice_cm = ai.invoice_cm and ah.inv_cm_flag = ai.inv_cm_flag
WHERE  ai.vendor='FEDERAL CR'
       AND ah.gl_date >= @start_date and ah.gl_date < dateadd(d,1,@end_date)
group by ah.fiscal_year,
			ah.period,
			ah.gl_date,
			ai.ledger_account_code,
			ah.vendor,
			ah.invoice_cm,
            replace(left(convert(varchar(255),ai.item_description),(case when CHARINDEX('*',ai.item_description) = 0 then 0 else CHARINDEX('*',ai.item_description)-1 end)),'"','')



update @glTransactions
set TrackingNumber = replace(left(convert(varchar(255),documentremarks),(case when CHARINDEX('*',documentremarks) = 0 then 0 else CHARINDEX('*',documentremarks)-1 end)),'"','') where 
documentremarks like '%*%' and Vendor not in ('FEDERAL CR')

select * from @glTransactions a 
left join

(
select  '----' as Spacer1,
              AccountNumber,  
              TrackingId,  
              InvoiceNumber,  
              InvoiceDate,  
              NetChargeAmount,  
              '----' as Spacer2,  
              ServiceType,  
              SimpleServiceType,  
              ShipmentDate,  
              PODDeliveryDateTime,  
              datediff(d,ShipmentDate,PODDeliveryDateTime) as DaysIntransit,  
              PODSignatureDescription,  
              '----' as Spacer3,  
              NumberofPieces,  
              ConvertedActualWeightAmount, 
              '----' as Spacer4,  
              RecipientName,  
              RecipientCompany,  
              RecipientAddressLine1,  
              RecipientAddressLine2,  
              RecipientCity,  
              RecipientState,  
              RecipientZipCode,  
              RecipientCountry,  
              '----' as Spacer5,
              ShipperName,  
              ShipperCompany,  
              ShipperAddressLine1,  
              ShipperAddressLine2,  
              ShipperCity,  
              ShipperState,  
              ShipperZipCode,  
              ShipperCountry,  
              '----' As Spacer6,
              OriginalReference,  
              '----' As Spacer7,
              EntryNumber,  
              EntryDate,  
              CustomsValue,  
              '-----' As Spacer8,
              TransportationCharge,  
              Discount,  
              [Earned Discount],  
              [Fuel Surcharge],  
              [Advancement Fee],  
              [Customs Duty],  
              [Performance Pricing],  
              [Residential],  
              [Sales Tax],  
              [Saturday Pickup],  
              [PackageNetCharge]  
from fedexfft.dbo.fbodataflatcharges) b
on a.TrackingNumber = b.TrackingId and Replace(a.Invoice,'-','') = b.InvoiceNumber


GO
