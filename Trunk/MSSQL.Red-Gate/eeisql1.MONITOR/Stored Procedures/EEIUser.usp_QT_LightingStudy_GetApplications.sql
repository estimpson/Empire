SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_LightingStudy_GetApplications]
as
set nocount on
set ansi_warnings on;

--- <Body>
select
	hl.[Application]
from
	eeiuser.ST_LightingStudy_Hitlist_2016 hl
group by
	hl.[Application]
order by
	hl.[Application] asc
--- </Body>
GO
