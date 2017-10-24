
/*
Create View.Fx.EEA.EEAPIBSRF_UserAccess.sql
*/

--use Fx
--go

--drop table EEA.EEAPIBSRF_UserAccess
if	objectproperty(object_id('EEA.EEAPIBSRF_UserAccess'), 'IsView') = 1 begin
	drop view EEA.EEAPIBSRF_UserAccess
end
go

create view EEA.EEAPIBSRF_UserAccess
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
go

select
	eua.ApplicationName
,	eua.MenuItemName
,	eua.MenuIcon
,	eua.MenuText
,	eua.ObjectClass
,	eua.ObjectType
,	eua.Level
,	eua.Sequence
,	eua.Chain
,	eua.OperatorCode
,	eua.UserAccess
from
	EEA.EEAPIBSRF_UserAccess eua
where
	eua.OperatorCode = 'ES'
order by
	eua.Sequence
go
