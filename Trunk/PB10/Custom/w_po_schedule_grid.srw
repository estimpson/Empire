HA$PBExportHeader$w_po_schedule_grid.srw
$PBExportComments$(mrs) PO schedule grid
forward
global type w_po_schedule_grid from w_schedule_grid_base
end type
type uo_vendor6 from u_vendor_display within w_po_schedule_grid
end type
type uo_vendor5 from u_vendor_display within w_po_schedule_grid
end type
type uo_vendor4 from u_vendor_display within w_po_schedule_grid
end type
type uo_vendor3 from u_vendor_display within w_po_schedule_grid
end type
type uo_vendor2 from u_vendor_display within w_po_schedule_grid
end type
type uo_vendor1 from u_vendor_display within w_po_schedule_grid
end type
type gb_vendors from groupbox within w_po_schedule_grid
end type
type dw_ar_exception from datawindow within w_po_schedule_grid
end type
end forward

global type w_po_schedule_grid from w_schedule_grid_base
boolean TitleBar=true
string Title="PO Schedule"
event ue_dragdrop_to_vendor pbm_custom12
event ue_popup_one pbm_custom13
event ue_popup_two pbm_custom14
event ue_netoutdump ( )
event ue_autoreleases ( )
uo_vendor6 uo_vendor6
uo_vendor5 uo_vendor5
uo_vendor4 uo_vendor4
uo_vendor3 uo_vendor3
uo_vendor2 uo_vendor2
uo_vendor1 uo_vendor1
gb_vendors gb_vendors
dw_ar_exception dw_ar_exception
end type
global w_po_schedule_grid w_po_schedule_grid

type variables
BOOLEAN	ib_830_mode

INTEGER		ii_vendor_count = 6

STRING	i_s_type = 'P'

u_vendor_display	iuo_vendor_list [ ]
u_popup                  iuo_popup

end variables

forward prototypes
public subroutine wf_schedule_job ()
public subroutine wf_display_vendors (string as_part)
public subroutine wf_initialize_vendors ()
public subroutine wf_dragdrop_to_vendor (string a_s_vendor)
public function string wf_filter_vendor (string a_s_vendor)
public subroutine wf_build_values (string a_s_type)
end prototypes

event ue_dragdrop_to_vendor;long	ll_ptr
st_generic_structure lstr_parm
	
String l_s_nonorder_status, &
		 l_s_note
		 
ll_ptr	= message.longparm

IF ll_ptr >= 1 AND ll_ptr <= ii_vendor_count THEN
	
	// MB  2/11/04 check non order status for part and prevent creation of po releases
	l_s_note = f_get_part_no_status ( is_key )
	l_s_nonorder_status = Left ( l_s_note, 1 )

	if l_s_nonorder_status = 'Y' then 
		l_s_note = Mid ( l_s_note, 3,  len ( l_s_note ) - 2 )
		messagebox ( monsys.msg_title, 'Unable to add release for this part. ' + l_s_note )
		return 
	end if
	
	
	IF iuo_vendor_list[ ll_ptr ].st_vendor_code.text = 'ADD VENDOR PROFILE' THEN
			setnull ( lstr_parm.value1 )
			lstr_parm.value2 = is_key
			OpenSheetWithParm (w_smart_price_matrix,  lstr_parm, wMainScreen, 3, Layered!)
	ELSE	
			wf_dragdrop_to_vendor( iuo_vendor_list[ ll_ptr ].st_vendor_code.text )
	END IF
END IF
end event

event ue_popup_one;s_parm_list	lstr_parm

lstr_parm.s_key_value		= is_key
lstr_parm.s_type				= ddlb_mode.text
lstr_parm.s_parm_list[1]	= 'P'	

if isvalid ( iuo_popup ) then closeuserobject ( iuo_popup )

OpenSheetWithParm( w_po_schedule_grid_detail_info, lstr_parm, wmainscreen, 3, Layered! )






	



end event

event ue_popup_two;s_parm_list	lstr_parm

st_generic_structure  l_st_parm

