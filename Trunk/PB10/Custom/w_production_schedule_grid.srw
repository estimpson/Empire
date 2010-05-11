HA$PBExportHeader$w_production_schedule_grid.srw
$PBExportComments$(mps1) Changed the 'ue_partial_update'
forward
global type w_production_schedule_grid from w_schedule_grid_base
end type
type rb_machine7 from radiobutton within w_production_schedule_grid
end type
type rb_machine6 from radiobutton within w_production_schedule_grid
end type
type rb_machine5 from radiobutton within w_production_schedule_grid
end type
type rb_machine4 from radiobutton within w_production_schedule_grid
end type
type rb_machine3 from radiobutton within w_production_schedule_grid
end type
type rb_machine2 from radiobutton within w_production_schedule_grid
end type
type rb_machine1 from radiobutton within w_production_schedule_grid
end type
type gb_machines from groupbox within w_production_schedule_grid
end type
type dw_msp_low_level from datawindow within w_production_schedule_grid
end type
type dw_msp_getmpsparts from datawindow within w_production_schedule_grid
end type
end forward

global type w_production_schedule_grid from w_schedule_grid_base
int Width=4178
int Height=2620
boolean Visible=false
boolean TitleBar=true
string Title="Production Schedule"
long BackColor=79741120
event ue_visual_bom pbm_custom12
event ue_popup_one pbm_custom13
event ue_popup_two pbm_custom14
event ue_popup_three pbm_custom15
event ue_netoutdump ( )
rb_machine7 rb_machine7
rb_machine6 rb_machine6
rb_machine5 rb_machine5
rb_machine4 rb_machine4
rb_machine3 rb_machine3
rb_machine2 rb_machine2
rb_machine1 rb_machine1
gb_machines gb_machines
dw_msp_low_level dw_msp_low_level
dw_msp_getmpsparts dw_msp_getmpsparts
end type
global w_production_schedule_grid w_production_schedule_grid

type variables
STRING	i_s_type = 'M'

Radiobutton	irb_machines [ ]

u_popup                  iuo_popup

end variables

forward prototypes
public subroutine wf_schedule_job (string a_s_machine)
public subroutine wf_display_machines (string a_s_part)
public function datetime wf_end_datetime (string a_s_machine)
public subroutine wf_build_values (string a_s_type)
end prototypes

event ue_visual_bom;IF il_current_row <=0 THEN 
	wmainscreen.SetMicroHelp ( "Click on the part...." )
	wmainscreen.SetMicroHelp ( "Ready" ) 
	RETURN
END IF

IF	uo_crosstab.GetItemString ( il_current_row, 1) > '' THEN
//	OpenWithParm ( w_bom_viewer, uo_crosstab.GetItemString ( il_current_row , 1 ) )
	OpenWithParm ( w_pg_vbom, uo_crosstab.GetItemString ( il_current_row , 1 ) )	
END IF
end event

event ue_popup_one;s_parm_list	lstr_parm

lstr_parm.s_key_value		= is_key
lstr_parm.s_type				= ddlb_mode.text
lstr_parm.s_parm_list[1]	= 'M'	

if isvalid ( iuo_popup ) then closeuserobject ( iuo_popup )

OpenSheetWithParm( w_po_schedule_grid_detail_info, lstr_parm, wmainscreen, 3, Layered! )




	



end event

event ue_popup_two;s_parm_list	lstr_parm

lstr_parm.s_key_value		= is_key
lstr_parm.s_parm_list[1]	= 'M'	
lstr_parm.d_parm_list[1]	= id_date_clicked

if isvalid ( iuo_popup ) then closeuserobject ( iuo_popup )

//OpenSheetWithParm( w_po_schedule_grid_status, lstr_parm, w_main_screen, 3, Layered!)
OpenSheetWithParm( w_po_schedule_grid_status, lstr_parm, wmainscreen, 3, Layered!)


end event

event ue_popup_three;st_generic_structure	lstr_parm

lstr_parm.value1	= is_key
//lstr_parm.value2	= string( id_date_clicked )
lstr_parm.value2	= string( relativedate(id_date_clicked, - 180) )
lstr_parm.value3	= string( relativedate( id_date_clicked, ii_mode ) )

if isvalid ( iuo_popup ) then closeuserobject ( iuo_popup )

