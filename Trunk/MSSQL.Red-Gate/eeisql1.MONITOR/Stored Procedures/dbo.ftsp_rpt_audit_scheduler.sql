SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE 	procedure [dbo].[ftsp_rpt_audit_scheduler] as
begin
	select	distinct pc.customer, destination,scheduler
	from	dbo.part_customer pc 
	join	destination d on pc.customer = d.customer
	order by 1,2,3 
end
GO
