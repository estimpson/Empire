SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[requisitions_openQHs] as 

select		Req.requisition,requisition_items.item,requisition_items.quantity,
			Vendors.Vendor, Amount=Req.document_amount, req.document_date,  document_comments, req.requester, --approver = Upper(EmpowerUserName.Name), 
                               approval_sequence, req.buy_unit, Req.requested_by, approver 
from      Monitor.dbo.requisitions Req
join	Monitor.dbo.requisition_items on Req.requisition = requisition_items.requisition 
                               join Monitor.dbo.document_approval_items approvers on Req.requisition = approvers.document_id1
                                                               --join monitor.dbo.EmpowerUserName on EmpowerUserName.security_id = approvers.approver
                               join (     select    Req.requisition, Lastsequence= min( approvers.approval_sequence )
                                                               from      Monitor.dbo.requisitions Req
                                                                         join Monitor.dbo.document_approval_items approvers on Req.requisition = approvers.document_id1
                                                                                              --join monitor.dbo.EmpowerUserName on EmpowerUserName.security_id = approvers.approver
                                                               WHERE Req.buy_unit IN ('12','08','08L','12l')
                                                                                              AND isnull(req.approved,0) =0
                                                                                              and isnull(approvers.approved,0) = 0
                                                               group by Req.requisition) LastApproval on LastApproval.requisition = Req.requisition and LastApproval.Lastsequence = approvers.approval_sequence
                               left join ( select requisition, Vendor = Max( Buy_vendor) from monitor.dbo.requisition_items group by requisition   ) Vendors on vendors.requisition = Req.requisition
WHERE Req.buy_unit IN ('12','08','08L','12l')
                               AND isnull(req.approved,0) =0 and datepart(YEAR,document_date)>=2016 and req.canceled =0
                               and isnull(approvers.approved,0) = 0 
							   --and Req.requisition ='QH080995'
--order by requisition, approval_sequence

GO
