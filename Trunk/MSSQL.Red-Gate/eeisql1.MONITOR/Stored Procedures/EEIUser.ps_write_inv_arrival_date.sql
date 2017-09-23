SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[ps_write_inv_arrival_date] @location varchar(10), @ArrivalDate varchar(25)

as 

begin
update object set date_due = convert(datetime,@ArrivalDate) where location = @location

Select	serial, 
		part,
		location,
		quantity,
		date_due as ArrivalDate
from 
	object
where
	location =  @location




end




GO
