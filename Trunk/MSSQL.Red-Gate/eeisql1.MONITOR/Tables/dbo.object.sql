CREATE TABLE [dbo].[object]
(
[serial] [int] NOT NULL,
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[location] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[last_date] [datetime] NOT NULL,
[unit_measure] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[operator] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[status] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[station] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[origin] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[cost] [numeric] (20, 6) NULL,
[weight] [numeric] (20, 6) NULL,
[parent_serial] [numeric] (10, 0) NULL,
[note] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[quantity] [numeric] (20, 6) NULL,
[last_time] [datetime] NULL,
[date_due] [datetime] NULL,
[customer] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sequence] [int] NULL,
[shipper] [int] NULL,
[lot] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[po_number] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name] [varchar] (254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[plant] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[start_date] [datetime] NULL,
[std_quantity] [numeric] (20, 6) NULL,
[package_type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field1] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[field2] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[show_on_shipper] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tare_weight] [numeric] (20, 6) NULL,
[suffix] [int] NULL,
[std_cost] [numeric] (20, 6) NULL,
[user_defined_status] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[workorder] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[engineering_level] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[kanban_number] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dimension_qty_string] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dim_qty_string_other] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[varying_dimension_code] [numeric] (2, 0) NULL,
[posted] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ObjectBirthday] [datetime] NULL CONSTRAINT [DF__object__ObjectBi__032B1B27] DEFAULT (getdate()),
[ShipperToRAN] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE TRIGGER [dbo].[mtr_object_i] ON [dbo].[object]
FOR INSERT
AS
BEGIN

	DECLARE	@update_shipper		int,
		@net_weight		numeric(20,6),
		@tare_weight		numeric(20,6),
		@type		varchar(1),
		@part		varchar(25),
		@package_type	varchar(25),
		@std_qty		numeric(20,6),
		@serial		int,
		@shipper		int,
		@weight		numeric(20,6),
		@count			int,
		@unit_weight		numeric(20,6),
		@calc_weight	numeric(20,6),
		@current_datetime	datetime,
		@eng_level		varchar(10),
		@dummy_date		datetime

/*	This trigger is only valid for single row inserts to object table	*/
/*	Get key values for the new object...	*/
	set rowcount 1
	SELECT	@current_datetime = GetDate ( ),
		@type = type,
		@part = part,
		@package_type = package_type,
		@std_qty = std_quantity,
		@serial = serial,
		@shipper = shipper, 
		@weight  = weight,
		@eng_level   = engineering_level
	FROM	inserted
	set rowcount 0

/*	Set the engineering revision level for the object based on 'Right Now'	*/
      IF Isnull(@eng_level, '') = ''
      BEGIN  
    	  SELECT	@eng_level = max(engineering_level)
	  FROM	effective_change_notice
	  WHERE	effective_date = (
			select Max ( a.effective_date )
			  from effective_change_notice a
			 where a.effective_date < @current_datetime AND
				 a.part = @part ) AND
		effective_change_notice.part = @part
	  UPDATE	object
	  SET		engineering_level = @eng_level
	  WHERE	serial = @serial
      END

/*	Set tare weight to zero, then adjust it to package weight if package type is valid	*/
	UPDATE	object
	   SET	tare_weight = 0
	 WHERE	serial = @serial

	UPDATE	object
	   SET	tare_weight = isnull(package_materials.weight,0)
	  FROM	package_materials
	 WHERE	serial = @serial AND
			code = @package_type

/*	If not a weighed item or a super object, calculate the object's net weight	*/
	IF IsNull ( @type, '' ) = '' -- is whether a pallet or normal object
	BEGIN
            -- next is whether weight is from scale or not
		IF IsNull ( (	SELECT	part_packaging.serial_type
				FROM	part_packaging
				WHERE	part = @part AND
							code = @package_type ), '(None)' ) = '(None)'
		BEGIN
			SELECT @unit_weight = IsNull ( unit_weight, 0 )
			FROM   part_inventory
			WHERE  part_inventory.part = @part
			select @calc_weight = @unit_weight * @std_qty
                  -- calculate weight only when weight column is null while inserting a new row 
			IF (@weight IS NULL)
				UPDATE 	object
				SET	 	object.weight = isnull(@calc_weight,0)
				WHERE  object.serial = @serial


		END

	END

	IF @shipper > 0
	begin
		execute msp_calc_shipper_weights @shipper

		update	object
		set	object.destination = shipper.destination
		from	shipper
		where	object.serial = @serial and
			shipper.id = object.shipper
	end

END

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [dbo].[mtr_object_u] on [dbo].[object]
for update
as
set nocount on
declare
	@OldShipper int
,	@NewShipper int

declare
	ShipperWeights cursor local for
select distinct
	OldShipper = d.shipper
,	NewShipper = i.shipper
from
	deleted d
	join inserted i
		on d.serial = i.serial