//OpenSheetWithParm ( w_detail_info_for_prod_grid, lstr_parm , w_main_screen, 3, Layered!) 
OpenSheetWithParm ( w_detail_info_for_prod_grid, lstr_parm , wmainscreen, 3, Layered!) 


end event

event ue_netoutdump;// Below code is to dump the netted out data to a table
long	ll_row, ll_lastrow, ll_lastrows, ll_usertype
string	ls_data, ls_mode, ls_usertype
datastore	lds_netout

ll_lastrows =  uo_crosstab.rowcount()

Select	count(*)
into	:ll_row 
from	netoutdump;

if ll_row > 0 then 
	if messagebox (Monsys.msg_title, "Previously dumped data will be erased, do you want to continue", Question!, YesNo!, 2) = 2 then
		return
	end if 
end if 	

// Delete the contents of the table before the new data is written
delete from netoutdump;
if sqlca.sqlcode <> 0 then 
	rollback;
	messagebox ( Monsys.msg_title, "Unable to delete previously dumped netted out data")
	return
else
	commit;
end if 	

ll_usertype= messagebox (Monsys.msg_title, "Please specify, do you want Finished(Yes) or Wip(No) parts do be dumped to the table", Question!, YesNoCancel!, 1)

if ll_usertype = 3 then	return 

ls_usertype = 'F'
if ll_usertype = 2 then	ls_usertype = 'W'

// Instantiate the datastore
lds_netout = create datastore
lds_netout.dataobject = 'd_netoutdump'
lds_netout.settransobject(sqlca)

// Check the mode
if ii_mode=1 then 
	ls_mode = 'Daily'
else
	ls_mode = 'Weekly'
end if 	

SetPointer(HourGlass!)

// Inser the actual netted out values
for ll_row = 1 to ll_lastrows

	if uo_crosstab.object.part_type[ll_row] = ls_usertype then 
		if lds_netout.find("part_value = '" + uo_crosstab.object.part[ll_row] + "'" , 1, lds_netout.rowcount()) = 0 then 
			ll_lastrow = lds_netout.insertrow(0)		
			lds_netout.setitem(ll_lastrow, 'part_value', uo_crosstab.object.part[ll_row])
			lds_netout.setitem(ll_lastrow, 'past', isnull(uo_crosstab.object.past[ll_row],0))
			lds_netout.setitem(ll_lastrow, 'value1', isnull(uo_crosstab.object.value1[ll_row],0))		
			lds_netout.setitem(ll_lastrow, 'value2', isnull(uo_crosstab.object.value2[ll_row],0))			
			lds_netout.setitem(ll_lastrow, 'value3', isnull(uo_crosstab.object.value3[ll_row],0))			
			lds_netout.setitem(ll_lastrow, 'value4', isnull(uo_crosstab.object.value4[ll_row],0))	
			lds_netout.setitem(ll_lastrow, 'value5', isnull(uo_crosstab.object.value5[ll_row],0))		
			lds_netout.setitem(ll_lastrow, 'value6', isnull(uo_crosstab.object.value6[ll_row],0))			
			lds_netout.setitem(ll_lastrow, 'value7', isnull(uo_crosstab.object.value7[ll_row],0))			
			lds_netout.setitem(ll_lastrow, 'value8', isnull(uo_crosstab.object.value8[ll_row],0))	
			lds_netout.setitem(ll_lastrow, 'value9', isnull(uo_crosstab.object.value9[ll_row],0))		
			lds_netout.setitem(ll_lastrow, 'value10', isnull(uo_crosstab.object.value10[ll_row],0))			
			lds_netout.setitem(ll_lastrow, 'value11', isnull(uo_crosstab.object.value11[ll_row],0))			
			lds_netout.setitem(ll_lastrow, 'value12', isnull(uo_crosstab.object.value12[ll_row],0))	
			lds_netout.setitem(ll_lastrow, 'value13', isnull(uo_crosstab.object.value13[ll_row],0))		
			lds_netout.setitem(ll_lastrow, 'value14', isnull(uo_crosstab.object.value14[ll_row],0))
			lds_netout.setitem(ll_lastrow, 'value15', isnull(uo_crosstab.object.value15[ll_row],0))			
			lds_netout.setitem(ll_lastrow, 'value16', isnull(uo_crosstab.object.value16[ll_row],0))			
			lds_netout.setitem(ll_lastrow, 'value17', isnull(uo_crosstab.object.value17[ll_row],0))	
			lds_netout.setitem(ll_lastrow, 'value18', isnull(uo_crosstab.object.value18[ll_row],0))		
			lds_netout.setitem(ll_lastrow, 'value19', isnull(uo_crosstab.object.value19[ll_row],0))
			lds_netout.setitem(ll_lastrow, 'value20', isnull(uo_crosstab.object.value20[ll_row],0))
			lds_netout.setitem(ll_lastrow, 'future', isnull(uo_crosstab.object.future[ll_row],0))			
		end if 	
	end if 
