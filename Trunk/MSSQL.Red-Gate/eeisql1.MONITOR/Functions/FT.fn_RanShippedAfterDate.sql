SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE function [FT].[fn_RanShippedAfterDate]
(	@Date1 datetime,
	@RAN	varchar(50))
returns	int
as
begin
	declare	@RanShippedQty int

	Select @RanShippedQty = sum(qty)
	From
		NALRanNumbersShipped ran
	join
		shipper s on s.id = ran.Shipper
	where
		RanNumber = @RAN and
		date_shipped >= @Date1
		
	return	@RanShippedQty
end


GO
