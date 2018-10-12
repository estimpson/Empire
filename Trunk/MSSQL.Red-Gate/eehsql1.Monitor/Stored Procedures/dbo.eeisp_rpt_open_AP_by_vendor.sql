SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[eeisp_rpt_open_AP_by_vendor] (@Vendor varchar(20))
as
Begin

Select	Vendor,
		inv_cm_flag,
		invoice_cm,
		inv_cm_date,
		received_date,
		exchanged_amount - applied_amount as openAmount
 from	ap_headers 
where	exchanged_amount - applied_amount != 0 and vendor = @vendor
End
GO
