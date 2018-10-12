SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [eeiuser].[find_invoice] 
(@purchase_order varchar(10))
as
select buy_vendor, purchase_order,ap_document, por_shipping_advice, item, item_description, quantity, unit_cost, quantity*unit_cost as ext_cost, * from eeh_empower.dbo.ap_document_items where purchase_order = @purchase_order

GO
