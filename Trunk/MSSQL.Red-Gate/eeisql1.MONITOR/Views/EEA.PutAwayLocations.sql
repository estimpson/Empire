SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [EEA].[PutAwayLocations]
as
select
	Location = code
from
	dbo.location l
where
	(	group_no = 'EEA Warehouse'
		and code like 'ALA-[BC]%'
		and	not exists
		(	select
				*
			from
				dbo.object o
			where
				o.location = l.code
		)
	)
	--or code in ('ALA-CERTIF', 'ALA-FINAUD')
	or code in ('AL-CERTI', 'AL-FINAUD')
GO
