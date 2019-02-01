CREATE TABLE [dbo].[audit_trail]
(
[serial] [int] NOT NULL,
[date_stamp] [datetime] NOT NULL,
[type] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[quantity] [numeric] (20, 6) NULL,
[remarks] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[price] [numeric] (20, 6) NULL,
[salesman] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[vendor] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[po_number] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[operator] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[from_loc] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[to_loc] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[on_hand] [numeric] (20, 6) NULL,
[lot] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[weight] [numeric] (20, 6) NULL,
[status] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[shipper] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[flag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[activity] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[unit] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[workorder] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[std_quantity] [numeric] (20, 6) NULL,
[cost] [numeric] (20, 6) NULL,
[control_number] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[plant] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[invoice_number] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[notes] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[gl_account] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[package_type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[suffix] [int] NULL,
[due_date] [datetime] NULL,
[group_no] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sales_order] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[release_no] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dropship_shipper] [int] NULL,
[std_cost] [numeric] (20, 6) NULL,
[user_defined_status] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[engineering_level] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[posted] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[parent_serial] [numeric] (10, 0) NULL,
[origin] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sequence] [int] NULL,
[object_type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[part_name] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[start_date] [datetime] NULL,
[field1] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field2] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[show_on_shipper] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tare_weight] [numeric] (20, 6) NULL,
[kanban_number] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dimension_qty_string] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dim_qty_string_other] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[varying_dimension_code] [numeric] (2, 0) NULL,
[invoice] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[invoice_line] [smallint] NULL,
[dbdate] [datetime] NULL CONSTRAINT [DF_audit_trail_dbdate] DEFAULT (getdate()),
[id] [int] NOT NULL IDENTITY(1, 1),
[gl_segment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShipperToRAN] [int] NULL,
[WarehouseFreightLot] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[DEL_Empower_AuditTrail]
ON [dbo].[audit_trail] FOR DELETE
AS
BEGIN
	IF EXISTS (SELECT 1 FROM deleted WHERE posted = 'Y')
		RAISERROR('Deleting a transaction interfaced to Empower GL.',11,1)	

	INSERT INTO
		empower_monitor_po_receiver_transactions
		(
			monitor_audit_trail_id, monitor_transaction_date,
			monitor_part, monitor_part_type, monitor_plant, monitor_product_line, 
			monitor_po_number, monitor_shipper, 
			monitor_standard_quantity, monitor_quantity, monitor_unit_cost, 
			changed_date, changed_user_id
		)
		(SELECT
			deleted.id monitor_audit_trail_id, CONVERT(DATE, deleted.date_stamp) monitor_transaction_date,
			UPPER(LTRIM(RTRIM(deleted.part))) monitor_part, UPPER(LTRIM(RTRIM(part.type))) monitor_part_type, UPPER(LTRIM(RTRIM(deleted.plant))) monitor_plant, UPPER(LTRIM(RTRIM(part.product_line))) monitor_product_line, 
			CONVERT(VARCHAR(25), UPPER(LTRIM(RTRIM(deleted.po_number)))) monitor_po_number, UPPER(LTRIM(RTRIM(deleted.shipper))) monitor_shipper,
			ISNULL(deleted.std_quantity, ISNULL(deleted.quantity, 0)) * -1 monitor_standard_quantity, ISNULL(deleted.quantity, 0) * -1 monitor_quantity, ISNULL(deleted.price, 0) monitor_unit_cost, 
			GETDATE() changed_date, 'MONITOR' changed_user_id
		FROM
			deleted LEFT OUTER JOIN
			part ON
				deleted.part = part.part
		WHERE
			deleted.type = 'R'
		)
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[INS_Empower_AuditTrail]
ON [dbo].[audit_trail] FOR INSERT
AS
BEGIN

	-- insert r types into transactions to be processed

	INSERT INTO
		empower_monitor_po_receiver_transactions
		(
			monitor_audit_trail_id, monitor_transaction_date,
			monitor_part, monitor_part_type, monitor_plant, monitor_product_line, 
			monitor_po_number, monitor_shipper, 
			monitor_standard_quantity, monitor_quantity, monitor_unit_cost, 
			changed_date, changed_user_id
		)
		(SELECT
			inserted.id monitor_audit_trail_id, CONVERT(DATE, inserted.date_stamp) monitor_transaction_date, 
			UPPER(LTRIM(RTRIM(inserted.part))) monitor_part, UPPER(LTRIM(RTRIM(part.type))) monitor_part_type, UPPER(LTRIM(RTRIM(inserted.plant))) monitor_plant, UPPER(LTRIM(RTRIM(part.product_line))) monitor_product_line, 
			CONVERT(VARCHAR(25), UPPER(LTRIM(RTRIM(inserted.po_number)))) monitor_po_number, UPPER(LTRIM(RTRIM(inserted.shipper))) monitor_shipper,
			ISNULL(inserted.std_quantity, ISNULL(inserted.quantity, 0)) monitor_standard_quantity, ISNULL(inserted.quantity, 0) monitor_quantity, ISNULL(inserted.price, 0) monitor_unit_cost, 
			GETDATE() changed_date, 'MONITOR' changed_user_id 
		FROM
			inserted LEFT OUTER JOIN
			part ON
				inserted.part = part.part
		WHERE
			inserted.type = 'R' AND
			ISNULL(inserted.std_quantity, ISNULL(inserted.quantity, 0)) > 0
		)

	IF EXISTS (SELECT 1 FROM empower_preferences WHERE preference = 'MonitorDeleteAndCorrectReceipts' AND preference_value = 'Y')
	BEGIN

		-- insert correction transactions

		-- no work to do if the previous audit_trail type isn't an 'R'.
		-- There is a stored procedure that handles the deletion of an
		-- 'R'. They way it is written will also allow it to handle a
		-- change in quantity on an 'R', so we'll simply call it with
		-- the correct quantity.

		INSERT INTO
			empower_monitor_po_receiver_transactions
			(
				monitor_audit_trail_id, monitor_transaction_date,
				monitor_part, monitor_part_type, monitor_plant, monitor_product_line, 
				monitor_po_number, monitor_shipper, 
				monitor_standard_quantity, 
				monitor_quantity, 
				monitor_unit_cost, 
				changed_date, changed_user_id
			)
			(SELECT
				audit_trail.id monitor_audit_trail_id, CONVERT(DATE, previous_audit_trail.date_stamp) monitor_transaction_date,
				UPPER(LTRIM(RTRIM(previous_audit_trail.part))) monitor_part, UPPER(LTRIM(RTRIM(part.type))) monitor_part_type, UPPER(LTRIM(RTRIM(previous_audit_trail.plant))) monitor_plant, UPPER(LTRIM(RTRIM(part.product_line))) monitor_product_line, 
				CONVERT(VARCHAR(25), UPPER(LTRIM(RTRIM(previous_audit_trail.po_number)))) monitor_po_number, UPPER(LTRIM(RTRIM(previous_audit_trail.shipper))) monitor_shipper,
				CASE WHEN audit_trail.type = 'X' THEN 
					ISNULL(audit_trail.std_quantity, ISNULL(audit_trail.quantity, 0)) - ISNULL(previous_qty_audit_trail.std_quantity, ISNULL(previous_qty_audit_trail.quantity, 0))
				ELSE
					-- there has been discussion about whether the quantity on
					-- a delete will be 0 or the deleted quantity. We won't count
					-- on the value from the delete but will use the value from
					-- the original receipt or previous correction.
					ISNULL(previous_qty_audit_trail.std_quantity, ISNULL(previous_qty_audit_trail.quantity, 0)) * -1
				END monitor_standard_quantity,
				CASE WHEN audit_trail.type = 'X' THEN 
					ISNULL(audit_trail.quantity, 0) - ISNULL(previous_qty_audit_trail.quantity, 0)
				ELSE
					-- there has been discussion about whether the quantity on
					-- a delete will be 0 or the deleted quantity. We won't count
					-- on the value from the delete but will use the value from
					-- the original receipt or previous correction.
					ISNULL(previous_qty_audit_trail.quantity, 0) * -1
				END monitor_quantity,
				ISNULL(previous_audit_trail.price, 0) monitor_unit_cost, 
				GETDATE() changed_date, 'MONITOR' changed_user_id 
			FROM
				inserted audit_trail INNER JOIN
				vw_empower_audit_trail_previous ON
					audit_trail.id = vw_empower_audit_trail_previous.id INNER JOIN
				audit_trail previous_audit_trail ON
					vw_empower_audit_trail_previous.previous_id = previous_audit_trail.id INNER JOIN
				audit_trail previous_qty_audit_trail ON
					vw_empower_audit_trail_previous.previous_qty_id = previous_qty_audit_trail.id LEFT OUTER JOIN
				part ON
					previous_audit_trail.part = part.part 
			WHERE
				previous_audit_trail.type = 'R'
			)
	END	
		