next	

// update the table
if lds_netout.update() >= 0 then 		
	commit;
	Messagebox (Monsys.msg_title, "The netted out information dumped to the (table 'Netoutdump') successfully")
else	
	Rollback;
	Messagebox (Monsys.msg_title, "The netted out information could not be saved")
end if
destroy lds_netout

SetPointer(Arrow!)	
end event
public subroutine wf_schedule_job (string a_s_machine);s_parm_list	lstr_parm

// was commented out on 5/25/99, I don't remember why it was included 1st place
//Decimal l_d_onhand
//SELECT on_hand 
//  INTO :l_d_onhand
//  FROM part_online
// WHERE part_online.part = :is_key ;
//IF l_d_onhand < ic_qty_clicked THEN
//	Messagebox('Warning!','Onhand quantity '+string(l_d_onhand,'0')+' is less than the demand quantity '+string(ic_qty_clicked,'0'))
//END IF

/* Initialization */
lstr_parm.s_key_value		=	is_key
lstr_parm.s_parm_list[1]	= 	a_s_machine

SELECT 	part_mfg.process_id  
INTO 		:lstr_parm.s_parm_list[2]  
FROM 		part_mfg  
WHERE 	part_mfg.part = :is_key   ;

lstr_parm.c_parm_list[1]	=	wf_calculate_qty ( )
lstr_parm.d_parm_list[1]	=	id_start_date 

CHOOSE CASE is_current_col 

	CASE  'past'
		lstr_parm.d_parm_list[2]	= 	id_date_clicked 

	CASE 'future'
		lstr_parm.d_parm_list[2]	= 	relativedate ( id_date_clicked, 365 )

	CASE ELSE
		IF ii_mode > 1 THEN
			lstr_parm.d_parm_list[2]	= 	Relativedate ( id_date_clicked, ii_mode - 1 )
		ELSE
			lstr_parm.d_parm_list[2]	= 	Relativedate ( id_date_clicked, ii_mode  )
		END IF

END CHOOSE

/* Main Process */

Openwithparm( w_prod_grid_job_creator, lstr_parm )

w_prod_grid_job_creator.iw_parent	= this
end subroutine

public subroutine wf_display_machines (string a_s_part);INTEGER	li_total, &
			li_ptr, &
			li_sequence, &
			li_earliest_ptr

STRING	ls_machine

BOOLEAN	lb_found_earliest

DATETIME	ldt_earliest, &
			ldt_machine_datetime

//DECLARE curMachines CURSOR FOR  
// SELECT part_machine.machine,   
//        part_machine.sequence  
//   FROM part_machine  
//  WHERE ( part_machine.part = :a_s_part ) AND  
//        ( part_machine.machine > ' ' )   
//ORDER BY  part_machine.sequence ASC  ;
//

// Modified the select to get data from a view instead of the base table itself 6/20/00
DECLARE curMachines CURSOR FOR  
SELECT	machine,   
			sequence  
FROM		mvw_machinelist 
WHERE		( part = :a_s_part )
ORDER BY sequence ASC  ;

/* Initialization */

li_total	= upperbound( irb_machines )

gb_machines.visible = FALSE

for li_ptr = 1 to li_total
	irb_machines[ li_ptr ].visible	= FALSE
	irb_machines[ li_ptr ].textcolor	= 0
next

li_ptr	= 0

/* Main Process */

OPEN curMachines;

FETCH curMachines  INTO :ls_machine, :li_sequence;

gb_machines.visible = TRUE