date		ld_start_date, &
			ld_end_date, &
			ld_date

CHOOSE CASE is_current_col

	CASE 'past'
		ld_start_date	=	relativedate ( id_date_clicked, -7 ) 
		ld_end_date		=  id_date_clicked 

	CASE 'future'
		ld_start_date	=	id_date_clicked
		ld_end_date		=  relativedate ( id_date_clicked, 365 )

	CASE ELSE
		ld_start_date	=  id_date_clicked 
		ld_end_date		=  relativedate( id_date_clicked, ii_mode ) 

END CHOOSE

lstr_parm.s_key_value		= uo_crosstab.Getitemstring ( il_current_row, 1 )
lstr_parm.s_parm_list[1]	= 'P'	
lstr_parm.d_parm_list[1]	= ld_start_date

if isvalid ( iuo_popup ) then closeuserobject ( iuo_popup )

OpenSheetWithParm( w_po_schedule_grid_status, lstr_parm, wmainscreen, 3, Layered! )


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

ll_usertype= messagebox (Monsys.msg_title, "Please specify, do you want Finished(Yes) or Raw(No) parts do be dumped to the table", Question!, YesNoCancel!, 1)

if ll_usertype = 3 then	return 

ls_usertype = 'F'
if ll_usertype = 2 then	ls_usertype = 'R'

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

event ue_autoreleases;//	Declarations
boolean	lb_continue=false
long	ll_totalrows, ll_row, ll_ponumber, ll_rowid, ll_insrow
int	li_weekstofreeze, li_rowid, li_weekno, li_index, li_shipday, li_curdate, li_diff
datetime ldt_freezedate, ldt_duedate
date	ldt_ary[]
string	ls_prevpart, ls_part, ls_vendor, ls_partname, ls_um
dec	ld_quantity, ld_price, ld_partqtyary[], ld_partqtytmp[], ld_pastdue 
dec	ld_tmpqty, ld_qtytmp, ld_holdqty, ld_stdpack, ld_boxes
string	ls_vcode, ls_status, ls_type, ls_shipto, ls_terms, ls_plant, ls_shipvia, l_s_nonorder_Status, l_s_note
string	ls_roundopt

//	Initialize
ls_prevpart = ''
li_weekstofreeze=0

