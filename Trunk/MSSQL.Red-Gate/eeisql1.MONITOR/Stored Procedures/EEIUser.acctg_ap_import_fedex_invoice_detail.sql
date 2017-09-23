SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE procedure [EEIUser].[acctg_ap_import_fedex_invoice_detail]

-- eeiuser.acctg_ap_import_fedex_invoice @AccountNumber = '119281873', @beg_date = '2014-02-14', @end_date = '2014-02-28'

@AccountNumber varchar(25),
@beg_date datetime,
@end_date datetime

as 

--	insert into fedexfft.dbo.package_charges
--	select fbodataid, 'Transportation Charge', transportationcharge from fedexfft.dbo.fbodataflatcharges where invoicedate >= '2014-02-14' and invoicedate <= '2014-02-28'



select	b.vendor as vendor
		,'I' as invoice_type
		,left(InvoiceNumber,1)+'-'+right(left(InvoiceNumber,4),3)+'-'+right(InvoiceNumber,5) as InvoiceNumber
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
		,(TrackingId+'*'+ServiceType+' ['+Charge_description+'] From '+shippercompany+' '+shipperstate+' '+shippercountry+' to '+Recipientcompany+' '+RecipientState+' '+RecipientCountry+'(Ref '+Coalesce(OriginalReference,OriginalReference2,OriginalReference3)+') ('+convert(varchar(25),isnull(ActualWeightAmount,0))+' '+ActualWeightUnits+')') as description
		,Charge_Amount
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
		,(case when Charge_description in ('Customs Duty','Advancement Fee') then '505911' else
		(case when SimpleServiceType like '%Express%' then
			(case when ShipperCompany like '%Empire%' then 
				(case when RecipientCompany like '%Empire%' then '505511' else '504511' end)
			 else '504511' end)
	      else '504011' end)end) as account_number
		
		--Into FEDEXIMPORT
		
		from fedexfft.dbo.fbodataflatcharges a join vendor_attributes b on a.AccountNumber = b.text_2
		join fedexfft.dbo.package_charges c on a.fbodataid = c.package_db_id
		
		where invoicedate >= @beg_date and invoicedate <= @end_date and a.AccountNumber = @AccountNumber and charge_amount <> 0
		
		order by InvoiceNumber
	--  
	
	--Declare @sql varchar(8000)
	--select @sql = 'bcp "select * from FEDEXIMPORT"'
	--+ 'queryout c:\FEDEXIMPORT.txt' + @@SERVERNAME
	--EXEC master..xp_cmdshell @sql
	
	--DROP table FEDEXIMPORT








GO
