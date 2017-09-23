SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_LightingStudy_GetLEDHarness]
	@Application varchar(50)
,	@Program varchar(50)
as
set nocount on
set ansi_warnings on;

--- <Body>
select
	hl.[LED/Harness]
from
	eeiuser.ST_LightingStudy_Hitlist_2016 hl
where
	hl.[Application] = @Application
	and hl.Program = @Program
group by
	hl.[LED/Harness]
order by
	hl.[LED/Harness] asc
--- </Body>
GO