dw_ar_exception.reset()
//	Get rowcount
ll_totalrows = uo_crosstab.rowcount()
if ll_totalrows > 0 then 
	ldt_ary[1] = id_start_date	
	ldt_ary[2] = id_start_date	
	for li_index = 3 to 16	
		if ii_mode = 1 then // Daily
			ldt_ary[li_index] = relativedate(id_start_date, (li_index - 2))
		else
			ldt_ary[li_index] = relativedate(id_start_date, ((li_index - 2)*7))
		end if 
	next 
	//	Process all parts
	for ll_row = 1 to ll_totalrows
		if (ls_prevpart <> uo_crosstab.object.part[ll_row]) then 
			ls_prevpart = uo_crosstab.object.part[ll_row]
			ll_ponumber = uo_crosstab.object.default_po_number[ll_row]
			
			//	Check if auto_releases is enabled or not
			if isnull(uo_crosstab.object.auto_releases[ll_row],'N') = 'Y' then 
				li_weekstofreeze = isnull(uo_crosstab.object.weeks_to_freeze[ll_row],0)
				ldt_freezedate = datetime(relativedate(today(), li_weekstofreeze * 7), time('00:00:00'))
				lb_continue = true
				if not isnull(ldt_freezedate) then 
					//	Delete all po detail history and po detail for due dates greater than freeze date
					delete	po_detail_history 
					where	po_number = :ll_ponumber and
						part_number = :ls_prevpart and 
						date_due >= :ldt_freezedate;
					delete	po_detail 
					where	po_number = :ll_ponumber and
						part_number = :ls_prevpart and 
						date_due >= :ldt_freezedate;
					
					//	commit the transcations
					if sqlca.sqlcode = 0 then
						commit;
					else
						rollback;
					end if 	
				end if 	
				
			end if 
		end if 	
	next

	//	If any records were deleted, run cop, re-build grid, netout the data
	if lb_continue then
		setpointer ( Hourglass! ) 
		DECLARE super_cop_wc PROCEDURE FOR msp_super_cop 'Y', null, null
		USING sqlca;
		sqlca.autocommit = TRUE
		
		//	Run supercop
		execute super_cop_wc;
		sqlca.autocommit = FALSE
		close super_cop_wc;

		commit;
		
		yield()
		
		//	re-build crosstab
		triggerevent('ue_build_crosstab')

		yield()
		
		//	netout data
		triggerevent ( 'ue_netout' )

		//	Insert releases on auto release parts
		ls_prevpart = ''
		dw_ar_exception.reset()		
		//	Process all parts
		for ll_row = 1 to ll_totalrows
			if (ls_prevpart <> uo_crosstab.object.part[ll_row]) then 
				ls_prevpart = uo_crosstab.object.part[ll_row]
				ld_partqtyary = ld_partqtytmp
				ld_pastdue = 0 
				
				//	Check if auto_releases is enabled or not
				if isnull(uo_crosstab.object.auto_releases[ll_row],'N') = 'Y' then 
					ld_partqtyary[1] = uo_crosstab.object.past[ll_row]					
					ld_partqtyary[2] = uo_crosstab.object.value1[ll_row]
					ld_partqtyary[3] = uo_crosstab.object.value2[ll_row]					
					ld_partqtyary[4] = uo_crosstab.object.value3[ll_row]
					ld_partqtyary[5] = uo_crosstab.object.value4[ll_row]					
					ld_partqtyary[6] = uo_crosstab.object.value5[ll_row]
					ld_partqtyary[7] = uo_crosstab.object.value6[ll_row]					
					ld_partqtyary[8] = uo_crosstab.object.value7[ll_row]
					ld_partqtyary[9] = uo_crosstab.object.value8[ll_row]					
					ld_partqtyary[10] = uo_crosstab.object.value9[ll_row]
					ld_partqtyary[11] = uo_crosstab.object.value10[ll_row]					
					ld_partqtyary[12] = uo_crosstab.object.value11[ll_row]
					ld_partqtyary[13] = uo_crosstab.object.value12[ll_row]					
					ld_partqtyary[14] = uo_crosstab.object.value13[ll_row]
					ld_partqtyary[15] = uo_crosstab.object.value14[ll_row]					