DO WHILE SQLCA.SQLCode = 0

	li_ptr ++
	irb_machines[ li_ptr ].text		= ls_machine
	irb_machines[ li_ptr ].visible	= TRUE

	FETCH curMachines  INTO :ls_machine, :li_sequence;

LOOP

CLOSE curMachines;

li_total	= upperbound( irb_machines )
li_ptr	= 1
lb_found_earliest = FALSE
setnull( ldt_earliest )

do while (li_ptr <= li_total ) AND ( not lb_found_earliest )
	if irb_machines[li_ptr].text > ' ' then
		ldt_machine_datetime	= wf_end_datetime( irb_machines[ li_ptr ].text )
		if isNull(ldt_machine_datetime) then	//No schedule for the machine
			lb_found_earliest	= TRUE
			li_earliest_ptr	= li_ptr
		else
			if isNull( ldt_earliest ) then
				ldt_earliest		= ldt_machine_datetime
				li_earliest_ptr	= li_ptr
			else 
				if (ldt_machine_datetime <= ldt_earliest ) then
					li_earliest_ptr	= li_ptr
				end if
			end if
		end if
	end if

	li_ptr ++

loop

if li_earliest_ptr > 0 then
	irb_machines[ li_earliest_ptr ].textcolor	= 65280	//Set color GREEN
end if
end subroutine

public function datetime wf_end_datetime (string a_s_machine);/* Declaration */
DATE		ld_date
TIME		lt_time
DATETIME ldt_enddatetime, ldt_date, ldt_time

DECLARE curEndDateTime CURSOR FOR  
 SELECT 	end_date,   
         end_time  
   FROM 	work_order  
  WHERE 	machine_no = :a_s_machine   
ORDER BY end_date DESC,   
         end_time DESC  ;

/* Main Process */

OPEN curEndDateTime;

FETCH curEndDateTime INTO :ldt_date, :ldt_time;

ld_date = date(ldt_date)
lt_time = time(ldt_time)

IF SQLCA.SQLCode = 0 THEN
	ldt_enddatetime	= datetime(  ld_date, lt_time )
ELSE
	setnull( ldt_enddatetime )
END IF

CLOSE curEndDateTime;

RETURN ldt_enddatetime
end function

public subroutine wf_build_values (string a_s_type);datawindowchild l_dwc

dw_value.Reset ()

CHOOSE CASE a_s_type

	CASE 'Product Line'
		dw_value.modify ( "data.dddw.name='d_dddw_product_lines'" )
		dw_value.modify ( "data.dddw.displaycolumn='id'" )
		dw_value.modify ( "data.dddw.datacolumn='id'" )

	CASE 'Activity'
		dw_value.modify ( "data.dddw.name='d_dddw_activity_codes'" )
		dw_value.modify ( "data.dddw.displaycolumn='code'" )
		dw_value.modify ( "data.dddw.datacolumn='code'" )
		
	CASE 'Sales Order'
		dw_value.modify ( "data.dddw.name='d_dddw_sales_order'" )
		dw_value.modify ( "data.dddw.displaycolumn='order_no'" )
		dw_value.modify ( "data.dddw.datacolumn='order_no'" )

	CASE 'Plant'
		dw_value.modify ( "data.dddw.name='d_dddw_plants'" )
		dw_value.modify ( "data.dddw.displaycolumn='destination'" )
		dw_value.modify ( "data.dddw.datacolumn='destination'" )
		
	CASE 'Group Technology'
		dw_value.modify ( "data.dddw.name='d_dddw_group_technology'" )
		dw_value.modify ( "data.dddw.displaycolumn='id'" )
		dw_value.modify ( "data.dddw.datacolumn='id'" )

	CASE 'Flow Router'
		dw_value.modify ( "data.dddw.name='d_dddw_parts'" )
		dw_value.modify ( "data.dddw.displaycolumn='part'" )
		dw_value.modify ( "data.dddw.datacolumn='part'" )

	CASE 'Machine'
		dw_value.modify ( "data.dddw.name='d_dddw_location'" )
		dw_value.modify ( "data.dddw.displaycolumn='name'" )
		dw_value.modify ( "data.dddw.datacolumn='code'" )
		
END CHOOSE

dw_value.insertrow(1)
dw_value.getchild ( "data" , l_dwc )

