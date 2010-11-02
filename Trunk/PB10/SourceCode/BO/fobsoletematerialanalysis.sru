HA$PBExportHeader$fobsoletematerialanalysis.sru
forward
global type fobsoletematerialanalysis from n_businessobjectfactory
end type
end forward

global type fobsoletematerialanalysis from n_businessobjectfactory
end type

type variables

end variables

forward prototypes
public function boobsoletematerialanalysis of_newoma (string as_userid, string as_description)
public function boobsoletematerialanalysis of_getoma (long al_id)
end prototypes

public function boobsoletematerialanalysis of_newoma (string as_userid, string as_description);
boObsoleteMaterialAnalysis	lbo_OMA

lbo_OMA = create boObsoleteMaterialAnalysis
if lbo_OMA.of_New (as_UserID, as_Description) = SUCCESS then
	return lbo_OMA
else
	destroy lbo_OMA
	return lbo_OMA
end if


end function

public function boobsoletematerialanalysis of_getoma (long al_id);
boObsoleteMaterialAnalysis	lbo_OMA

lbo_OMA = create boObsoleteMaterialAnalysis
if lbo_OMA.of_Get (al_Id) = SUCCESS then
	return lbo_OMA
else
	destroy lbo_OMA
	return lbo_OMA
end if


end function

on fobsoletematerialanalysis.create
call super::create
end on

on fobsoletematerialanalysis.destroy
call super::destroy
end on

