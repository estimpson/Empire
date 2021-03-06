USE [TestMonitor]
GO
/****** Object:  Trigger [dbo].[mtr_audit_trail_i]    Script Date: 04/13/2011 14:52:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER trigger [dbo].[mtr_audit_trail_i]
on [dbo].[audit_trail]
for insert
as
-----------------------------------------------------------------------------------------------
--	This trigger concatenates gl segments from various tables & writes to audit_trail

--	Process:
--	I.	Set gl_account code.
-- 	II.	Record shipout for homogeneous pallet with part id of boxes.
--	III.	Record shipout for loose box.
-----------------------------------------------------------------------------------------------
set nocount on

--	I.	Set gl_account code.
update	audit_trail
set	gl_account = Left (GL.GLAccountNo, 15)
from	audit_trail
	join 
	(	select	Serial = inserted.serial,
			Type = inserted.type,
			DateStamp = inserted.date_stamp,
			GLAccountNo = IsNull (
			case	part.class
				when 'M' then part_gl_account.gl_account_no_cr
				when 'P' then part_gl_account.gl_account_no_db
			end, '') + IsNull (destination.gl_segment, '') + IsNull (product_line.gl_segment, '')
		from	inserted
			join part on inserted.part = part.part
			left outer join gl_tran_type on gl_tran_type.name =
				case	when inserted.type='A' and part.type ='F' then 'Manual Add - Finished Goo' 
					when inserted.type='A' and part.type ='W' then 'Manual Add - Wip'
					when inserted.type='A' and part.type ='R' then 'Manual Add - Raw'
					when inserted.type='X' then 'Change/Correct Object'
					when inserted.type='R' and part.type ='F' then 'Receive Finished'
					when inserted.type='R' and part.type ='R' then 'Receive Raw'
					when inserted.type='R' and part.type ='W' then 'Receive Wip'
					when inserted.type='V' and part.type in ('R','W','F') then 'Return Raw to Vendor'
					when inserted.type='M' and part.type ='F' then 'Issue Finished'
					when inserted.type='M' and part.type ='R' then 'Issue Raw to Wip'
					when inserted.type='M' and part.type ='W' then 'Issue Wip'
					when inserted.type='J' and part.type ='F' then 'Complete Finished Goods'
					when inserted.type='J' and part.type ='W' then 'Complete Wip'
					when inserted.type='J' and part.type ='R' then 'Ship Finished Goods' 
					else ''
				end
			left outer join part_gl_account on part_gl_account.part = part.product_line and
				part_gl_account.tran_type = gl_tran_type.code
			left outer join destination on destination.plant = inserted.plant
			left outer join product_line on part.product_line = product_line.id) GL on audit_trail.serial = GL.Serial and
		audit_trail.type = GL.Type and
		audit_trail.date_stamp = GL.DateStamp

-- 	II.	Record shipout for homogeneous pallet with part id of boxes.
if	exists
	(	select
			*
		from
			inserted i
		where
			type = 'S'
	) begin
	
	insert	serial_asn
	select	pallet.serial,
		max (boxes.part),
		convert (integer, pallet.shipper),
		pallet.package_type
	from	inserted pallet 
		join audit_trail boxes on pallet.serial = boxes.parent_serial
	where	pallet.object_type = 'S' and
		pallet.type = 'S'
	group by
		pallet.serial,
		pallet.shipper,
		pallet.package_type
	having
		count (distinct boxes.part) = 1		

	--	III.	Record shipout for loose box.
	insert	serial_asn
	select	serial,
		part,
		convert (integer, shipper),
		package_type
	from	inserted
	where	parent_serial is null and
		object_type is null and
		type = 'S'
end
go
