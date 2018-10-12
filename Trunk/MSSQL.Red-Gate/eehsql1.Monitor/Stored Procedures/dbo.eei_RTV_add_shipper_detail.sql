SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[eei_RTV_add_shipper_detail] (@shipper int, @operator varchar(10), @unit varchar(2), @part varchar(25), @quantity int)
as
Begin 
insert shipper_detail (shipper, part, qty_required, qty_packed, qty_original, order_no, alternative_qty,alternative_unit, operator, week_no, customer_part, part_name, part_original) 
Select @shipper, @part, @quantity, @quantity, @quantity, 0,@quantity,@unit,@operator, datepart(ww, getdate()), @part, (Select part.name from part where part =@part),@part
End
GO
