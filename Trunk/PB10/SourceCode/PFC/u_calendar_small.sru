HA$PBExportHeader$u_calendar_small.sru
forward
global type u_calendar_small from u_calendar
end type
end forward

global type u_calendar_small from u_calendar
int Width=544
int Height=564
end type
global u_calendar_small u_calendar_small

type variables

Protected:

integer	ORIGHEIGHT = 548
integer	ORIGWIDTH = 549
end variables

on u_calendar_small.create
call super::create
end on

on u_calendar_small.destroy
call super::destroy
end on

type dw_cal from u_calendar`dw_cal within u_calendar_small
int Width=549
int Height=548
string DataObject="d_calendarsmall"
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