//					ld_partqtyary[16] = uo_crosstab.object.value15[ll_row]
//					ld_partqtyary[17] = uo_crosstab.object.value16[ll_row]					
//					ld_partqtyary[18] = uo_crosstab.object.value17[ll_row]
//					ld_partqtyary[19] = uo_crosstab.object.value18[ll_row]					
//					ld_partqtyary[20] = uo_crosstab.object.value19[ll_row]
//					ld_partqtyary[21] = uo_crosstab.object.value20[ll_row]					
//					
					//	Get data into variables
					ls_part = ls_prevpart
					ll_ponumber = uo_crosstab.object.default_po_number[ll_row]
					ls_vendor = uo_crosstab.object.default_vendor[ll_row]
					l_s_note = f_get_part_no_status ( ls_part )
					l_s_nonorder_status = Left ( l_s_note, 1 )
					l_s_note = Mid ( l_s_note, 3, len ( l_s_note ) - 2 )

					if l_s_nonorder_status = 'Y' then 

						//	Get po header details
						select	vendor_code, status, type, ship_to_destination, terms, plant, ship_via, 
							convert(integer,custom4)
						into	:ls_vcode, :ls_status, :ls_type, :ls_shipto, :ls_terms, :ls_plant, :ls_shipvia,
							:li_shipday
						from	po_header
							join vendor_custom vc on vc.code = po_header.vendor_code
						where	po_number = :ll_ponumber;
	
						//	Get part details
						select	name,
							standard_unit,
							standard_pack,
							isnull(pec.generate_mr,'S')
						into	:ls_partname,
							:ls_um,
							:ld_stdpack,
							:ls_roundopt
						from	part
							join part_inventory pi on pi.part = part.part
							left outer join part_eecustom pec on pec.part = part.part
						where	part.part = :ls_part;
	
						//	Get next row id #
						select	isnull(Max(row_id),0)
						into	:li_rowid
						from 	po_detail
						where	po_number = :ll_ponumber;
	
						for li_index = 1 to 15
							if ld_partqtyary[li_index] > 0 then 
								ll_rowid = 0 
								ldt_duedate = Datetime(ldt_ary[li_index])
								li_weekno = f_get_week_no ( date (ldt_duedate) )
								ld_quantity = ld_partqtyary[li_index]
								li_curdate = daynumber(ldt_ary[li_index])
								li_diff = li_shipday - li_curdate
								ldt_duedate = datetime(relativedate(ldt_ary[li_index], li_diff))
								//	Get price
								select	price 
								into	:ld_price
								from	part_vendor_price_matrix 
								where	part = :ls_part and 
									vendor = :ls_vcode and
									break_qty = (select	max(break_qty) 
											from	part_vendor_price_matrix 
											where	vendor = :ls_vcode and 
												part = :ls_part and 
												break_qty <= :ld_quantity) ;
												
								select	row_id, quantity, balance
								into	:ll_rowid, :ld_tmpqty, :ld_qtytmp
								from	po_detail
								where	po_number = :ll_ponumber and
									part_number = :ls_part and 
									date(date_due) = date(:ldt_duedate);
									
								ld_boxes = mod (ld_quantity, ld_stdpack)
								if ld_boxes < (ld_stdpack / 2) then
									ld_quantity = (ld_quantity - ld_boxes)
								else
									ld_quantity = ((ld_quantity - ld_boxes) + ld_stdpack)
								end if 	
								if isnull(ls_roundopt,'S') = 'D' then 
									ld_quantity = ld_quantity - (ld_quantity - int(ld_quantity))
								elseif isnull(ls_roundopt,'S') = 'U' then 
									ld_quantity = ceiling ( ld_quantity)
								end if 	

								if isnull(ll_rowid,0) <= 0 then 
									li_rowid ++								
									//	Insert data into po detail
									insert into po_detail
										(po_number, vendor_code, part_number, description, unit_of_measure, date_due, 
										status, type, quantity, balance, price, row_id, ship_to_destination, terms, 
										week_no, plant, standard_qty, ship_type, ship_via, received,
										alternate_price)
									values	(:ll_ponumber, :ls_vcode, :ls_part, :ls_partname, :ls_um, :ldt_duedate,
										:ls_status, :ls_type, :ld_quantity, :ld_quantity, :ld_price, :li_rowid, :ls_shipto, :ls_terms,
										:li_weekno, :ls_plant, :ld_quantity, 'N', :ls_shipvia, 0,
										:ld_price);
								else
									ld_tmpqty = ld_tmpqty + ld_quantity
									ld_qtytmp = ld_qtytmp + ld_quantity
									
									update	po_detail
									set	quantity = :ld_tmpqty,
										balance = :ld_qtytmp,
										standard_qty = :ld_tmpqty
									where	po_number = :ll_ponumber and
										part_number = :ls_part and 
										date(date_due) = date(:ldt_duedate) and
										row_id = :ll_rowid;
								end if 
								lb_continue = true
								//	commit the transcations
								if sqlca.sqlcode = 0 then
									commit;
									select	isnull(sum(quantity),0)
									into	:ld_holdqty
									from	object
									where	part = :ls_part and
										status = 'H';
									if dw_ar_exception.find("part ='"+ls_part+"'",1,dw_ar_exception.rowcount()) = 0 then 
										ll_insrow = dw_ar_exception.insertrow(0)									
										dw_ar_exception.object.part[ll_insrow] = ls_part
										dw_ar_exception.object.po_number[ll_insrow] = ll_ponumber
										dw_ar_exception.object.qty[ll_insrow] = ld_holdqty
										dw_ar_exception.object.note[ll_insrow] = l_s_note										
									end if 	
								else
									rollback;
								end if 	
								
							end if 	
						next
					else
							select	isnull(sum(quantity),0)
							into	:ld_holdqty
							from	object
							where	part = :ls_part and
								status = 'H';
							if dw_ar_exception.find("part ='"+ls_part+"'",1,dw_ar_exception.rowcount()) = 0 then 
								ll_insrow = dw_ar_exception.insertrow(0)									
								dw_ar_exception.object.part[ll_insrow] = ls_part
								dw_ar_exception.object.po_number[ll_insrow] = ll_ponumber
								dw_ar_exception.object.qty[ll_insrow] = ld_holdqty
								dw_ar_exception.object.note[ll_insrow] = l_s_note
							end if 	
					end if 						
				end if 
			end if 	
		next

		//	If any records were deleted, run cop, re-build grid, netout the data
		if lb_continue then
			setpointer ( Hourglass! ) 
			DECLARE super_cop PROCEDURE FOR msp_super_cop 'Y', null, null
			USING sqlca;
			sqlca.autocommit = TRUE
			//	Run supercop
			execute super_cop;
			sqlca.autocommit = FALSE
			close super_cop;
			
			commit;

			yield()
			
			//	re-build crosstab
			triggerevent('ue_build_crosstab')
			
			setpointer ( arrow! )
		end if 
	end if 	
	if dw_ar_exception.rowcount() > 0 then
		dw_ar_exception.show()
	else
		dw_ar_exception.hide()
	end if 
