SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[uvw_OpenShipper]
as
Select
	s.id,
	case s.status 
		when 'O' Then 'Open'
		when 'S' Then 'Staged'
		end as Status,
	s.bill_of_lading_number,
	sd.part_original,
	sd.customer_part,
	sd.customer_po,
	sd.qty_required,
	sd.qty_packed,
	s.date_stamp,
	sd.release_no,
	s.destination,
	es.parent_destination as EDIShipToCode,
	s.plant
From
	shipper s with(NOLOCK)
Join
	shipper_detail sd with(NOLOCK) on sd.shipper = s.id
join
	edi_setups es with (NOLOCK) on s.destination = es.destination
where
	isNull(s.status, 'X') not in ('C', 'Z', 'E')
GO
