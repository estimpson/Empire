HA$PBExportHeader$w_inquiry_ancestor.srw
$PBExportComments$inquiry window ancestor
forward
global type w_inquiry_ancestor from Window
end type
type st_1 from statictext within w_inquiry_ancestor
end type
type dw_inquiry from datawindow within w_inquiry_ancestor
end type
end forward

global type w_inquiry_ancestor from Window
int X=832
int Y=360
int Width=3067
int Height=1556
boolean TitleBar=true
long BackColor=77897888
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
event ue_add pbm_custom01
event ue_delete pbm_custom02
event ue_filter pbm_custom03
event ue_reset pbm_custom04
event ue_sort pbm_custom05
event ue_open pbm_custom06
event ue_cancel ( )
event ue_activate pbm_custom07
event ue_refresh ( )
event ue_print ( )
st_1 st_1
dw_inquiry dw_inquiry
end type
global w_inquiry_ancestor w_inquiry_ancestor

type variables
string		i_s_original_syntax,&
		i_s_retrieve_all,&
		i_s_title,&
		i_s_primary_column
string		is_default_operator
boolean		i_b_cancel
end variables

event ue_filter;str_generic_search	l_str_parm
string					l_s_whereclause,&
							l_s_firsthalf,&
							l_s_secondhalf,&
							l_s_dummy,&
							l_s_sqlsyntax
long						l_l_count							
int						l_i_pos

l_s_sqlsyntax = i_s_original_syntax

// Setup parm values and open search window
f_get_tables_from_select ( dw_inquiry.object.datawindow.table.select, l_str_parm.s_tables )
l_str_parm.b_allow_retrieve_all = TRUE
l_str_parm.primary_column = i_s_primary_column
l_str_parm.parent_title = this.title
l_str_parm.default_operator = is_default_operator

OpenWithParm ( w_generic_search, l_str_parm )

l_s_whereclause = Message.StringParm

if l_s_whereclause <> 'cancel' then

	if l_s_whereclause <> 'all' and l_s_whereclause > '' then
		
		l_i_pos = Pos ( l_s_sqlsyntax, "ORDER BY" )
	
		If l_i_pos > 0 Then
			l_s_FirstHalf = Left ( l_s_sqlsyntax, l_i_pos - 1 )
			l_s_SecondHalf = Right ( l_s_sqlsyntax, Len ( l_s_sqlsyntax ) - l_i_pos + 2 )
			l_s_sqlsyntax = l_s_FirstHalf + " WHERE " + l_s_WhereClause + l_s_SecondHalf
		Else
			l_s_sqlsyntax = l_s_sqlsyntax + " WHERE " + l_s_WhereClause
		End if
	
		l_s_dummy = ""
		
		For l_l_count = 1 to Len ( l_s_sqlsyntax )
			If Mid ( l_s_sqlsyntax, l_l_count, 1 ) <> "~~" Then
				l_s_dummy = l_s_dummy + Mid ( l_s_sqlsyntax, l_l_count, 1 )
			End if
		Next

		dw_inquiry.SetSQLSelect ( l_s_dummy )
	else
		
		l_s_dummy = ""
		
		For l_l_count = 1 to Len ( l_s_sqlsyntax )
			If Mid ( l_s_sqlsyntax, l_l_count, 1 ) <> "~~" Then
				l_s_dummy = l_s_dummy + Mid ( l_s_sqlsyntax, l_l_count, 1 )
			End if
		Next

		dw_inquiry.SetSQLSelect ( l_s_dummy )

	end if
	SetPointer(HourGlass!)
	dw_inquiry.SetTransObject ( sqlca )
	dw_inquiry.Retrieve ( )

end if

end event

event ue_reset;dw_inquiry.DBCancel()
dw_inquiry.Modify ( "DataWindow.Table.Select='" + i_s_original_syntax + "'" )
SetPointer(HourGlass!)
dw_inquiry.SetTransObject ( sqlca )
dw_inquiry.Retrieve ( )
end event

event ue_sort;//
//  If no row exist yet get out
//

If dw_inquiry.RowCount ( ) < 1 Then Return

//
// Declare Variables
//

str_sort stParm

//
// Initialize Varibles
//

stParm.dw = dw_inquiry
stParm.title = "Define Sort Order"

//
// Open Sort Screen
//

OpenWIthParm ( w_sort, stParm )


end event

event ue_open;int		l_i_count

wmainscreen.menuid.dynamic mf_init ( )

i_s_original_syntax = dw_inquiry.Object.DataWindow.Table.Select

SELECT dw_inquiry_files.retrieve_all,
		 dw_inquiry_files.screen_title,
		 dw_inquiry_files.primary_column,
		 dw_inquiry_files.default_operator
  INTO :i_s_retrieve_all,
  		 :i_s_title,
		 :i_s_primary_column,
		 :is_default_operator
  FROM dw_inquiry_files  
 WHERE dw_inquiry_files.screen_title = :Title   ;
 
Title = i_s_title

//For l_i_count = 1 to 50 - Len ( i_s_title )
//	i_s_title += ' '
//next

if f_get_string_value ( i_s_retrieve_all ) = 'Y' then
	SetPointer(HourGlass!)
	dw_inquiry.Retrieve ( )
else
	TriggerEvent ( "ue_filter" )
end if
end event

event ue_cancel;i_b_cancel = TRUE

end event

event ue_activate;wmainscreen.MenuID.Dynamic mf_init ( )
end event

event ue_refresh;SetPointer(HourGlass!)
dw_inquiry.Retrieve ( )
end event

event ue_print;dw_inquiry.Print ( )
end event

event resize;dw_inquiry.width = width - 100
dw_inquiry.height = height - st_1.height - 150
end event

on w_inquiry_ancestor.create
this.st_1=create st_1
this.dw_inquiry=create dw_inquiry
this.Control[]={this.st_1,&
this.dw_inquiry}
end on

on w_inquiry_ancestor.destroy
destroy(this.st_1)
destroy(this.dw_inquiry)
end on

event open;PostEvent ( "ue_open" ) 
end event

type st_1 from statictext within w_inquiry_ancestor
int X=18
int Width=750
int Height=64
boolean Enabled=false
string Text="Total Records = 0"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=77897888
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_inquiry from datawindow within w_inquiry_ancestor
int X=18
int Y=64
int Width=2981
int Height=1344
int TabOrder=1
BorderStyle BorderStyle=StyleLowered!
boolean LiveScroll=true
end type

event constructor;SetTransObject ( sqlca )

end event

event clicked;SelectRow ( 0, FALSE )
if row > 0 then
	SelectRow ( row, TRUE )
end if
end event

event retrieverow;//Parent.Title = i_s_title + "          Total Records = " + String ( RowCount ( ) )
st_1.Text = "Total Records = " + String ( RowCount ( ) )

if i_b_cancel then 
	i_b_cancel = FALSE
	return 1
end if
SetPointer(HourGlass!)
end event

event retrieveend;wMainScreen.MenuID.DYNAMIC mf_cancel ( FALSE )
SetPointer(Arrow!)


end event

event retrievestart;wmainscreen.menuid.dynamic mf_init ( )
wMainScreen.MenuID.DYNAMIC mf_cancel ( TRUE )
//Parent.Title = i_s_title + "          Total Records = 0"
st_1.Text = "Total Records = 0"
end event

event doubleclicked;SetPointer (HourGlass!)
end event

