SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [eeiuser].[acctg_po_lookup_correct_company] @purchase_order varchar(10)
as
select part, name, product_line from part where part = (select item from po_items where purchase_order = @purchase_order
)
GO
