SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


Create function [FT].[fn_RanShippedBetweenDates]
(	@Date1 datetime,
	@Date2 datetime,
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
		date_shipped > @Date1 and
		date_shipped <= @date2
		
	return	@RanShippedQty
end

GO
