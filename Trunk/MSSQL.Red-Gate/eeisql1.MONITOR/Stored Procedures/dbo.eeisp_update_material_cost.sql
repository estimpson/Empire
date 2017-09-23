SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[eeisp_update_material_cost]
(	@part varchar(25),
	@fiscal_year int,
	@period int,
	@cost numeric(20,6),
	@date_stamp datetime,
	@end_date_stamp datetime)
as
set nocount on

declare @UpdateMessage table(
UpdatedTableInfo varchar(255))


update	part_standard
set	cost = @cost,
	material = @cost,
	cost_cum = @cost,
	material_cum = @cost
where	part = @part

insert  @UpdateMessage
Select	convert(varchar(15), @@rowCount) + ' rows updated for part_standard for part ' + @part


update	part_standard_historical
set	cost = @cost,
	material = @cost,
	cost_cum = @cost,
	material_cum = @cost
where	part = @part and
	fiscal_year = @fiscal_year and
	period = @period

insert  @UpdateMessage
Select	convert(varchar(15), @@rowCount) + ' rows updated for part_standard_historical for  part ' + @part

update	part_standard_historical_daily
set	cost = @cost,
	material = @cost,
	cost_cum = @cost,
	material_cum = @cost
where	part = @part and
	fiscal_year = @fiscal_year and
	period = @period

insert  @UpdateMessage
Select	convert(varchar(15), @@rowCount) + ' rows updated for part_standard_historical_daily for part ' + @part

update	object_historical_daily
set	cost = @cost,
	std_cost = @cost
where	part = @part and
	fiscal_year = @fiscal_year and
	period = @period


insert  @UpdateMessage
Select	convert(varchar(15), @@rowCount) + ' rows updated for object_historical_daily for part ' + @part
	
update	object_historical
set	cost = @cost,
	std_cost = @cost
where	part = @part and
	fiscal_year = @fiscal_year and
	period = @period 

insert  @UpdateMessage
Select	convert(varchar(15), @@rowCount) + ' rows updated for object_historical for part ' + @part


If	@date_stamp is not NULL
Begin
update	audit_trail
set	posted = 'N'
where	part  =  @part and
	date_stamp >= @date_stamp and
	date_stamp <= @end_date_stamp and
	type in ('R', 'S', 'D', 'M', 'A', 'J', 'U', 'V')
insert  @UpdateMessage
select	'Updated ' + convert(varchar(15), @@rowcount) + ' audit trail rows '  +' ;Updated Part Historical and Object Historical Tables for ' + part  + ' Successfully'
from	part
where	part = @part
end


Else
insert  @UpdateMessage
select	'Updated Part Historical and Object Historical Tables for ' + part  + ' Successfully'
from	part
where	part = @part

Select * from @UpdateMessage
GO
