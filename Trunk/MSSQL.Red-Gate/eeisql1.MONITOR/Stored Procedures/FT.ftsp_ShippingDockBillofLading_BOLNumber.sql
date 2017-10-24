SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
create procedure [FT].[ftsp_ShippingDockBillofLading_BOLNumber]
(	@BOLNumber int)
as
select	bol_number,
	scac_transfer,
	scac_pickup,
	trans_mode,
	equipment_initial,
	equipment_description,
	status,
	printed,
	gross_weight,
	net_weight,
	tare_weight,
	destination,
	lading_quantity,
	total_boxes
from	bill_of_lading
where	bol_number = @BOLNumber
GO
