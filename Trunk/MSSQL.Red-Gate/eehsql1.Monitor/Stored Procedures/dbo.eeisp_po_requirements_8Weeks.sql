SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[eeisp_po_requirements_8Weeks]
as
Begin

Select	po_header.vendor_code,
		part_number,
		ft.fn_truncdate('wk', po_detail.date_due) as WeekDue,
		sum(balance*alternate_price)
from		po_header
join		po_detail on po_header.po_number = po_detail.po_number
where	po_detail.date_due <  dateadd(wk, 9, ft.fn_truncdate('wk', getdate())) and po_detail.date_due> dateadd(dd, -30, getdate()) and balance > 0
group  by po_header.vendor_code,
		part_number,
		ft.fn_truncdate('wk', po_detail.date_due)

end
		

GO
