SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [EEIUser].[web_ar_pastdue_u1] 

as
begin


INSERT INTO [dbo].[order_detail_historical] 
select 
    getdate(),    
	[order_no],
	[part_number],
	[type],
	[product_name],
	[quantity],
	[price],
	[notes],
	[assigned], 
	[shipped],
	[invoiced], 
	[status],
	[our_cum],
	[the_cum],
	[due_date],
	[sequence],
	[destination],
	[unit],
	[committed_qty],
	[row_id],
	[group_no], 
	[cost],
	[plant],
	[release_no], 
	[flag], 
	[week_no],
	[std_qty], 
	[customer_part],
	[ship_type],
	[dropship_po], 
	[dropship_po_row_id],
	[suffix],
	[packline_qty],
	[packaging_type],
	[weight], 
	[custom01],
	[custom02],
	[custom03],
	[dimension_qty_string],
	[engineering_level],
	[alternate_price],
	[box_label],
	[pallet_label],
	[id] [int],
	[EEIEntry],
	[eeiqty]
from order_detail


end


GO
