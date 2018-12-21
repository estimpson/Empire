CREATE TABLE [dbo].[part]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[cross_ref] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[class] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[commodity] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[group_technology] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[quality_alert] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[description_short] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[description_long] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[serial_type] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[product_line] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[configuration] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[standard_cost] [numeric] (20, 6) NULL,
[user_defined_1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[user_defined_2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[flag] [int] NULL,
[engineering_level] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[drawing_number] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[gl_account_code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[eng_effective_date] [datetime] NULL,
[low_level_code] [int] NULL,
[InfoRecord] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

	
create trigger [dbo].[mtr_part_d] on [dbo].[part] for delete
as
begin
  delete from part_standard where part=any(select part from deleted)
  delete from part_eecustom where part=any(select part from deleted)
end


GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE TRIGGER [dbo].[mtr_part_i] ON [dbo].[part]
FOR INSERT
AS
BEGIN
   INSERT INTO part_standard (part) (SELECT part FROM inserted)
END

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[mtr_part_u] ON [dbo].[part]
FOR UPDATE
AS
BEGIN
   Declare @dpart varchar(25),
           @ipart varchar(25)
   SELECT @dpart=part 
     FROM deleted  
   SELECT @ipart=part 
     FROM inserted
   IF (@dpart <> @ipart) 
   BEGIN
     DELETE part_standard WHERE part IN (SELECT part FROM deleted)
     INSERT INTO part_standard (part) (SELECT part FROM inserted)
   END 
END

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create trigger [dbo].[tr_part_crossref_u] on [dbo].[part] after update
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
	/*	Handle cross_ref updates. */
	if	update(cross_ref)
		and exists
			(	select
					*
				from
					dbo.order_header oh
					join inserted i
						on oh.blanket_part = i.part						
			) begin
		
		--- <Update rows="1+">
		set	@TableName = 'dbo.order_header'
		
		update
			oh
		set
			customer_part = i.cross_ref
		from
			dbo.order_header oh
			join inserted i
				on oh.blanket_part = i.part						
		
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
	dbo.part
...

update
	...
from
	dbo.part
...

delete
	...
from
	dbo.part
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
DISABLE TRIGGER [dbo].[tr_part_crossref_u] ON [dbo].[part]
GO
ALTER TABLE [dbo].[part] ADD CONSTRAINT [PK__part__17B8652E] PRIMARY KEY NONCLUSTERED  ([part]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [class_index] ON [dbo].[part] ([class]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX1_Part_PartType] ON [dbo].[part] ([part], [type]) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[part] TO [APPUser]
GO