END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE trigger [dbo].[mtr_audit_trail_i]
on [dbo].[audit_trail]
for insert
as
-----------------------------------------------------------------------------------------------
--	This trigger concatenates gl segments from various tables & writes to audit_trail

--	Process:
--	I.	Set gl_account code.
-- 	II.	Record shipout for homogeneous pallet with part id of boxes.
--	III.	Record shipout for loose box.
---	IV.		Capture manual Adds and send to Dan West Via E-Mail. Added 7/18/2012 Andre S. Boulanger, FT, LLC
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

--	IV.	Capture Audit Trail and Send E_mail to Dan in the event Manual Adds Exist
declare	@AuditTrail table
(	Serial int,
	DateStamp datetime,
	Employee varchar(50),
	Part varchar(25),
	Quantity numeric(20,6),
	Notes varchar(254)
)
Insert @AuditTrail
Select	Serial,
		date_stamp,
		e.name,
		Part,
		Quantity,
		Notes
from 
	inserted I
left join
	employee e on e.operator_code = I.operator	
where
	I.Type ='A'


If Exists (Select 1 from @AuditTrail)
Begin

DECLARE @tableHTMLA  NVARCHAR(MAX) ;

SET @tableHTMLA =
    N'<H1>Audit Trail Manual Adds</H1>' +
    N'<table border="1">' +
    N'<tr><th>Serial Number</th>' +
    N'<th>Date Stamp</th><th>Employee</th><th>Part</th>' +
	N'<th>Quantity</th><th>Reason</th></tr>' +
    CAST ( ( SELECT td = eo.Serial, '',
                    td = DateStamp, '',
                    td = Employee, '',
					td = Part, '',
                    td = Quantity, '',
                    td = Notes
              FROM @AuditTrail  eo
            order by 1,3 desc 
              FOR XML PATH('tr'), TYPE 
    ) AS NVARCHAR(MAX) ) +
    N'</table>' ;
    
