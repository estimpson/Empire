select
	convert (smallint, req_spid) as spid
,	rsc_dbid as dbid
,	rsc_objid as ObjId
,	rsc_indid as IndId
,	substring(v.name, 1, 4) as Type
,	substring(rsc_text, 1, 32) as Resource
,	substring(u.name, 1, 8) as Mode
,	substring(x.name, 1, 5) as Status
from
	master.dbo.syslockinfo sli
	join master.dbo.spt_values v
		on sli.rsc_type = v.number
		   and v.type = 'LR'
	join master.dbo.spt_values x
		on sli.req_status = x.number
		   and x.type = 'LS'
	join master.dbo.spt_values u
		on sli.req_mode + 1 = u.number
		   and u.type = 'L'
where
	sli.rsc_objid = object_id('dbo.RawEDIData')
order by
	spid

select
	*
from
	sys.dm_tran_locks dtl
where
	dtl.resource_associated_entity_id = object_id('dbi.RawEDIData')

select
	dm_filestream_non_transacted_handles.opened_file_name, *
from
	sys.dm_filestream_non_transacted_handles

select
	*
from
	sys.dm_filestream_file_io_handles dffih

select
	*
from
	sys.dm_filestream_file_io_requests dffir

-- Close all open handles in the current database.  
--sp_kill_filestream_non_transacted_handles 

-- Close all open handles in myFileTable.  
--sp_kill_filestream_non_transacted_handles @table_name = ’myFileTable’  

-- Close a specific handle in myFileTable.  
--sp_kill_filestream_non_transacted_handles @table_name = ’myFileTable’, @handle_id = 0xFFFAAADD