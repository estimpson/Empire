SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [NSA].[Users]
as
select
	UserName = e.name
,	UserCode = e.operator_code
,	Initials = upper
		(	(	select
					left(fsstr.Value, 1)
				from
					MONITOR.dbo.fn_SplitStringToRows(e.Name, ' ') fsstr
				where
					fsstr.ID = 1
			) +
			coalesce
			(	(	select
						left(fsstr.Value, 1)
					from
						MONITOR.dbo.fn_SplitStringToRows(e.Name, ' ') fsstr
					where
						fsstr.ID = 2
				)
			,	''
			) +
			coalesce
			(	(	select
						left(fsstr.Value, 1)
					from
						MONITOR.dbo.fn_SplitStringToRows(e.Name, ' ') fsstr
					where
						fsstr.ID = 3
				)
			,	''
			)
		)
,	FirstName =
			(	select
					fsstr.Value
				from
					MONITOR.dbo.fn_SplitStringToRows(e.Name, ' ') fsstr
				where
					fsstr.ID = 1
			)
,	LastName = coalesce
		(	(	select
					fsstr.Value
				from
					MONITOR.dbo.fn_SplitStringToRows(e.Name, ' ') fsstr
				where
					fsstr.ID = 3
			)
		,	(	select
					fsstr.Value
				from
					MONITOR.dbo.fn_SplitStringToRows(e.Name, ' ') fsstr
				where
					fsstr.ID = 2
			)
		)
from
	MONITOR.dbo.employee e
where
	e.name like '% %' and
	e.name not like 'ALA %' and
	e.name not like 'El Paso %'
GO
