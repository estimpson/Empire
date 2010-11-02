HA$PBExportHeader$u_explorerview.sru
forward
global type u_explorerview from u_base
end type
end forward

global type u_explorerview from u_base
integer width = 2048
integer height = 996
long backcolor = 272714554
borderstyle borderstyle = stylelowered!
event move pbm_move
event type integer pfc_save ( )
end type
global u_explorerview u_explorerview

type variables

private u_explorerpanel	iuo_ExplorerPanel
private window	iw_Requestor

end variables
forward prototypes
public function integer of_setrequestor (window aw_Requestor)
public function integer of_show (string as_classname, ref n_businessobject abo_parm)
end prototypes

event move;
//	Move drag object.
if IsValid (iw_Requestor) then
	
	//	Check that specified class is valid.
	if IsValid (iuo_ExplorerPanel) then
		iuo_ExplorerPanel.X = X
	end if
end if

end event

event type integer pfc_save();
if IsValid (iuo_ExplorerPanel) then return iuo_ExplorerPanel.event pfc_save ()

end event

public function integer of_setrequestor (window aw_Requestor);
//	Record window if valid.
if IsValid ( aw_Requestor ) then
	iw_Requestor = aw_Requestor
	return SUCCESS
end if

//	Not valid.
return FAILURE

end function

public function integer of_show (string as_classname, ref n_businessobject abo_parm);
//	Close the current view.
if IsValid (iuo_ExplorerPanel) and IsValid (iw_Requestor) then iw_Requestor.CloseUserObject (iuo_ExplorerPanel)

//	Open a new view.
if IsValid (iw_Requestor) then
	
	//	Check that specified class is valid.
	if IsValid (FindClassDefinition (as_ClassName)) then
		
		//	Open this class.
		if iw_Requestor.OpenUserObjectWithParm (iuo_ExplorerPanel, abo_Parm, as_ClassName, X, Y) = 1 then
			
			//	Resize to take full client area.
			iuo_ExplorerPanel.Resize (Width, Height)
			
			//	Bring view to top.
			iuo_ExplorerPanel.BringToTop = true
			
			//	Enable resize.
			of_SetResize (false)
			of_SetResize (true)
			inv_Resize.of_Register (iuo_ExplorerPanel, 0, 0, 100, 100)
			
			//	Enable or disable appropriate menu items.
			if IsValid (FindClassDefinition (abo_Parm.is_ExplorerViewMenu)) then
				m_explorerview	lm_ExplorerViewMenu
				lm_ExplorerViewMenu = create using abo_Parm.is_ExplorerViewMenu
				m_explorerview_window.m_file.m_new.enabled = lm_ExplorerviewMenu.m_file.m_new.enabled
				m_explorerview_window.m_file.m_save.enabled = lm_ExplorerviewMenu.m_file.m_save.enabled
				m_explorerview_window.m_file.m_print.enabled = lm_ExplorerviewMenu.m_file.m_print.enabled
				m_explorerview_window.m_file.m_delete.enabled = lm_ExplorerviewMenu.m_file.m_delete.enabled
				m_explorerview_window.m_edit.m_find.enabled = lm_ExplorerviewMenu.m_edit.m_find.enabled
				destroy lm_ExplorerViewMenu
			end if

			//	Return success.
			return SUCCESS
		end if
	end if
end if

//	Failed.
return FAILURE

end function

on u_explorerview.create
call super::create
end on

on u_explorerview.destroy
call super::destroy
end on

event pfc_updatespending;call super::pfc_updatespending;
if IsValid (iuo_ExplorerPanel) then return iuo_ExplorerPanel.of_UpdatesPending ()

end event

event pfc_accepttext;call super::pfc_accepttext;
if IsValid (iuo_ExplorerPanel) then return iuo_ExplorerPanel.of_AcceptText (ab_FocusOnError)


end event

