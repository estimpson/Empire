--List box fill - $A$1:$C$14095
declare
	@B varchar(50) = ''-- 'List box fill'!$N$5
,	@AS varchar(50) = '' -- 'List box fill'!$N$2
,	@AE varchar(50) = '' -- 'List box fill'!$N$3
,	@SP varchar(50) = '' -- 'List box fill'!$N$4

select
	part_number
,	quantity
,	due_date
,	prod_end
,	prod_start
,	AplicaSOP
,	AplicaEOP
,	BuyerID
,	Buyer
from
(
	select
		order_detail.part_number
	,	order_detail.quantity
	,	order_detail.due_date
	,	part_eecustom.prod_end
	,	part_eecustom.prod_start
	,	AplicaSOP = case when part_eecustom.prod_start >= getdate() then '1' else '0' end
	,	AplicaEOP = case
						when datediff(month, getdate(), part_eecustom.prod_end) >= 6 then
							'1'
						else
							'0'
					end
	,	ServicePart = isnull(ServicePart, 'N')
	,	BuyerID = po_header.buyer
	,	Buyer = Employee.name
	from
		MONITOR.dbo.order_detail order_detail
		inner join MONITOR.dbo.part_eecustom part_eecustom
			on order_detail.part_number = part_eecustom.part
		left join MONITOR.dbo.po_header po_header
			on po_header.blanket_part = order_detail.part_number
		left join MONITOR.dbo.employee Employee
			on po_header.buyer = Employee.operator_code
	where
		(order_detail.quantity > 0)
		and (isnull(custom01, 'XXX') <> 'ASB')
) Informacion
where
	Buyer like @B + '%'
	and AplicaSOP like @AS + '%'
	and AplicaEOP like @AE + '%'
	and ServicePart like @SP + '%'
order by
	Informacion.part_number;