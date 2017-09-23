SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [EEIUser].[eeisp_test_order_detail_copy]
as
begin
Select  *  into #orderdetailcopy
from		order_detail
where	type = 'P'
Select * from #orderdetailcopy
end
GO