where
	coalesce(d.shipper, -1) != coalesce(i.shipper, -1)
	or
	(	i.shipper > 0
		and
		(	update(package_type)
			or update(std_quantity)
			or update(part)
		)
	)

open
	ShipperWeights

while
	1=1 begin
	
	fetch
		ShipperWeights
	into
		@OldShipper
	,	@NewShipper
	
	if	@@FETCH_STATUS != 0 begin
		break
	end
	
	if	@OldShipper != @NewShipper
		and @OldShipper > 0 begin

		execute msp_calc_shipper_weights @OldShipper
	end
	
	if	@NewShipper > 0 begin

		execute msp_calc_shipper_weights @NewShipper
	end
end

close
	ShipperWeights
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [dbo].[tr_object_Plant] on [dbo].[object] after insert, update
as
declare
	@TranDT datetime
,	@Result int

set xact_abort off
set nocount on
set ansi_warnings off
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
--- </Error Handling>

begin try
	--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
	declare
		@TranCount smallint

	set	@TranCount = @@TranCount
	set	@TranDT = coalesce(@TranDT, GetDate())
	save tran @ProcName
	--- </Tran>

	---	<ArgumentValidation>

	---	</ArgumentValidation>
	
	--- <Body>
	if	exists
		(	select
				*
			from
				inserted i
				join dbo.location l
					on l.code = i.location
			where
				coalesce(i.plant, '') != l.plant
		) begin

		--- <Update rows="1+">
		set	@TableName = '[tableName]'
		
		update
			o
		set
			plant = l.plant
		from
			dbo.object o
			join inserted i
				join dbo.location l
					on l.code = i.location
				on i.serial = o.serial
		where
			coalesce(i.plant, '') != l.plant
		
		select
			@Error = @@Error,
			@RowCount = @@Rowcount
		
		if	@Error != 0 begin
			set	@Result = 999999
			RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			rollback tran @ProcName
			return
		end
		if	@RowCount <= 0 begin
			set	@Result = 999999
			RAISERROR ('Error updating into %s in procedure %s.  Rows Updated: %d.  Expected rows: 1 or more.', 16, 1, @TableName, @ProcName, @RowCount)
			rollback tran @ProcName
			return
		end
		--- </Update>
		
	end
	--- </Body>
end try
begin catch
	declare
		@errorName int
	,	@errorSeverity int
	,	@errorState int
	,	@errorLine int
	,	@errorProcedures sysname
	,	@errorMessage nvarchar(2048)
	,	@xact_state int
	
	select
		@errorName = error_number()
	,	@errorSeverity = error_severity()
	,	@errorState = error_state ()
	,	@errorLine = error_line()
	,	@errorProcedures = error_procedure()
	,	@errorMessage = error_message()
	,	@xact_state = xact_state()

	if	xact_state() = -1 begin
		print 'Error number: ' + convert(varchar, @errorName)
		print 'Error severity: ' + convert(varchar, @errorSeverity)
		print 'Error state: ' + convert(varchar, @errorState)
		print 'Error line: ' + convert(varchar, @errorLine)
		print 'Error procedure: ' + @errorProcedures
		print 'Error message: ' + @errorMessage
		print 'xact_state: ' + convert(varchar, @xact_state)
		
		rollback transaction
	end
	else begin
		/*	Capture any errors in SP Logging. */
		rollback tran @ProcName
	end
end catch

---	<Return>
set	@Result = 0
return
--- </Return>
/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go

begin transaction Test
go

insert
	dbo.object
...

update
	...
from
	dbo.object
...

delete
	...
from
	dbo.object
...
go

if	@@trancount > 0 begin
	rollback
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [dbo].[tr_object_Stage] on [dbo].[object] after insert, update
as
declare
	@TranDT datetime
,	@Result int

set xact_abort off
set nocount on
set ansi_warnings off
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
--- </Error Handling>

