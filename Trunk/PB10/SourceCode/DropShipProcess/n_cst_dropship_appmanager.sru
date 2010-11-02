HA$PBExportHeader$n_cst_dropship_appmanager.sru
forward
global type n_cst_dropship_appmanager from n_cst_appmanager
end type
end forward

global type n_cst_dropship_appmanager from n_cst_appmanager
end type
global n_cst_dropship_appmanager n_cst_dropship_appmanager

on n_cst_dropship_appmanager.create
call super::create
end on

on n_cst_dropship_appmanager.destroy
call super::destroy
end on

event constructor;call super::constructor;
n_cst_registry	lncst_Registry
of_SetAppKey ( lncst_Registry.LMP + lncst_Registry.ROOT + "DropShip Process" )
of_SetUserKey ( lncst_Registry.CUP + lncst_Registry.ROOT + "DropShip Process" )

end event

event pfc_postsplash;call super::pfc_postsplash;
//	Use application preferences.
of_SetAppPreference ( true )
inv_AppPref.of_SetRestoreApp ( true )

//	Open frame window.
open ( w_dropship_frame )

end event