end if 	

end event
public subroutine wf_schedule_job ();
end subroutine

public subroutine wf_display_vendors (string as_part);/* Declaration */
integer	li_ptr 
string	ls_vendor

/* Initialization */
FOR li_ptr = 1 TO 6
	iuo_vendor_list[li_ptr].visible	= FALSE
NEXT

/* Main Process */

//DECLARE cursor_vendor CURSOR FOR  
// SELECT vendor  
//   FROM part_vendor  
//  WHERE part = :as_part
//	AND  vendor > ''
//USING   SQLCA ;

//changed the select from a base file to a view, so that it could be customized 6/20/00

DECLARE	cursor_vendor CURSOR FOR  
SELECT	vendor  
FROM		mvw_vendorlist
WHERE		part = :as_part
USING   SQLCA ;

OPEN cursor_vendor;

FETCH cursor_vendor INTO :ls_vendor;

li_ptr = 0
gb_vendors.visible = TRUE

IF SQLCA.SQLCODE = 0 THEN
	
	DO WHILE ( li_ptr < 6 ) AND (SQLCA.SQLCode = 0)
		li_ptr ++
		iuo_vendor_list[ li_ptr ].st_vendor_code.text	= ls_vendor
		iuo_vendor_list[ li_ptr ].visible					= TRUE
		iuo_vendor_list[ li_ptr ].bringtotop				= TRUE
		FETCH cursor_vendor INTO :ls_vendor;
	LOOP

ELSEIF SQLCA.SQLCODE = 100 THEN
	
		li_ptr ++
		iuo_vendor_list[ li_ptr ].st_vendor_code.text	= 'ADD VENDOR PROFILE'
		iuo_vendor_list[ li_ptr ].visible					= TRUE
		iuo_vendor_list[ li_ptr ].bringtotop				= TRUE
	
END IF

CLOSE cursor_vendor;
end subroutine

public subroutine wf_initialize_vendors ();iuo_vendor_list[1]	=	uo_vendor1
iuo_vendor_list[2]	=	uo_vendor2
iuo_vendor_list[3]	=	uo_vendor3
iuo_vendor_list[4]	=	uo_vendor4
iuo_vendor_list[5]	=	uo_vendor5
iuo_vendor_list[6]	=	uo_vendor6
uo_vendor1.ii_ptr		= 1
uo_vendor2.ii_ptr		= 2
uo_vendor3.ii_ptr		= 3
uo_vendor4.ii_ptr		= 4
uo_vendor5.ii_ptr		= 5
uo_vendor6.ii_ptr		= 6
end subroutine