l_dwc.settransobject (sqlca)
l_dwc.retrieve ()

l_dwc.InsertRow ( 1 )

IF a_s_type <> 'Sales Order' THEN

	l_dwc.SetItem  ( 1, 1, 'All' )
	l_dwc.SetItem  ( 1, 2, 'All' )

ELSE 
	
	l_dwc.Setitem ( 1 , 1, ' ' )
	l_dwc.Setitem ( 1 , 2, ' ' )
	l_dwc.Setitem ( 1 , 3, ' ' )	
	
END IF

l_dwc.selectrow ( 0, false )
end subroutine

event ue_clicked_key_column;DECIMAL	lc_demand[]

INTEGER	li_col, &
			li_ptr

STRING	ls_date_list[], &
			ls_check 

s_parm_list lstr_parm

DATE	  ld_date

li_ptr	= 1

IF il_current_row > 0 THEN

	FOR li_ptr = 1 to 14
		ls_check = "total_qty_req_"+string ( li_ptr )
		lc_demand[li_ptr] = uo_crosstab.Getitemdecimal( il_current_row, ls_check ) //( uo_crosstab.demand_offset + li_ptr ) - 1 ) 
	NEXT

	ld_date = id_start_date

	FOR li_ptr = 1 to 7
		ls_date_list[ li_ptr ]	= string ( ld_date )
		ld_date = relativedate ( ld_date , ii_mode )
	NEXT

	lstr_parm.s_key_value	=	is_key
	lstr_parm.s_parm_list	= 	ls_date_list
	lstr_parm.c_parm_list	= 	lc_demand

	opensheetwithparm( w_netout_prod_grid, lstr_parm, wmainscreen, 3, Layered! )

end if
end event

on ue_display;call w_schedule_grid_base::ue_display;wf_display_machines ( is_key )
end on

event activate;IF wmainscreen.MenuName <> 'm_production_grid' THEN &
	wmainscreen.ChangeMenu(m_production_grid)
end event

event ue_build_crosstab;call super::ue_build_crosstab;/* 02-24-2000 KAZ Modified to return if the 'cancel' boolean is set to true, causing the
						event to exit directly, avoiding a watchdog error message.  Issue # 13223 */

if bcancel then return																								// ADD 02/24/2000 KAZ

if uo_crosstab.Rowcount() > 0 then
	m_production_grid.m_file.m_netout.Enabled = TRUE
	m_production_grid.m_file.m_datadump.Enabled = False	
else
	m_production_grid.m_file.m_netout.Enabled = FALSE
	m_production_grid.m_file.m_datadump.Enabled = TRUE	
end if 

end event

event ue_netout;call super::ue_netout;m_production_grid.m_file.m_netout.Enabled = FALSE
m_production_grid.m_file.m_datadump.Enabled = True

end event

on w_production_schedule_grid.create
int iCurrent
call super::create
this.rb_machine7=create rb_machine7
this.rb_machine6=create rb_machine6
this.rb_machine5=create rb_machine5
this.rb_machine4=create rb_machine4
this.rb_machine3=create rb_machine3
this.rb_machine2=create rb_machine2
this.rb_machine1=create rb_machine1
this.gb_machines=create gb_machines
this.dw_msp_low_level=create dw_msp_low_level
this.dw_msp_getmpsparts=create dw_msp_getmpsparts
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_machine7
this.Control[iCurrent+2]=this.rb_machine6
this.Control[iCurrent+3]=this.rb_machine5
this.Control[iCurrent+4]=this.rb_machine4
this.Control[iCurrent+5]=this.rb_machine3
this.Control[iCurrent+6]=this.rb_machine2
this.Control[iCurrent+7]=this.rb_machine1
this.Control[iCurrent+8]=this.gb_machines
this.Control[iCurrent+9]=this.dw_msp_low_level
this.Control[iCurrent+10]=this.dw_msp_getmpsparts
end on

on w_production_schedule_grid.destroy
call super::destroy
destroy(this.rb_machine7)
destroy(this.rb_machine6)
destroy(this.rb_machine5)
destroy(this.rb_machine4)
destroy(this.rb_machine3)
destroy(this.rb_machine2)
destroy(this.rb_machine1)
destroy(this.gb_machines)
destroy(this.dw_msp_low_level)
destroy(this.dw_msp_getmpsparts)
end on

