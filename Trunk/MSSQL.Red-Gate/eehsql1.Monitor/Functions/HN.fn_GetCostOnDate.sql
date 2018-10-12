SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [HN].[fn_GetCostOnDate]( @Part varchar(25), @Date datetime )
returns numeric(20,6)
as
begin

	declare @Cost numeric(20,6)
	declare @Today datetime
	
	set	@Today  = dbo.fn_Today()
	set @Cost = null
	
	if	datediff( d, @Today, @Date ) = 0 begin
		select	@Cost = Material_Cum
		from	part_standard
		where	part = @Part                                  	
	end
	else begin 
		select	@Cost = Material_Cum
		from	part_standard_historical_daily
		where	part = @Part
				and time_stamp = (	select	Max(time_stamp)
									from	part_standard_historical_daily
									where	part = @Part
											and datediff( d, time_stamp, @Date ) > 0)
	end
	
	return @Cost
end

GO
