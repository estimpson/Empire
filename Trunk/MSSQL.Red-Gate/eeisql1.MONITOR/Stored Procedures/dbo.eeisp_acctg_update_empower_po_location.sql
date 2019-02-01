SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[eeisp_acctg_update_empower_po_location] @po_number varchar(15), @location varchar(15)

as

update empower..purchase_orders set location = @location where purchase_order = @po_number
update empower..purchase_order_items set location = @location where purchase_order = @po_number







GO