on resize;call w_schedule_grid_base::resize;IF IsValid ( uo_crosstab ) THEN
	gb_machines.X = uo_crosstab.X
	gb_machines.Y = uo_crosstab.height + 230
	rb_machine1.Y = gb_machines.Y + 75
	rb_machine2.Y = rb_machine1.Y
	rb_machine3.Y = rb_machine2.Y
	rb_machine4.Y = rb_machine3.Y
	rb_machine5.Y = rb_machine4.Y
	rb_machine6.Y = rb_machine5.Y
	rb_machine7.Y = rb_machine6.Y
	rb_machine1.X = gb_machines.X + 30
	rb_machine2.X = rb_machine1.X + 400
	rb_machine3.X = rb_machine2.X + 400
	rb_machine4.X = rb_machine3.X + 400
	rb_machine5.X = rb_machine4.X + 400
	rb_machine6.X = rb_machine5.X + 400
	rb_machine7.X = rb_machine6.X + 400
END IF
end on

on ue_open;call w_schedule_grid_base::ue_open;irb_machines [1] =	rb_machine1 
irb_machines [2] =	rb_machine2
irb_machines [3] =	rb_machine3
irb_machines [4] =	rb_machine5
irb_machines [5] =	rb_machine4
irb_machines [6] =	rb_machine5
irb_machines [7] =	rb_machine6
irb_machines [8] =	rb_machine7
end on

event ue_double_clicked;call super::ue_double_clicked;IF isvalid ( iuo_popup ) THEN 
	IF iuo_popup.finditem ( '      Detail Status Screen', 1 ) <= 0 THEN
   	iuo_popup.Additem ( '      Detail Status Screen' )
	END IF
	iuo_popup.height = 260
	iuo_popup.bringtotop = TRUE
END IF
end event

type ddlb_type from w_schedule_grid_base`ddlb_type within w_production_schedule_grid
long BackColor=1090519039
string Item[]={"All parts",&
"Product Line",&
"Finished Part",&
"Activity",&
"Sales Order",&
"Plant",&
"Group Technology",&
"Flow Router",&
"Machine"}
end type

event selectionchanged;STRING l_s_type

l_s_type = ddlb_type.Text

CHOOSE CASE l_s_type

	CASE 'All parts'
		dw_value.Visible = FALSE
		uo_crosstab.SetFilter ( "TYPE='M'" )
		uo_crosstab.Filter ( )

	CASE 'Finished Part'
		dw_value.Visible = FALSE
		uo_crosstab.SetFilter ( "PART_TYPE='F' AND TYPE='M'" )
		uo_crosstab.Filter ( )

	CASE ELSE
		dw_value.Visible = TRUE
		wf_build_values ( text )

END CHOOSE
end event

type ddlb_mode from w_schedule_grid_base`ddlb_mode within w_production_schedule_grid
long BackColor=1090519039
end type

event dw_value::itemchanged;long	ll_row
long	ll_totalrows

STRING	l_s_type
String	ls_parts


l_s_type = ddlb_type.Text

IF data = 'All' or data = ' ' or isnull ( data ) THEN
	
	uo_crosstab.SetFilter ( "TYPE='M'" )
	uo_crosstab.Filter ( ) 
	
