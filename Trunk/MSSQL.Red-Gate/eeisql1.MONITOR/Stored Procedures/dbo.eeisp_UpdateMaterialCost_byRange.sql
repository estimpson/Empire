SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[eeisp_UpdateMaterialCost_byRange]
(	@Part varchar(25),
	@FiscalYear int,
	@Period int,
	@Cost numeric(20,6),
	@BeginDT datetime,
	@EndDT datetime)
as
set nocount on
update	part_standard
set	cost = @Cost,
	material = @Cost,
	cost_cum = @Cost,
	material_cum = @Cost
where	part = @Part

update	part_standard_historical
set	cost = @Cost,
	material = @Cost,
	cost_cum = @Cost,
	material_cum = @Cost
where	part = @Part and
	fiscal_year = @FiscalYear and
	period = @Period - 1

update	part_standard_historical_daily
set	cost = @Cost,
	material = @Cost,
	cost_cum = @Cost,
	material_cum = @Cost
where	part = @Part and
	fiscal_year = @FiscalYear and
	period = @Period

update	object_historical_daily
set	cost = @Cost,
	std_cost = @Cost
where	part = @Part and
	fiscal_year = @FiscalYear and
	period = @Period
	
update	object_historical_daily
set	cost = @Cost,
	std_cost = @Cost
where	part = @Part and
	fiscal_year = @FiscalYear and
	period = @Period-1 and
	time_stamp =
	(	select	max (time_stamp)
		from	object_historical_daily
		where	part = @Part and
			fiscal_year = @FiscalYear and
			period = @Period - 1)

update	audit_trail
set	posted = 'N'
where	part  =  @Part and
	date_stamp between @BeginDT and @EndDT and
	type in ('R', 'S', 'D', 'M', 'A', 'J', 'U', 'V')

select	'Updated Part ' + part  + ' Successfully'
from	part
where	part = @Part
GO
