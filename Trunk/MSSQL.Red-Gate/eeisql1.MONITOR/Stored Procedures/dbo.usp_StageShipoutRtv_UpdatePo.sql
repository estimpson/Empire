SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[usp_StageShipoutRtv_UpdatePo]
	@OperatorCode varchar(5)
,	@Serial int
,	@TranDT datetime = null out
,	@Result integer = null  out
as
set nocount on
set ansi_warnings on
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDIStanley.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>
--Serial exists
if not exists (
		select
			1
		from
			dbo.object o
		where
			o.serial = @Serial ) begin

	set	@Result = 999999
	RAISERROR ('%d does not exist in the system.', 16, 1, @Serial)
	rollback tran @ProcName
	return			
end		

-- Serial is not a pallet
if exists (
		select
			1
		from
			dbo.object o
		where	
			o.serial = @Serial
			and o.type = 'S' ) begin

	set	@Result = 999999
	RAISERROR ('Serial %d is a pallet. Cannot assign a PO number to a pallet.', 16, 1, @Serial)
	rollback tran @ProcName
	return			
end

-- Serial does not already have a PO tied to it
if exists (
		select
			1
		from
			dbo.object o
		where
			o.Serial = @Serial
			and coalesce(o.po_number, '') <> '' ) begin

	set	@Result = 999999
	RAISERROR ('Serial %d already has a PO number.', 16, 1, @Serial)
	rollback tran @ProcName
	return			
end

-- A purchase order exists for the part
if not exists
	(	select
			1
		from
			dbo.object o
			join dbo.po_header ph
				on ph.blanket_part = o.part
		where
			o.serial = @Serial ) begin

	set	@Result = 999999
	RAISERROR ('No purchase order exists for this part.', 16, 1)
	rollback tran @ProcName
	return
end
---	</ArgumentValidation>


--- <Body>
declare
	@Po varchar(30)	

select
	@Po = max(ph.po_number)
from
	dbo.object o
	join dbo.po_header ph
		on ph.blanket_part = o.part
where
	o.serial = @Serial 
	
--- <Update rows="1">
set	@TableName = 'dbo.object'
update
	dbo.object
set
	po_number = @Po
where
	serial = @Serial

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s with PO number in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount != 1 begin
	set	@Result = 999999
	RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Update>
--- </Body>


---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>
GO
