SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [dbo].[usp_CreateRma_ProcessByDestPart]
	@OperatorCode varchar(5)
,	@RmaNumber varchar(50)
,	@CreateRTV int = 0
,	@PlaceSerialsOnHold int = 0
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
/*  Serials exist.  */
if not exists (
		select
			1
		from
			dbo.SerialsQuantitiesToAutoRMA_RTV srma ) begin
			
	set	@Result = 999198
	RAISERROR ('No serials have been added to RMA.  Procedure %s.', 16, 1, @ProcName)
	rollback tran @ProcName
	return		
end

/*  Serials have not already been RMA'd.  */
if exists (
		select
			1
		from
			dbo.SerialsQuantitiesToAutoRMA_RTV srma
			join dbo.audit_trail at
				on at.serial = srma.Serial
		where
			at.type = 'U' ) begin
	
	declare
		@PreviousRmaShipper varchar(20)
		
	select top(1)
		@PreviousRmaShipper = at.shipper
	from
		dbo.SerialsQuantitiesToAutoRMA_RTV srma
		join dbo.audit_trail at
			on at.serial = srma.Serial
		where
			at.type = 'U'
			
	set	@Result = 999199
	RAISERROR ('One or more of the serials have already been RMAd on shipper %s.  Procedure %s.', 16, 1, @PreviousRmaShipper, @ProcName)
	rollback tran @ProcName
	return
end
---	</ArgumentValidation>


--- <Body>
-- Get unique return-from destinations 
declare @tempDestinations table
(
	Destination varchar(20)
,	Processed int
)

declare
	@Destination varchar(20)
,	@Processed int

insert into	@tempDestinations
(
	Destination
,	Processed
)
select
	at.destination
,	0
from
	dbo.SerialsQuantitiesToAutoRMA_RTV srma
	join dbo.audit_trail at
		on at.serial = srma.serial 
		and at.type = 'S' 
		and at.date_stamp = (	select max(date_stamp) 
								from audit_trail at2 
								where at2.type = 'S' and at2.serial = srma.serial )
group by
	at.destination


-- EF
if 1 = 2 begin
    select
		cast(null as int) as RmaShipper
	,	cast(null as int) as RtvShipper
	where
		1 = 2 
 end
  
declare @shippers table
(
	RmaShipper int null
,	RtvShipper int null
)

declare
	@NextShipper integer = null
,	@NextShipperRTV integer = null

while ((select count(1) from @tempDestinations where Processed = 0) > 0) begin

	select 
		@Destination = min(Destination)
	from
		@tempDestinations
	where
		Processed = 0

	-- Determine if the parts from this destination need to be split 
	-- into separate shippers based on product lines
	declare @tempParts table
	(
		Part varchar(25)
	,	GlSegment varchar(20)
	)

	declare
		@Part varchar(25)
	,	@GlSegment varchar(20)

	insert into	@tempParts
	(
		Part
	,	GlSegment
	)
	select
		at.part
	,	''
	from
		dbo.SerialsQuantitiesToAutoRMA_RTV srma
		join dbo.audit_trail at
			on at.serial = srma.serial 
			and at.type = 'S' 
			and at.date_stamp = (	select max(date_stamp) 
									from audit_trail at2 
									where at2.type = 'S' and at2.serial = srma.serial )
			and at.destination = @Destination
	group by
		at.part
					
	update
		tp
	set
		tp.GlSegment = pl.gl_segment
	from
		@tempParts tp
		join eehsql1.eeh.dbo.part p
			on p.part = tp.Part
		join eehsql1.eeh.dbo.product_line pl
			on p.product_line = pl.id
	--where
	--	--p.part = 'SMT-EEB4051-WA00-B'
	--	p.part = @Part
	
	
	-- Filter the list of parts going to this destination further
	-- by grouping on gl_segment
	declare @tempUniqueParts table
	(
		Part varchar(25)
	,	ProcessedRecord int
	)
	
	declare
		@UniquePart varchar(25)

	insert into @tempUniqueParts
	(
		Part
	,	ProcessedRecord
	)
	select
		min(tp.Part)
	,	0
	from
		@tempParts tp
	group by
		tp.GlSegment

	-- Create RMA (and possibly RTV) for each unique destination, part, gl_segment combination
	while ((select count(1) from @tempUniqueParts where ProcessedRecord = 0) > 0) begin
	
		select 
			@UniquePart = min(Part)
		from
			@tempUniqueParts
		where
			ProcessedRecord = 0

		--- <Create RMA>
		set			@CallProcName = 'dbo.usp_CreateRma_ProcessSerialsQuantities_ByDestPart'
		execute		@ProcReturn = dbo.usp_CreateRma_ProcessSerialsQuantities_ByDestPart
					@OperatorCode = @OperatorCode,
					@Destination = @Destination,
					@Part = @Part,
					@RmaNumber = @RmaNumber,
					@CreateRTV = @CreateRTV,
					@PlaceSerialsOnHold = @PlaceSerialsOnHold,
					@NextShipper = @NextShipper out,
					@NextShipperRTV = @NextShipperRTV out,
					@TranDT = @TranDT out,
					@Result = @ProcResult out
		       
		set @Error = @@Error
		if @Error != 0 begin
			set	@Result = 910000
			--if	@Debug != 0 begin
			--	RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
			--end
			rollback tran @ProcName
			return @Result
		end
		if @ProcResult != 0 begin
			set	@Result = 910001
			--if	@Debug != 0 begin
			--	RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
			--end
			rollback tran @ProcName
			return	@Result
		end
		--- </Create RMA>	
		
		
		-- Keep track of new shippers
		insert into @shippers
		(
			RmaShipper
		,	RtvShipper
		)
		select
			RmaShipper = @NextShipper
		,	RtvShipper = @NextShipperRTV
		
		
		-- Prepare for next part record
		update
			@tempUniqueParts
		set
			ProcessedRecord = 1
		where
			Part = @UniquePart	
			
	end

	-- Prepare for next destination record
	update
		@tempDestinations
	set
		Processed = 1
	where
		Destination = @Destination
		
end


-- Return data
select
	RmaShipper
,	RtvShipper
from
	@shippers
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
