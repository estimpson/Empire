SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[usp_CreatedRmaRtvRollback]
	@OperatorCode varchar(5)
,	@RmaRtvNumber varchar(50)
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

---	</ArgumentValidation>


--- <Body>
-- Get a list of shippers created by RMA transactions
declare @shippersList table
(
	Shipper varchar(30)
)

insert @shippersList
(
	Shipper
)
select
	at.shipper as Shipper
from
	dbo.SerialRmaRtvLookup lu
	join dbo.audit_trail at
		on at.serial = lu.Serial
where
	lu.RmaRtvNumber = @RmaRtvNumber
	and lu.RowCreateUser = @OperatorCode
	and at.type = ('U')
	and at.date_stamp = (	
			select	max(at2.date_stamp) 
			from	audit_trail at2 
			where	at2.type = 'U' 
					and at2.serial = at.serial )
group by
	at.shipper
	
-- RTV shippers
insert @shippersList
(
	Shipper
)
select
	convert(varchar(30), o.shipper) as Shipper
from
	dbo.SerialRmaRtvLookup lu
	join dbo.object o
		on o.serial = lu.Serial
where
	lu.RmaRtvNumber = @RmaRtvNumber
	and lu.RowCreateUser = @OperatorCode
	and convert(varchar(30), o.shipper) not in ( select	sl.Shipper from	@shippersList sl )
group by
	o.shipper



if not exists (
		select
			1
		from
			@shippersList sl ) begin
	
	set	@Result = 999999
	rollback tran @ProcName
	return		
end
	



/*  Object records  */

-- Assume objects more than ten minutes old were created by RMA / RTV transactions, and update them 
--- <Update rows="1+">
set	@TableName = 'dbo.object'
update
	o
set
	shipper = null
from
	dbo.object o
	join @shippersList sl
		on convert(int, sl.Shipper) = o.shipper
where
	o.last_date < dateadd(minute, -10, getdate())
	
select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Update>
	
	
-- Assume objects less than ten minutes old were created by RMA / RTV transactions, and delete them			
--- <Delete rows="1+">
set	@TableName = 'dbo.object'

delete 
	o
from
	dbo.object o
	join @shippersList sl
		on convert(int, sl.Shipper) = o.shipper
where
	o.last_date > dateadd(minute, -10, getdate())

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Delete>

	


/*  Delete shipper_detail records  */
--- <Delete rows="1+">
set	@TableName = 'dbo.shipper_detail'

delete 
	sd	
from 
	dbo.shipper_detail sd
	join @shippersList sl
		on sl.Shipper = sd.shipper

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount = 0 begin
	set	@Result = 999999
	RAISERROR ('Error deleting from table %s in procedure %s.  Rows attepted delete: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Delete>



/*  Delete shipper(s)  */
--- <Delete rows="1+">
set	@TableName = 'dbo.shipper'

delete
	s
from
	dbo.shipper s
	join @shippersList sl
		on sl.Shipper = s.id

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount = 0 begin
	set	@Result = 999999
	RAISERROR ('Error deleting from table %s in procedure %s.  Rows attepted delete: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Delete>



/*  Delete RMA records  */
--- <Delete>
set	@TableName = 'dbo.audit_trail'

delete
	at
from
	dbo.audit_trail at
	join dbo.SerialRmaRtvLookup lu
		on lu.Serial = at.serial
where
	lu.RmaRtvNumber = @RmaRtvNumber
	and lu.RowCreateUser = @OperatorCode
	and at.type = 'U'
	and at.shipper in (
		select
			sl.Shipper
		from
			@shippersList sl )

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error deleting RMA records from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Delete>




/*  Alabama part transactions  */

-- Delete 'W2' records
--- <Delete>
set	@TableName = 'dbo.audit_trail'

delete
	at
from
	dbo.audit_trail at
	join @shippersList sl
		on sl.Shipper = at.shipper
	join dbo.SerialRmaRtvLookup lu
		on lu.Serial = at.serial
where
	lu.RmaRtvNumber = @RmaRtvNumber
	and lu.RowCreateUser = @OperatorCode
	and at.type = 'W2'

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error deleting W2 records from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Delete>


-- Delete 'Q' records (scrapped bulb parts)
--- <Delete>
set	@TableName = 'dbo.audit_trail'

delete
	at
from
	dbo.audit_trail at
	join @shippersList sl
		on sl.Shipper = at.shipper
	join dbo.SerialRmaRtvLookup lu
		on lu.Serial = at.serial
where
	lu.RmaRtvNumber = @RmaRtvNumber
	and lu.RowCreateUser = @OperatorCode
	and at.type = 'Q'
	and at.status = 'S'

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error deleting Q records from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Delete>


-- Delete 'D' records (deleted bulb parts)
--- <Delete>
set	@TableName = 'dbo.audit_trail'

delete
	at
from
	dbo.audit_trail at
	join @shippersList sl
		on sl.Shipper = at.shipper
	join dbo.SerialRmaRtvLookup lu
		on lu.Serial = at.serial
where
	lu.RmaRtvNumber = @RmaRtvNumber
	and lu.RowCreateUser = @OperatorCode
	and at.type = 'D'
	and at.status = 'S'

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error deleting D records from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Delete>




-- Delete look-up records
--- <Delete>
set	@TableName = 'dbo.SerialRmaRtvLookup'

delete from
	dbo.SerialRmaRtvLookup
where
	RmaRtvNumber = @RmaRtvNumber
	and RowCreateUser = @OperatorCode

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error deleting D records from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Delete>




-- Clean up temporary RMA / RTV serials
--- <Delete>
set	@TableName = 'dbo.SerialRmaRtvLookup'

delete from
	dbo.SerialsQuantitiesToAutoRMA_RTV
where
	OperatorCode = @OperatorCode
--- </Delete>
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
