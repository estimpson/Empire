CREATE TABLE [dbo].[audit_trail_temp]
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
[dbdate] [datetime] NULL CONSTRAINT [DF_audit_trail_dbdate_temp] DEFAULT (getdate()),
[id] [int] NOT NULL,
[gl_segment] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE TRIGGER [dbo].[INS_Empower_AuditTrail_temp]
ON [dbo].[audit_trail_temp] FOR INSERT
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
ALTER TABLE [dbo].[audit_trail_temp] ADD CONSTRAINT [PK__audit_tr__3213E83F58F680E7] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