ELSE		

	CHOOSE CASE l_s_type
	
		CASE 'Product Line'
			uo_crosstab.SetFilter ( "product_line='"+data+"' AND TYPE='M'")
			uo_crosstab.Filter ( ) 
		CASE 'Activity'
			uo_crosstab.SetFilter ( "activity='"+data+"' AND TYPE='M'" )
			uo_crosstab.Filter ( ) 
		CASE 'Sales Order'
			uo_crosstab.SetFilter ( "origin="+string(data)+" AND TYPE='M'" )
			uo_crosstab.Filter ( ) 
		CASE 'Plant'
			uo_crosstab.SetFilter ( "plant='"+data+"' AND TYPE='M'" )
			uo_crosstab.Filter ( ) 
		CASE 'Group Technology'
			uo_crosstab.SetFilter ( "group_technology='"+data+"' AND TYPE='M'" )
			uo_crosstab.Filter ( ) 
		CASE 'Flow Router'
			dw_msp_low_level.retrieve ( data ) 
			ll_TotalRows = dw_msp_low_level.rowcount ()
			if ll_TotalRows > 0 then 
				ls_parts = '( '
				for ll_Row = 1 to ll_TotalRows
					ls_parts += "'" + dw_msp_low_level.object.part [ ll_Row ] +"'"
					if ll_Row < ll_TotalRows then ls_Parts += ", "
				next
				ls_parts += ' )'
				uo_crosstab.SetFilter ( "part in "+ ls_Parts +" AND TYPE='M'" )
				uo_crosstab.Filter ( ) 
			end if 	
		CASE 'Machine'
			dw_msp_getmpsparts.retrieve ( data ) 
			ll_TotalRows = dw_msp_getmpsparts.rowcount ()
			if ll_TotalRows > 0 then 
				ls_parts = '( '
				for ll_Row = 1 to ll_TotalRows
					ls_parts += "'" + dw_msp_getmpsparts.object.part [ ll_Row ] +"'"
					if ll_Row < ll_TotalRows then ls_Parts += ", "
				next
				ls_parts += ' )'
				uo_crosstab.SetFilter ( "part in "+ ls_Parts +" AND TYPE='M'" )
				uo_crosstab.Filter ( ) 
			end if 	
			
	END CHOOSE
	
END IF

uo_crosstab.groupcalc()
end event

type rb_machine7 from radiobutton within w_production_schedule_grid
int X=2414
int Y=976
int Width=439
int Height=76
boolean Visible=false
string Text="Machine7"
long BackColor=77897888
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on dragdrop;wf_schedule_job ( this.text )
end on

type rb_machine6 from radiobutton within w_production_schedule_grid
int X=2021
int Y=976
int Width=439
int Height=76
boolean Visible=false
string Text="Machine6"
long BackColor=77897888
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on dragdrop;wf_schedule_job ( this.text )
end on

type rb_machine5 from radiobutton within w_production_schedule_grid
int X=1600
int Y=980
int Width=439
int Height=76
boolean Visible=false
string Text="Machine5"
long BackColor=77897888
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on dragdrop;wf_schedule_job ( this.text )
end on

type rb_machine4 from radiobutton within w_production_schedule_grid
int X=1202
int Y=976
int Width=439
int Height=76
boolean Visible=false
string Text="Machine4"
long BackColor=77897888
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on dragdrop;wf_schedule_job ( this.text )
end on

type rb_machine3 from radiobutton within w_production_schedule_grid
int X=827
int Y=976
int Width=439
int Height=76
boolean Visible=false
string Text="Machine3"
long BackColor=77897888
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on dragdrop;wf_schedule_job ( this.text )
end on

type rb_machine2 from radiobutton within w_production_schedule_grid
int X=453
int Y=976
int Width=439
int Height=76
boolean Visible=false
string Text="Machine2"
long BackColor=77897888
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on dragdrop;wf_schedule_job ( this.text )
end on

type rb_machine1 from radiobutton within w_production_schedule_grid
int X=46
int Y=976
int Width=425
int Height=76
boolean Visible=false
string Text="Machine1"
long BackColor=77897888
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on dragdrop;wf_schedule_job ( this.text )
end on

type gb_machines from groupbox within w_production_schedule_grid
int X=14
int Y=900
int Width=2853
int Height=180
int TabOrder=40
boolean Visible=false
string Text="Available Machines"
long BackColor=77897888
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_msp_low_level from datawindow within w_production_schedule_grid
int X=32
int Y=1156
int Width=302
int Height=212
int TabOrder=50
boolean Visible=false
boolean BringToTop=true
string DataObject="d_msp_low_level"
BorderStyle BorderStyle=StyleLowered!
boolean LiveScroll=true
end type

event constructor;settransobject ( sqlca ) 
end event

type dw_msp_getmpsparts from datawindow within w_production_schedule_grid
int X=366
int Y=1152
int Width=311
int Height=220
int TabOrder=60
boolean Visible=false
boolean BringToTop=true
string DataObject="d_msp_getmpsparts"
BorderStyle BorderStyle=StyleLowered!
boolean LiveScroll=true
end type

event constructor;settransobject ( sqlca ) 
end event

