HA$PBExportHeader$app_dropshipporefresh.sra
$PBExportComments$Generated Application Object
forward
global type app_dropshipporefresh from application
end type
global n_tr_dropship sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global n_err error
global n_msg message
end forward

global variables
n_cst_dropshiprefreshpo_appmanager	gnv_App

end variables

global type app_dropshipporefresh from application
string appname = "app_dropshipporefresh"
end type
global app_dropshipporefresh app_dropshipporefresh

on app_dropshipporefresh.create
appname="app_dropshipporefresh"
message=create n_msg
sqlca=create n_tr_dropship
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create n_err
end on

on app_dropshipporefresh.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;
gnv_App = create n_cst_dropshiprefreshpo_appmanager
gnv_App.event pfc_Open ( commandline )

end event

