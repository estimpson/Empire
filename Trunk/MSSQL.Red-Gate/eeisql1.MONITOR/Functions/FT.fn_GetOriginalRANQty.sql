SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE function [FT].[fn_GetOriginalRANQty]
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
	EDI.NAL_862_Releases nal862a
where
	ShipToCode = @ShipToCode and
	CustomerPart = @CustomerPart and
	ReleaseNo = @RANNumber and
	RowCreateDT = (Select min(RowCreateDT) from EDI.NAL_862_Releases nal862b where nal862b.Status != -1 and ReleaseNo = nal862a.releaseNo and nal862b.ShipToCode = nal862a.ShipToCode and nal862b.CustomerPart = nal862a.CustomerPart ))
	
	
	return
		@OriginalRanQty
end



GO
