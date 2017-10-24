SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_LightingStudy_GetSOPs]
	@Application varchar(50)
,	@Program varchar(50)
,	@LEDHarness varchar(50)
as
set nocount on
set ansi_warnings on;

--- <Body>
select
	convert(varchar, convert(date, hl.SOP)) as SOP
from
	eeiuser.ST_LightingStudy_Hitlist_2016 hl
where
	hl.[Application] = @Application
	and hl.Program = @Program
	and hl.[LED/Harness] = @LEDHarness
group by
	hl.SOP
order by
	hl.SOP asc
--- </Body>
GO
