SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[acctg_ap_import_fedex_invoice_summary]

-- eeiuser.acctg_ap_import_fedex_invoice_summary @AccountNumber = '119281873', @beg_date = '2015-11-01', @end_date = '2015-11-30'

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
select (select vendor from EMPOWER..vendor_attributes where attribute = 'TEXT2' and attribute_value = @AccountNumber) as vendor
,'I' as invoice_type
,left(a.InvoiceNumber,1)+'-'+right(left(a.InvoiceNumber,4),3)+'-'+right(a.InvoiceNumber,5) as InvoiceNumber
,convert(varchar,a.InvoiceDate,101) as InvoiceDate
,a.TrackingId
,a.ServiceType
,a.shippercompany
,a.shipperstate
,a.shippercountry
,a.Recipientcompany
,a.RecipientState
,a.RecipientCountry
,a.OriginalReference
,a.OriginalReference2
,a.OriginalReference3
,convert(varchar(25),isnull(a.ActualWeight,0)) as ActualWeight
,a.ActualWeightUnit
,'Transportation Charges'
,(case when a.SimpleServiceType like '%Express%' then
    (case when a.ShipperCompany like '%Empire%' then 
            (case when a.RecipientCompany like '%Empire%' then '505511' else '504511' end)
    else '504511' end)
else '504011' end) as AccountNumber             
,0
,isnull(a.NetChargeAmount,0)-isnull(a.[advancement fee],0) - isnull(a.[customs duty],0)

from fedexfft.dbo.fbodataflatcharges a 
                           
where  invoicedate >=  @Beg_date 
    and invoicedate <=  @End_date 
    and a.AccountNumber = @AccountNumber 
    and isnull(a.NetChargeAmount,0)-isnull(a.[advancement fee],0) - isnull(a.[customs duty],0)<>0
             

union
             select (select vendor from EMPOWER..vendor_attributes where attribute = 'TEXT2' and attribute_value = @AccountNumber) as vendor
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
             ,'505911' as account_number             
             ,0
             ,isnull([advancement fee],0)+isnull([customs duty],0)

             from fedexfft.dbo.fbodataflatcharges a 
       where  invoicedate >= @Beg_date 
                    and invoicedate <=  @End_date 
                    and a.AccountNumber = @AccountNumber 
                    and netchargeamount <> 0 
                    and ([advancement fee] is not null or [customs duty] is not null)
/* */

insert into EEHSQL1.EEH.HN.FEDEX_Import_invoice_summary (Vendor,InvoiceType,InvoiceNumber,one,two,three,four,five,six,seven,eight,nine,ten,InvoiceDate,eleven,twelve,thirteen,fourteen
,fifteen,sixteen,seventeen,eighteen,nineteen,twenty,A,B,ChargeDescription,NetChargeAmount,C,D,E,F,G,H,I,J,K,L,M,AccountNumber, Type)
select vendor
             ,InvoiceType
             ,InvoiceNumber
             ,'' as one
             ,'' as two
             ,'' as three
         ,'' as four
                    ,'' as five
                    ,''    as six 
                    ,'' as seven
                    ,'' as eight
                    ,'' as nine
                    ,'' as ten
             ,convert(varchar,InvoiceDate,101) as InvoiceDate
             ,'' as eleven
             ,''    as twelve
             ,'' as thirteen
             ,''  as fourteen
             ,''    as fifteen
             ,''    as sixteen   
             ,''    as seventeen
             ,''    as eighteen  
             ,''    as nineteen  
             ,'' as twenty
             ,''    as A
             ,'' as B
             ,replace((TrackingId+'*'+ServiceType+' ['+ChargeDescription+'] From '+ShipperCompany+' '+ShipperState+' '+ShipperCountry+' to '+RecipientCompany+' '+RecipientState+' '+RecipientCountry+'(Ref '+Coalesce(OriginalReference,OriginalReference2,OriginalReference3)+') ('+convert(varchar(25),isnull(ActualWeightAmount,0))+' '+ActualWeightUnits+')'),',','') as description
             ,NetChargeAmount 
			 ,'' as C
             ,''    as D
                    ,''    as E
                    ,''    as F
                    ,''    as G
                    ,''    as H
                    ,''    as I   
                    ,'' as J
                    ,'' as K
                    ,'' as L
                    ,'' as M
             ,AccountNumber,'Troy'
                    
             from @temp
             order by InvoiceNumber

      
	 
select vendor
             ,convert(varchar,InvoiceDate,101) as InvoiceDate
			 ,convert(varchar,InvoiceDate,101) as GLDate
			 ,vendor as PayVendor
			 ,'211011' as PostingAccount
			 ,NetChargeAmount
			 ,(TrackingId+'*'+ServiceType+' ['+ChargeDescription+'] From '+ShipperCompany+' '+ShipperState+' '+ShipperCountry+' to '+RecipientCompany+' '+RecipientState+' '+RecipientCountry+'(Ref '+Coalesce(OriginalReference,OriginalReference2,OriginalReference3)+') ('+convert(varchar(25),isnull(ActualWeightAmount,0))+' '+ActualWeightUnits+')') as description
             ,AccountNumber as ItemPostingAccount
			 ,InvoiceNumber
             
                    
             from @temp
             order by InvoiceNumber
			  
GO
