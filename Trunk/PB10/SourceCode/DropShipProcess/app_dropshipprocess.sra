HA$PBExportHeader$app_dropshipprocess.sra
$PBExportComments$Generated Application Object
forward
global type app_dropshipprocess from application
end type
global n_tr_dropship sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global n_err error
global n_msg message
end forward

global variables
n_cst_dropship_appmanager	gnv_App

end variables

global type app_dropshipprocess from application
string appname = "app_dropshipprocess"
end type
global app_dropshipprocess app_dropshipprocess

on app_dropshipprocess.create
appname="app_dropshipprocess"
message=create n_msg
sqlca=create n_tr_dropship
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create n_err
end on

on app_dropshipprocess.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;
ToolbarFrameTitle = "Drop Ship Processor"
ToolbarSheetTitle = "Drop Ship Processor"
DisplayName = "Drop Ship Processor"
gnv_App = create n_cst_dropship_appmanager
gnv_App.event pfc_Open ( commandline )

end event