public subroutine wf_dragdrop_to_vendor (string a_s_vendor);/* Declaration */
s_parm_list	lstr_parm_list

/* Initialization */
lstr_parm_list.s_key_value		= is_key
lstr_parm_list.s_type			= ddlb_type.text
lstr_parm_list.s_parm_list[1]	= a_s_vendor
lstr_parm_list.s_parm_list[2]	= uo_crosstab.GetItemString ( il_current_row , "plant" )
lstr_parm_list.d_parm_list[1]	= id_start_date
lstr_parm_list.d_parm_list[2]	= id_date_clicked
lstr_parm_list.c_parm_list[1]	= ic_qty_clicked
lstr_parm_list.b_parm_list[1]	= ib_830_mode

/* Main Process */
OpenWithParm( w_po_schedule_grid_po_info, lstr_parm_list )
end subroutine

public function string wf_filter_vendor (string a_s_vendor);STRING 	l_s_part, &
			l_s_value

DECLARE msp_part_list CURSOR FOR
SELECT	part
FROM		part_vendor
WHERE		vendor = :a_s_vendor ;

OPEN  msp_part_list ;

FETCH msp_part_list INTO :l_s_part ;

DO WHILE (SQLCA.SQLCODE = 0)
	
	l_s_value = l_s_value + "part = '"+	l_s_part +"' OR "
	FETCH msp_part_list INTO :l_s_part ;

LOOP

CLOSE  msp_part_list ;

IF l_s_value > '' THEN 
	l_s_value = Left ( l_s_value, len ( l_s_value ) - 4 ) + "AND TYPE='P'"
ELSE
	l_s_value = "part = '' AND TYPE='P'"
END IF

RETURN l_s_value ;
end function

public subroutine wf_build_values (string a_s_type);datawindowchild l_dwc

dw_value.Reset ()

/* set the dddw name and columns */

CHOOSE CASE a_s_type

	CASE 'Commodity'
		dw_value.modify("data.dddw.name='d_dddw_commodity'")
		dw_value.modify("data.dddw.displaycolumn='id'")
		dw_value.modify("data.dddw.datacolumn='id'")

	CASE 'Vendor'
		dw_value.modify("data.dddw.name='d_dddw_vendors'")
		dw_value.modify("data.dddw.displaycolumn='code'")
		dw_value.modify("data.dddw.datacolumn='code'")

	CASE 'Plant'
		dw_value.modify("data.dddw.name='d_dddw_plants'")
		dw_value.modify("data.dddw.displaycolumn='destination'")
		dw_value.modify("data.dddw.datacolumn='destination'")

END CHOOSE

/* insert a row will 'all' options in it */
dw_value.insertrow(1)
dw_value.getchild ( "data" , l_dwc )

l_dwc.settransobject (sqlca)
l_dwc.retrieve ()

l_dwc.InsertRow ( 1 )
l_dwc.SetItem  ( 1, 1, 'All' )
l_dwc.SetItem  ( 1, 2, 'All' )

l_dwc.selectrow ( 0, false )



end subroutine

event ue_clicked_key_column;DECIMAL	lc_demand[]

INTEGER	li_col, &
			li_ptr

STRING	ls_date_list[], &
			ls_Check

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
	lstr_parm.b_parm_list[1]	=	ib_830_mode

	OpenSheetWithParm( w_netout_po_grid, lstr_parm, w_main_screen, 3, Layered! ) 

END IF
end event

on ue_display;call w_schedule_grid_base::ue_display;wf_display_vendors ( is_key )
end on

event activate;IF w_main_screen.MenuName <> 'm_po_schedule_grid' THEN &
	w_main_screen.ChangeMenu(m_po_schedule_grid)
end event

event ue_open;call super::ue_open;wf_initialize_vendors ( )
end event

event ue_netout;call super::ue_netout;m_po_schedule_grid.m_file.m_netout.Enabled = False
m_po_schedule_grid.m_file.m_datadump.Enabled = True



end event

