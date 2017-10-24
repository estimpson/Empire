SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[EEH_Q_Inventory_Items_fxDelete] as SELECT A.*, items.Item_Description   FROM (select distinct item_locations.item, item_locations.on_hand_quantity, vendor_items.expense_ledger_account 
from item_locations as item_locations,items as items,vendor_items as vendor_items 
where item_locations.item=items.item and items.item=vendor_items.item and((item_locations.location='Troy') and(items.inventoried='Y') or(item_locations.location='HONDURAS') and(items.inventoried='Y')) and((vendor_items.expense_ledger_account<>'155112') or(vendor_items.expense_ledger_account<>'155112')) ) AS A INNER JOIN items ON a.Item = items.Item
GO
