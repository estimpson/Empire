HA$PBExportHeader$n_tr_dropship.sru
forward
global type n_tr_dropship from n_tr
end type
end forward

global type n_tr_dropship from n_tr
integer ii_sqlconnector = 2
end type
global n_tr_dropship n_tr_dropship

on n_tr_dropship.create
call super::create
end on

on n_tr_dropship.destroy
call super::destroy
end on