exec msdb.dbo.sp_send_dbmail @profile_name = 'DBMail', -- sysname
    @recipients = 'dwest@empireelect.com', -- varchar(max)
    --@copy_recipients = 'aboulanger@fore-thought.com', -- varchar(max)
    --@blind_copy_recipients = 'aboulanger@fore-thought.com;estimpson@fore-thought.com', -- varchar(max)
    @subject = N'Audit Trail Manual Adds', -- nvarchar(255)
    @body = @TableHTMLA, -- nvarchar(max)
    @body_format = 'HTML', -- varchar(20)
    @importance = 'High' -- varchar(6)

End



GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[UPD_Empower_AuditTrail]
ON [dbo].[audit_trail] FOR UPDATE
AS
BEGIN
	INSERT INTO
		empower_monitor_po_receiver_transactions
		(
			monitor_audit_trail_id, monitor_transaction_date,
			monitor_part, monitor_part_type, monitor_plant, monitor_product_line, 
			monitor_po_number, monitor_shipper, 
			monitor_standard_quantity, monitor_quantity, monitor_unit_cost, 
			changed_date, changed_user_id
		)
		(SELECT
			deleted.id monitor_audit_trail_id, CONVERT(DATE, deleted.date_stamp) monitor_transaction_date,
			UPPER(LTRIM(RTRIM(deleted.part))) monitor_part, UPPER(LTRIM(RTRIM(part.type))) monitor_part_type, UPPER(LTRIM(RTRIM(deleted.plant))) monitor_plant, UPPER(LTRIM(RTRIM(part.product_line))) monitor_product_line, 
			CONVERT(VARCHAR(25), UPPER(LTRIM(RTRIM(deleted.po_number)))) monitor_po_number, UPPER(LTRIM(RTRIM(deleted.shipper))) monitor_shipper,
			ISNULL(deleted.std_quantity, ISNULL(deleted.quantity, 0)) * -1 monitor_standard_quantity, ISNULL(deleted.quantity, 0) * -1 monitor_quantity, ISNULL(deleted.price, 0) monitor_unit_cost, 
			GETDATE() changed_date, 'MONITOR' changed_user_id
		FROM
			inserted INNER JOIN
			deleted ON
				inserted.id = deleted.id LEFT OUTER JOIN
			part ON
				inserted.part = part.part
		WHERE
			inserted.type = 'D' AND
			deleted.type = 'R' 
		)
END
GO
ALTER TABLE [dbo].[audit_trail] ADD CONSTRAINT [PK__audit_trail__4A8A36D5] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [eei_idx_custom4_dtstamp_type] ON [dbo].[audit_trail] ([custom4], [date_stamp], [type]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [date_type] ON [dbo].[audit_trail] ([date_stamp], [type]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_audit_trail_dbdate] ON [dbo].[audit_trail] ([dbdate] DESC, [type]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [part_type_to] ON [dbo].[audit_trail] ([part], [type], [to_loc]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_audit_trail_1] ON [dbo].[audit_trail] ([serial], [date_stamp], [type]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [audit_trail_shipper_ix] ON [dbo].[audit_trail] ([shipper]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_AuditTrail_TypeDate_IncPartQty] ON [dbo].[audit_trail] ([type], [date_stamp]) INCLUDE ([package_type], [part], [quantity], [shipper]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [type_for_objhist_u] ON [dbo].[audit_trail] ([type], [posted]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [audit_trail_workorder_type_ix] ON [dbo].[audit_trail] ([workorder], [type]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[audit_trail] TO [APPUser]
GO
GRANT SELECT ON  [dbo].[audit_trail] TO [APPUser]
GO
