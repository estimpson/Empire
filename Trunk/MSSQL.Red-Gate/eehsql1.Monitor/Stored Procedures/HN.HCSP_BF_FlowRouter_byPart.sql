SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create	procedure [HN].[HCSP_BF_FlowRouter_byPart](
	@Part varchar(25),
	@FromDt datetime,
	@ToDt datetime)
as

select	toppart, childpart,xQty
from	ft.FlowRouter_ProcessInputs
where	toppart in (
		    select	toppart
		    from	ft.FlowRouter_ProcessInputs
		    where	childpart like @Part and
			    toppart in (
					select	part
					from	audit_trail
					where	type = 'J'
						and date_stamp between @FromDt and @ToDt
						and part like 'TM%'))
GO