event ue_build_crosstab;call super::ue_build_crosstab;/* 02-24-2000 KAZ Modified to return if the 'cancel' boolean is set to true, causing the
						event to exit directly, avoiding a watchdog error message.  Issue # 13223 */

if bcancel then return																								// ADD 02/24/2000 KAZ

if uo_crosstab.rowcount() > 0 then
	m_po_schedule_grid.m_file.m_netout.Enabled = TRUE
	m_po_schedule_grid.m_file.m_datadump.Enabled = False
else
	m_po_schedule_grid.m_file.m_netout.Enabled = FALSE
	m_po_schedule_grid.m_file.m_datadump.Enabled = True
end if 

end event

on w_po_schedule_grid.create
int iCurrent
call super::create
this.uo_vendor6=create uo_vendor6
this.uo_vendor5=create uo_vendor5
this.uo_vendor4=create uo_vendor4
this.uo_vendor3=create uo_vendor3
this.uo_vendor2=create uo_vendor2
this.uo_vendor1=create uo_vendor1
this.gb_vendors=create gb_vendors
this.dw_ar_exception=create dw_ar_exception
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_vendor6
this.Control[iCurrent+2]=this.uo_vendor5
this.Control[iCurrent+3]=this.uo_vendor4
this.Control[iCurrent+4]=this.uo_vendor3
this.Control[iCurrent+5]=this.uo_vendor2
this.Control[iCurrent+6]=this.uo_vendor1
this.Control[iCurrent+7]=this.gb_vendors
this.Control[iCurrent+8]=this.dw_ar_exception
end on

on w_po_schedule_grid.destroy
call super::destroy
destroy(this.uo_vendor6)
destroy(this.uo_vendor5)
destroy(this.uo_vendor4)
destroy(this.uo_vendor3)
destroy(this.uo_vendor2)
destroy(this.uo_vendor1)
destroy(this.gb_vendors)
destroy(this.dw_ar_exception)
end on

on resize;call w_schedule_grid_base::resize;IF IsValid ( uo_crosstab ) THEN
	gb_vendors.X		= uo_crosstab.X
	gb_vendors.y		= uo_crosstab.height + 230

	uo_vendor1.Y = gb_vendors.Y + 75
	uo_vendor2.Y = uo_vendor1.Y
	uo_vendor3.Y = uo_vendor2.Y
	uo_vendor4.Y = uo_vendor3.Y
	uo_vendor5.Y = uo_vendor4.Y
	uo_vendor6.Y = uo_vendor5.Y

	uo_vendor1.X = gb_vendors.X + 30
	uo_vendor2.X = uo_vendor1.X + 400
	uo_vendor3.X = uo_vendor2.X + 400
	uo_vendor4.X = uo_vendor3.X + 400
	uo_vendor5.X = uo_vendor4.X + 400
	uo_vendor6.X = uo_vendor5.X + 400
END IF
end on

type ddlb_type from w_schedule_grid_base`ddlb_type within w_po_schedule_grid
int Y=16
long BackColor=1090519039
string Item[]={"All parts",&
"Commodity",&
"Vendor",&
"Plant"}
end type

event ddlb_type::selectionchanged;/* modified the script to make dw_value visible or otherwise */

STRING l_s_type

l_s_type = ddlb_type.Text

CHOOSE CASE l_s_type

	CASE 'All parts'
		dw_value.Visible = FALSE
		uo_crosstab.SetFilter ( "TYPE='P'" )
		uo_crosstab.Filter ( )

	CASE ELSE
		dw_value.Visible = TRUE
		wf_build_values ( text )

END CHOOSE


end event

type ddlb_mode from w_schedule_grid_base`ddlb_mode within w_po_schedule_grid
int Y=16
long BackColor=1090519039
end type

event ddlb_mode::selectionchanged;call super::selectionchanged;w_po_schedule_grid.Triggerevent ( 'ue_build_crosstab' )
end event

