SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_LightingStudy_GetPrograms]
	@Application varchar(50)
as
set nocount on
set ansi_warnings on;

--- <Body>
select
	hl.Program
from
	eeiuser.ST_LightingStudy_Hitlist_2016 hl
where
	hl.[Application] = @Application
group by
	hl.Program
order by
	hl.Program asc
--- </Body>
GO
