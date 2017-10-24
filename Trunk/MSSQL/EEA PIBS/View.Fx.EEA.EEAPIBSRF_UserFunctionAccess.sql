
/*
Create View.Fx.EEA.EEAPIBSRF_UserFunctionAccess.sql
*/

--use Fx
--go

--drop table EEA.EEAPIBSRF_UserFunctionAccess
if	objectproperty(object_id('EEA.EEAPIBSRF_UserFunctionAccess'), 'IsView') = 1 begin
	drop view EEA.EEAPIBSRF_UserFunctionAccess
end
go

create view EEA.EEAPIBSRF_UserFunctionAccess
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
	and mua.ObjectType = 'Function'
go

select
	eufa.ApplicationName
,	eufa.MenuItemName
,	eufa.MenuIcon
,	eufa.MenuText
,	eufa.ObjectClass
,	eufa.ObjectType
,	eufa.Level
,	eufa.Sequence
,	eufa.Chain
,	eufa.OperatorCode
,	eufa.UserAccess
from
	EEA.EEAPIBSRF_UserFunctionAccess eufa
where
	eufa.OperatorCode = 'ES'
order by
	eufa.Sequence
go
