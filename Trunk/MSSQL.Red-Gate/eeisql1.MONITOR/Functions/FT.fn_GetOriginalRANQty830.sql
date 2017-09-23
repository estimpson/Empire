SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [FT].[fn_GetOriginalRANQty830]
(	@RANNumber varchar(50),
	@ShipToCode varchar(25),
	@CustomerPart varchar(25)
)
returns integer
as 
begin

declare	@OriginalRanQty integer

set @OriginalRanQty =  (Select max(ReleaseQty)
From
	EDI.NAL_830_Releases nal830a
where
	ShipToCode = @ShipToCode and
	CustomerPart = @CustomerPart and
	ReleaseNo = @RANNumber and
	RowCreateDT = (Select min(RowCreateDT) from EDI.NAL_830_Releases nal830b where nal830b.ReleaseNo = nal830a.releaseNo and nal830b.ShipToCode = nal830a.ShipToCode and nal830b.CustomerPart = nal830a.CustomerPart ))
	
	
	return
		@OriginalRanQty
end


GO
