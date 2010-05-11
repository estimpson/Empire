HA$PBExportHeader$w_print_preview.srw
$PBExportComments$Generic form print preview window
forward
global type w_print_preview from Window
end type
type st_form from statictext within w_print_preview
end type
end forward

global type w_print_preview from Window
int X=0
int Y=0
int Width=1623
int Height=956
boolean Visible=false
boolean Enabled=false
boolean TitleBar=true
string Title="Preview "
long BackColor=12632256
event print pbm_custom01
event zoom pbm_custom02
event pro_cert pbm_custom03
st_form st_form
end type
global w_print_preview w_print_preview

type variables
st_print_preview_generic stParm
                        
String s_printed_status

Long lCurrentDocument
Long lPosition

Boolean bBatch
Boolean	ib_MissingData
Boolean  bprocess = False
boolean  i_b_quick_shipper
Integer i_row = 1


end variables

event open;st_generic_Structure l_st_parm
window     l_w_name

stParm = Message.PowerObjectParm

l_st_parm.value1 =  string ( stparm.document_number )
l_st_parm.value11 = stparm.form_type
setnull( l_st_parm.value12 )
if isnull(stparm.additional_formname,'') > '' then 
	l_st_parm.value12 = stparm.additional_formname
end if 
IF IsValid ( w_main_screen ) THEN
	OpenSheetWithParm ( w_report_view, l_st_parm, w_main_screen, 0, Layered! )
ELSEIF IsValid ( wmainscreen ) THEN
	OpenSheetWithParm ( w_report_view, l_st_parm, wmainscreen, 0, Layered! )
ELSE
	OpenWithParm ( w_report_view, l_st_parm )
END IF

close ( this )

Return 0

end event
on w_print_preview.create
this.st_form=create st_form
this.Control[]={this.st_form}
end on

on w_print_preview.destroy
destroy(this.st_form)
end on

type st_form from statictext within w_print_preview
int X=3072
int Y=32
int Width=1134
int Height=68
boolean Enabled=false
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=12632256
int TextSize=-8
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

