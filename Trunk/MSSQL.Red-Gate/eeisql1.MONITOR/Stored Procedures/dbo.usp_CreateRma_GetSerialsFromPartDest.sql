SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[usp_CreateRma_GetSerialsFromPartDest]
	@OperatorCode varchar(5)
,	@Destination varchar(20)
,	@PartNumber varchar(25)
,	@RequiredQuantity numeric(20,6)
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
/*  Part number is valid.  */
if not exists (
		select
			1
		from
			dbo.part p
		where
			p.part = @PartNumber ) begin
	
	set	@Result = 999990
	RAISERROR ('Part does not exist in the system.  Procedure: %s.', 16, 1, @ProcName)
	rollback tran @ProcName
	return
end

/*  Part must have been shipped to this destination at some point.  */
if ( (
		select
			isnull(sum(at.quantity), 0)
		from
			dbo.shipper s
			join dbo.audit_trail at
				on at.shipper = convert(varchar(20), s.id)
		where
			at.part = @PartNumber
			and at.type = 'S'
			and s.destination = @Destination ) = 0 ) begin

	set	@Result = 999991
	RAISERROR ('Part %s was never shipped to destination %s.  Procedure: %s.', 16, 1, @PartNumber, @Destination, @ProcName)
	rollback tran @ProcName
	return
end			

/*  Shipped inventory quantity must be equal to or greater than the RMA amount.  */
if ( (
		select
			isnull(sum(at.quantity), 0)
		from
			dbo.shipper s
			join dbo.audit_trail at
				on at.shipper = convert(varchar(20), s.id)
		where
			at.part = @PartNumber
			and at.type = 'S'
			and s.destination = @Destination ) < @RequiredQuantity ) begin

	set	@Result = 999991
	RAISERROR ('There is not enough shipped inventory of part %s to destination %s to cover the RMA.  Procedure: %s.', 16, 1, @PartNumber, @Destination, @ProcName)
	rollback tran @ProcName
	return
end			
---	</ArgumentValidation>


--- <Body>
declare @tempSerials table
(  
	ID int not null
,	Serial int not null
,	Quantity decimal(20,6) not null 
,	DateStamp datetime not null 
,	Processed int not null
)

-- Get serials for this part that were previously shipped to this destination but have not been RMAd or RTVd
insert into @tempSerials
(
	ID 
,	Serial
,	Quantity
,	DateStamp
,	Processed
)
select
	ID = row_number() over(order by at.date_stamp desc)
,	Serial = at.serial
,	Quantity = at.quantity
,	DateStamp = at.date_stamp
,	0
from
	dbo.shipper s
	join dbo.audit_trail at
		on at.shipper = convert(varchar(20), s.id)
where
	at.part = @PartNumber
	and at.type = 'S'
	and s.destination = @Destination
	and not exists (
				select
					1
				from
					dbo.audit_trail at2
				where
					at2.serial = at.serial
					and at2.type in ('U', 'V', 'W1') )
order by
	at.date_stamp desc

	
declare
	@AllocateID int
,	@RemainingQty decimal(20,6)

select
	@RemainingQty = @RequiredQuantity

while (@RemainingQty > 0) begin

	select
		@AllocateID = min(ts.ID)
	from
		@tempSerials ts
	where
		ts.Processed = 0

	
	-- Check to make sure the serial doesn't already exist under another user. (RMA / RTV is not already in process for this part / dest combination.)
	declare
		@SerialInUse int
	,	@OriginalOperator varchar(50)
	
	select
		@SerialInUse = sq.Serial 
	,	@OriginalOperator = e.name
	from
		dbo.SerialsQuantitiesToAutoRMA_RTV sq
		join @tempSerials ts
			on ts.Serial = sq.Serial
		left join dbo.employee e
			on e.operator_code = sq.OperatorCode
	where
		ts.ID = @AllocateID
		and sq.OperatorCode <> @OperatorCode
		
	if (@SerialInUse is not null) begin				
		set	@Result = 999992
		RAISERROR ('Part %s, coming from destination %s is already in process for RMA/RTV, started by %s.  Procedure: %s', 16, 1, @PartNumber, @Destination, @OriginalOperator, @ProcName)
		rollback tran @ProcName
		return	
	end
				
					
	--- <Insert rows="1">	
	set	@TableName = 'dbo.SerialsQuantitiesToAutoRMA_RTV'
	
	insert into dbo.SerialsQuantitiesToAutoRMA_RTV
	(
		Serial
	,	Quantity
	,	OperatorCode
	)	
	select
		Serial = ts.Serial
	,	Quantity = 
			case
				when ts.Quantity > @RemainingQty then @RemainingQty
				else ts.Quantity
			end 
	,	@OperatorCode
	from
		@tempSerials ts
	where
		ts.ID = @AllocateID
				
	select
		@Error = @@Error,
		@RowCount = @@Rowcount
		
	if	@Error != 0 begin
		set	@Result = 999993
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	if	@RowCount != 1 begin
		set	@Result = 999994
		RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
		rollback tran @ProcName
		return
	end	
	--- </Insert>				
			                      	

	select
		@RemainingQty = @RemainingQty - ts.Quantity
	from
		@tempSerials ts
	where
		ts.ID = @AllocateID
		
	update
		@tempSerials
	set
		Processed = 1
	where
		ID = @AllocateID

end
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
