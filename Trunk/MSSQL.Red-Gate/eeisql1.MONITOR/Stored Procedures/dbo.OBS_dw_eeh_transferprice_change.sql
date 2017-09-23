SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[OBS_dw_eeh_transferprice_change] (@new_price numeric(30,6), @target_part varchar(25))
as
begin

update part_standard set price = @new_price where part = @target_part
update part_customer set blanket_price = @new_price where part = @target_part
update part_customer_price_matrix set price = @new_price, alternate_price = @new_price where part = @target_part
update order_header set price = @new_price, alternate_price = @new_price where blanket_part = @target_part
update order_detail set price = @new_price, alternate_price = @new_price where part_number = @target_part
update part_standard_copy_20060430 set price = @new_price where part = @target_part

end
GO
