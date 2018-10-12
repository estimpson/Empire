SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [eeiuser].[acctg_ap_import_fedex_invoice_summary]

-- eeiuser.acctg_ap_import_fedex_invoice_summary @AccountNumber = '104949045', @beg_date = '2015-09-01', @end_date = '2015-09-29'

@AccountNumber varchar(25),
@beg_date datetime,
@end_date datetime

as 

declare @temp table (
Vendor varchar(50),
InvoiceType varchar(10),
InvoiceNumber varchar(50),
InvoiceDate datetime,
TrackingId varchar(50),
ServiceType varchar(50),
ShipperCompany varchar(100),
ShipperState varchar(50),
ShipperCountry varchar(50),
Recipientcompany varchar(100),
RecipientState varchar(50),
RecipientCountry varchar(50),
OriginalReference varchar(50),
OriginalReference2 varchar(50),
OriginalReference3 varchar(50),
ActualWeightAmount varchar(50),
ActualWeightUnits varchar(10),
ChargeDescription varchar(50),
AccountNumber varchar(50),
SumChargeAmount decimal(18,2),
NetChargeAmount decimal(18,2)
)
insert into @temp



		select	b.vendor as vendor
		,'I' as invoice_type
		,left(InvoiceNumber,1)+'-'+right(left(InvoiceNumber,4),3)+'-'+right(InvoiceNumber,5) as InvoiceNumber
		,convert(varchar,InvoiceDate,101) as InvoiceDate
		,TrackingId
		,ServiceType
		,shippercompany
		,shipperstate
		,shippercountry
		,Recipientcompany
		,RecipientState
		,RecipientCountry
		,OriginalReference
		,OriginalReference2
		,OriginalReference3
		,convert(varchar(25),isnull(ActualWeight,0)) as ActualWeight
		,ActualWeightUnit
		,'Transportation Charges'

		,(case when SimpleServiceType like '%Express%' then
			(case when ShipperCompany like '%Empire%' then 
				(case when RecipientCompany like '%Empire%' then '505512' else '504512' end)
			 else '504512' end)
	      else '504012' end) as AccountNumber		
		,0
		,isnull(a.NetChargeAmount,0)-isnull(a.[advancement fee],0) - isnull(a.[customs duty],0)

		from eeisql1.fedexfft.dbo.fbodataflatcharges a join vendor_attributes b on a.AccountNumber = b.text_2
				
					
		where	invoicedate >=  @Beg_date 
			and invoicedate <=  @End_date 
			and a.AccountNumber = @AccountNumber 
			and isnull(a.NetChargeAmount,0)-isnull(a.[advancement fee],0) - isnull(a.[customs duty],0)<>0

union

		select	b.vendor as vendor
		,'I' as invoice_type
		,left(InvoiceNumber,1)+'-'+right(left(InvoiceNumber,4),3)+'-'+right(InvoiceNumber,5) as InvoiceNumber
		,convert(varchar,InvoiceDate,101) as InvoiceDate
		,TrackingId
		,ServiceType
		,shippercompany
		,shipperstate
		,shippercountry
		,Recipientcompany
		,RecipientState
		,RecipientCountry
		,OriginalReference
		,OriginalReference2
		,OriginalReference3
		,convert(varchar(25),isnull(ActualWeight,0))
		,ActualWeightUnit
		,'Duty Charges'
		,'505912' as account_number		
		,0
		,isnull([advancement fee],0)+isnull([customs duty],0)

		from eeisql1.fedexfft.dbo.fbodataflatcharges a left join vendor_attributes b on a.AccountNumber = b.text_2
				
		where	invoicedate >= @Beg_date 
			and invoicedate <=  @End_date 
			and a.AccountNumber = @AccountNumber 
			and netchargeamount <> 0 
			and ([advancement fee] is not null or [customs duty] is not null)

select	 vendor
		,InvoiceType
		,InvoiceNumber
		,'' as one
		,'' as two
		,'' as three
		,'' as four
		,'' as five
		,''		
		,''
		,''
		,''
		,''
		,convert(varchar,InvoiceDate,101)
		,''
		,''
		,''
		,''
		,''
		,''		
		,''
		,''		
		,''
		,''
		,''
		,''
		,(TrackingId+'*'+ServiceType+' ['+ChargeDescription+'] From '+ShipperCompany+' '+ShipperState+' '+ShipperCountry+' to '+RecipientCompany+' '+RecipientState+' '+RecipientCountry+'(Ref '+Coalesce(OriginalReference,OriginalReference2,OriginalReference3)+') ('+convert(varchar(25),isnull(ActualWeightAmount,0))+' '+ActualWeightUnits+')') as description
		,NetChargeAmount 
		,''
		,''
		,''
		,''
		,''		
		,''
		,''		
		,''
		,''
		,''
		,''
		,AccountNumber
			
		from @temp
		where netchargeamount <> 0
		order by InvoiceNumber
		
GO
