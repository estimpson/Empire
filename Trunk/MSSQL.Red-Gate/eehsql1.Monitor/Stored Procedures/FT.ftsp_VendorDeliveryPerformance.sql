SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [FT].[ftsp_VendorDeliveryPerformance]
(	
	@PONumber numeric (8,0))
as
	exec	EEH.[FT].[ftsp_VendorDeliveryPerformance]
				@PONumber = @PONumber
GO
