SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE	view
		[dbo].[vwFT_EEASubAssemblyOrderMissing]
as
select	
	distinct
	SubAssembly,
	 Note = 'There is no Sub Assembly sales order or it is not marked active'
from		
	dbo.order_detail od 
Join
(	select	
		FinishedPart = TopPart ,
		SubAssembly = ChildPart ,
		XQty,
		SubAssemblyOrder = (select max(order_no) from order_header where customer = 'EEA' and blanket_part = ChildPart and status = 'A') ,
		BackDays = (select sum(dbo.part_eecustom.backdays) from dbo.part_eecustom where part in (ChildPart))
	from		
		FT.XRt
	where	exists (select	1 from dbo.order_header where blanket_part = ChildPart) and	
		childPart!=TopPart) BOMOrder on od.part_number = FinishedPart
	group by
		SubAssemblyOrder,
		SubAssembly,
		DateAdd (wk, DateDiff(wk, '2001-01-01', od.due_date - coalesce(BackDays, 0)),'2001-01-01')
	having
		isNull(SubAssemblyOrder,0) =0
GO
