SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [EEIUser].[acctg_ap_file_labels]

as

select distinct(ap_applications.pay_vendor), vendor_name   
from ap_applications join vendors on ap_applications.pay_vendor = vendors.vendor
 where applied_date >= '2013-01-01' and applied_date < '2014-01-01'  
 
 
 union  
 
 select distinct(ap_applications.pay_vendor), vendor_name   
 from eehsql1.monitor.dbo.ap_applications join eehsql1.monitor.dbo.vendors on ap_applications.pay_vendor = vendors.vendor 
 where applied_date >= '2013-01-01' and applied_date < '2014-01-01' and pay_unit not like '%L%' 
 
GO
