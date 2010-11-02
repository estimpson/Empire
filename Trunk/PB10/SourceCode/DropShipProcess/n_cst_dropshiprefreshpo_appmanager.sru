HA$PBExportHeader$n_cst_dropshiprefreshpo_appmanager.sru
forward
global type n_cst_dropshiprefreshpo_appmanager from n_cst_appmanager
end type
end forward

global type n_cst_dropshiprefreshpo_appmanager from n_cst_appmanager
end type
global n_cst_dropshiprefreshpo_appmanager n_cst_dropshiprefreshpo_appmanager

on n_cst_dropshiprefreshpo_appmanager.create
call super::create
end on

on n_cst_dropshiprefreshpo_appmanager.destroy
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
open ( w_dropshiprefreshpo_frame )

end event

