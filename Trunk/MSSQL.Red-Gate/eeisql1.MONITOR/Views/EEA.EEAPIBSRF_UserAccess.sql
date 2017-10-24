SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EEA].[EEAPIBSRF_UserAccess]
as
select
	mua.ApplicationName
,	mua.MenuItemName
,	mua.MenuIcon
,	mua.MenuText
,	mua.ObjectClass
,	mua.ObjectType
,	mua.Level
,	Sequence = row_number() over (partition by mua.OperatorCode order by mua.Sequence)
,	mua.Chain
,	mua.OperatorCode
,	mua.UserAccess
from
	FT.MenuUserAccess mua
where
	mua.Chain like
		(	select
				mdata.mcode
			from
				dbo.mdata
			where
				mdata.mname = 'EEAPIBSRF'
		) + '[0-9]%'
	and mua.ObjectType = 'RF.Tab'
GO
