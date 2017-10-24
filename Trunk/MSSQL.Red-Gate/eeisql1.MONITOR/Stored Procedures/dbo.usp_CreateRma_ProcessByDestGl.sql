SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [dbo].[usp_CreateRma_ProcessByDestGl]
	@OperatorCode varchar(5)
,	@RmaNumber varchar(50)
,	@CreateRTV int = 0
,	@PlaceSerialsOnHold int = 0
,	@Notes varchar(200)
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
			join object o 
				on srma.serial = o.serial ) begin
	
	set	@Result = 999199
	RAISERROR ('One or more of the serials are already in the object table.', 16, 1)
	rollback tran @ProcName
	return
end


declare
	@SerialList varchar(max)
	
set @SerialList =
	(	select
			Fx.ToList(srma.Serial)
		from
			dbo.SerialsQuantitiesToAutoRMA_RTV srma
	)

declare
	@EEHSelect varchar(max)
	
set @EEHSelect = 'select count(serial) as cnt from eeh.dbo.object where serial in (' + @SerialList + ')'

declare
	@OpenQuerySyntax nvarchar(max) = '
select 
	a.*
from 
	openquery(eehsql1, '''+@EEHSelect+''') AS a'


declare @temp table
(
	serialCount int
)

insert into
	@temp
exec 
	sp_executesql @OpenQuerySyntax

if (( select t.serialCount from @temp t) > 0 ) begin
	set	@Result = 999200
	RAISERROR ('One or more of the serials are already in the Honduras object table.', 16, 1)
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
		

	-- Determine if the parts from this destination need to be split into 
	-- separate shippers based on product lines
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
	-- by grouping them based on gl_segment
	declare @tempUniqueGl table
	(
		UniqueGlSegment varchar(20)
	,	ProcessedRecord int
	)

	insert into @tempUniqueGl
	(
		UniqueGlSegment
	,	ProcessedRecord
	)
	select
		tp.GlSegment
	,	0
	from
		@tempParts tp
	group by
		tp.GlSegment

	-- Create RMA (and possibly RTV) for each unique destination, part, gl_segment combination
	while ((select count(1) from @tempUniqueGl where ProcessedRecord = 0) > 0) begin

		select 
			@GlSegment = min(UniqueGlSegment)
		from
			@tempUniqueGl
		where
			ProcessedRecord = 0


		--- <Create RMA>
		--set			@CallProcName = 'dbo.usp_CreateRma_ProcessSerialsQuantities_ByDestGl'
		--execute		@ProcReturn = dbo.usp_CreateRma_ProcessSerialsQuantities_ByDestGl
		set			@CallProcName = 'dbo.usp_CreateRma_ProcessSerialsQuantities_ByDestGl_Ala'
		execute		@ProcReturn = dbo.usp_CreateRma_ProcessSerialsQuantities_ByDestGl_Ala
					@OperatorCode = @OperatorCode,
					@Destination = @Destination,
					@GlSegment = @GlSegment,
					@RmaNumber = @RmaNumber,
					@CreateRTV = @CreateRTV,
					@PlaceSerialsOnHold = @PlaceSerialsOnHold,
					@NextShipper = @NextShipper out,
					@NextShipperRTV = @NextShipperRTV out,
					@Notes = @Notes,
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
		
		-- Clear parameters
		select 
			@NextShipper = null
		,	@NextShipperRTV = null
		
		
		-- Prepare for next part record
		update
			@tempUniqueGl
		set
			ProcessedRecord = 1
		where
			UniqueGlSegment = @GlSegment
			
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
