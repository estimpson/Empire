SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[cdivw_msf_inv] 
	(description,
	unit,
	onhand,
	wo_quantity,
	batch_quantity,
	bom_part,
	bom_qty,
	work_order)
as	
SELECT	Max ( name ) description,   
	Max ( unit_measure ) unit,   
	Max ( isnull(on_hand,0) ) onhand,   
	Sum ( isnull(quantity,0) * isnull(qty_required,0) ) wo_quantity,   
	Sum ( isnull(mfg_lot_size,0) * isnull(quantity,0) ) batch_quantity,   
	Max ( bill_of_material.part ) bom_part,
	Sum ( isnull(quantity,0) ) bom_qty,
	max ( work_order.work_order)
from
	work_order
	join workorder_detail
		on workorder_detail.workorder = work_order.work_order
	join bill_of_material
		on bill_of_material.parent_part = workorder_detail.part
		and bill_of_material.substitute_part <> 'Y'
	join part
		on bill_of_material.part = part.part
	left join part_online
		on part_online.part = part.part
	join part_mfg
		on workorder_detail.part = part_mfg.part
where
	( work_order.machine_no = (select machine from machine_policy where machine = work_order.machine_no and material_substitution = 'N'))
GROUP BY bill_of_material.part, work_order.work_order 
GO
