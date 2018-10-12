SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[vw_eei_vendors_w_activity]
as
Select	Vendor,
		Vendor_name,
		hdr_terms
from		vendors
where	vendor in (Select vendor from ap_headers where ap_headers.changed_date>=dateadd(mm,-3,getdate()) and isNULL(nullif(currency,''),'XXX')!='LPS')
GO
