SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [dbo].[DMAX_asn_detail]  (@shipper integer)
as
--DMAX_asn_detail 88869
Begin

SELECT 		max(edi_setups.prev_cum_in_asn),
		shipper_detail.customer_part, 
		sum(shipper_detail.alternative_qty), 
		max(shipper_detail.alternative_unit), 
		sum(shipper_detail.net_weight), 
		sum(shipper_detail.gross_weight), 
		max(shipper_detail.accum_shipped), 
		shipper_detail.shipper, 
		coalesce(order_header.customer_po, shipper_detail.customer_po),
		max(shipper_detail.accum_shipped) as accum2,
		max(coalesce(order_header.engineering_level,'A')),
		convert(varchar(10),sum(boxes_staged))
 
FROM 	shipper
join	shipper_detail on shipper_detail.shipper = shipper.id
join	edi_setups 	on edi_setups.destination = shipper.destination
left join order_header on order_header.order_no = shipper_detail.order_no
WHERE	( shipper.id = @shipper) 
Group by
	shipper_detail.shipper,
	shipper_detail.customer_part,
	coalesce(order_header.customer_po, shipper_detail.customer_po)

ORDER BY	2

End





GO
