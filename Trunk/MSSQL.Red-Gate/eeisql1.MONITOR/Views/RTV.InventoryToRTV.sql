SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [RTV].[InventoryToRTV]
as
select
	Serial = o.serial
,	Part = coalesce
		(	nullif(p.part, 'PALLET')
		,	'<' + coalesce(nullif(o.part, ''), 'N/A') + '>'
		)
,	Quantity = o.std_quantity
,	ProductLine = coalesce(p.product_line, '<INVALID PART>')
,	Valid = case when p.class = 'P' and o.type is null then 1 else 0 end
,	Message =
		case
			when o.part = 'PALLET' then 'Pallets are invalid for return.'
			when coalesce(p.class, '') != 'P' then 'Only purchased parts are valid for return.  Class:' + coalesce(nullif(p.class, ''), 'N/A')
			else 'Good'
		end
from
	dbo.object o
	left join dbo.part p on
		o.part = p.part
		and p.part != 'PALLET'
GO