begin try
	--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
	declare
		@TranCount smallint

	set	@TranCount = @@TranCount
	set	@TranDT = coalesce(@TranDT, GetDate())
	save tran @ProcName
	--- </Tran>

	---	<ArgumentValidation>

	---	</ArgumentValidation>
	--- <Body>
	if	exists
		(	select
				*
			from
				inserted i
				join dbo.shipper s on
					s.id = i.shipper
			where
				i.location != s.plant + ' Stage'
		) begin

		if	not exists
			(	select
					*
					from
						inserted i
						join dbo.shipper s on
							s.id = i.shipper
						join dbo.location l on
							l.code = s.plant + ' Stage'
				) begin

			--- <Insert rows="1+">
			set	@TableName = 'dbo.location'
				
			insert
				dbo.location
			(	code
			,	name
			,	type
			,	group_no
			,	sequence
			,	plant
			,	status
			,	secured_location
			,	label_on_transfer
			,	hazardous
			)
			select
				code = s.plant + ' Stage'	
			,	name = s.plant
			,	type = 'ST'
			,	group_no = 'FINISHED GOODS'
			,	sequence = null
			,	plant = s.plant
			,	status = null
			,	secured_location = 'N'
			,	label_on_transfer = 'N'
			,	hazardous = null
			from
				inserted i
				join dbo.shipper s on
					s.id = i.shipper
			where
				not exists
					(	select
							*
						from
							dbo.location l
						where
							l.code = s.plant + ' Stage'		
					)
				
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
				
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
				rollback tran @ProcName
				return
			end
			if	@RowCount <= 0 begin
				set	@Result = 999999
				RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1 or more.', 16, 1, @TableName, @ProcName, @RowCount)
				rollback tran @ProcName
				return
			end
			--- </Insert>
				
		end

		--- <Update rows="1+">
		set	@TableName = 'dbo.object'
		
		update
			o
		set
			location = s.plant + ' Stage'
		from
			dbo.object o
			join inserted i
				on i.serial = o.serial
			join dbo.shipper s on
				s.id = i.shipper
		where
			i.location != s.plant + ' Stage'
		
		select
			@Error = @@Error,
			@RowCount = @@Rowcount
		
		if	@Error != 0 begin
			set	@Result = 999999
			RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			rollback tran @ProcName
			return
		end
		if	@RowCount <= 0 begin
			set	@Result = 999999
			RAISERROR ('Error updating into %s in procedure %s.  Rows Updated: %d.  Expected rows: 1 or more.', 16, 1, @TableName, @ProcName, @RowCount)
			rollback tran @ProcName
			return
		end
		--- </Update>
		
	end
	--- </Body>
end try
begin catch
	declare
		@errorName int
	,	@errorSeverity int
	,	@errorState int
	,	@errorLine int
	,	@errorProcedures sysname
	,	@errorMessage nvarchar(2048)
	,	@xact_state int
	
	select
		@errorName = error_number()
	,	@errorSeverity = error_severity()
	,	@errorState = error_state ()
	,	@errorLine = error_line()
	,	@errorProcedures = error_procedure()
	,	@errorMessage = error_message()
	,	@xact_state = xact_state()

	if	xact_state() = -1 begin
		print 'Error number: ' + convert(varchar, @errorName)
		print 'Error severity: ' + convert(varchar, @errorSeverity)
		print 'Error state: ' + convert(varchar, @errorState)
		print 'Error line: ' + convert(varchar, @errorLine)
		print 'Error procedure: ' + @errorProcedures
		print 'Error message: ' + @errorMessage
		print 'xact_state: ' + convert(varchar, @xact_state)
		
		rollback transaction
	end
	else begin
		/*	Capture any errors in SP Logging. */
		rollback tran @ProcName
	end
end catch

---	<Return>
set	@Result = 0
return
--- </Return>
/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go

begin transaction Test
go

insert
	dbo.object
...

update
	...
from
	dbo.object
...

delete
	...
from
	dbo.object
...
go

if	@@trancount > 0 begin
	rollback
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/
GO
ALTER TABLE [dbo].[object] ADD CONSTRAINT [PK__object__14DBF883] PRIMARY KEY NONCLUSTERED  ([serial]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_object_4] ON [dbo].[object] ([location], [part], [std_quantity]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_object_1] ON [dbo].[object] ([parent_serial]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [part] ON [dbo].[object] ([part]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_object_5] ON [dbo].[object] ([part], [location], [status], [std_quantity]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_object_2] ON [dbo].[object] ([plant]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_object_3] ON [dbo].[object] ([shipper], [part], [parent_serial]) INCLUDE ([custom1], [serial], [std_quantity]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [status_index] ON [dbo].[object] ([status]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Object_Status] ON [dbo].[object] ([status]) INCLUDE ([custom2], [last_date], [location], [note], [part], [quantity], [serial]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Object_StatusPartLocationQty] ON [dbo].[object] ([status], [part], [location], [quantity]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Object_StatusQty_IncSerialPartLocShipper] ON [dbo].[object] ([status], [quantity]) INCLUDE ([last_date], [location], [part], [serial], [shipper]) ON [PRIMARY]
GO
CREATE STATISTICS [_dta_stat_792389892_1_20_2] ON [dbo].[object] ([part], [serial], [shipper])
GO
CREATE STATISTICS [_dta_stat_792389892_1_2] ON [dbo].[object] ([serial], [part])
GO
GRANT SELECT ON  [dbo].[object] TO [APPUser]
GO
GRANT INSERT ON  [dbo].[object] TO [APPUser]
GO
GRANT DELETE ON  [dbo].[object] TO [APPUser]
GO
GRANT UPDATE ON  [dbo].[object] TO [APPUser]
GO