type dw_value from w_schedule_grid_base`dw_value within w_po_schedule_grid
boolean BringToTop=true
end type

event dw_value::itemchanged;STRING	l_s_type, &
			l_s_value

l_s_type = ddlb_type.Text

IF data = 'All' or data = '' THEN
	uo_crosstab.SetFilter ( "TYPE='P'" )
	uo_crosstab.Filter ( ) 
ELSE	
	
	CHOOSE CASE l_s_type
		CASE 'Commodity'
			uo_crosstab.SetFilter ( "commodity='"+data+"' AND TYPE='P'")
			uo_crosstab.Filter ( ) 
		CASE 'Vendor'
     		l_s_value = wf_filter_vendor ( data )
			uo_crosstab.SetFilter ( l_s_value )
			uo_crosstab.Filter ( ) 
		CASE 'Plant'
			uo_crosstab.SetFilter ( "plant='"+data+"' AND TYPE='P'" )
			uo_crosstab.Filter ( ) 
	END CHOOSE
	
END IF

uo_crosstab.groupcalc()
end event

type uo_vendor6 from u_vendor_display within w_po_schedule_grid
int X=2569
int Y=980
int Height=84
int TabOrder=50
boolean Visible=false
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

on constructor;call u_vendor_display::constructor;uo_vendor6.X = uo_vendor5.X + 430
end on

on uo_vendor6.destroy
call u_vendor_display::destroy
end on

type uo_vendor5 from u_vendor_display within w_po_schedule_grid
int X=2066
int Y=980
int Height=84
int TabOrder=100
boolean Visible=false
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

on dragdrop;call u_vendor_display::dragdrop;uo_vendor5.X = uo_vendor4.X + 430
end on

on uo_vendor5.destroy
call u_vendor_display::destroy
end on

type uo_vendor4 from u_vendor_display within w_po_schedule_grid
int X=1499
int Y=980
int Height=80
int TabOrder=90
boolean Visible=false
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

on constructor;call u_vendor_display::constructor;uo_vendor4.X = uo_vendor3.X + 430
end on

on uo_vendor4.destroy
call u_vendor_display::destroy
end on

type uo_vendor3 from u_vendor_display within w_po_schedule_grid
int X=997
int Y=980
int Height=84
int TabOrder=80
boolean Visible=false
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

on constructor;call u_vendor_display::constructor;uo_vendor3.X = uo_vendor2.X + 430
end on

on uo_vendor3.destroy
call u_vendor_display::destroy
end on

type uo_vendor2 from u_vendor_display within w_po_schedule_grid
int X=521
int Y=980
int Height=84
int TabOrder=70
boolean Visible=false
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

on constructor;call u_vendor_display::constructor;uo_vendor2.X = uo_vendor1.X + 430
end on

on uo_vendor2.destroy
call u_vendor_display::destroy
end on

type uo_vendor1 from u_vendor_display within w_po_schedule_grid
int X=55
int Y=980
int Height=80
int TabOrder=60
boolean Visible=false
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

on constructor;call u_vendor_display::constructor;uo_vendor1.X = gb_vendors.X + 50
end on

on uo_vendor1.destroy
call u_vendor_display::destroy
end on

type gb_vendors from groupbox within w_po_schedule_grid
int X=18
int Y=908
int Width=2866
int Height=180
int TabOrder=40
boolean Visible=false
string Text="Available Vendors"
long BackColor=77897888
int TextSize=-8
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_ar_exception from datawindow within w_po_schedule_grid
int X=421
int Y=216
int Width=2619
int Height=1708
int TabOrder=40
boolean Visible=false
boolean BringToTop=true
string DataObject="d_autorelease_exception"
boolean TitleBar=true
string Title="Auto Releases Excption"
BorderStyle BorderStyle=StyleLowered!
boolean ControlMenu=true
boolean HScrollBar=true
boolean VScrollBar=true
boolean HSplitScroll=true
boolean LiveScroll=true
end type

event constructor;settransobject(sqlca)
end event

event buttonclicked;if dwo.name = 'cb_close' then
	hide()
elseif dwo.name = 'cb_print' then 
	if rowcount() > 0 then 
		print()
	else
		Messagebox(monsys.msg_title, "No data available to print")
	end if 	
end if

end event

