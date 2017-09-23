SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [RTV].[usp_CreateRTV_ImportSerials_ToExistingRTV]
	@OperatorCode varchar(5)
,	@SerialList varchar(max)
,	@RTVShipper int
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
/*	Parse serial list. */
create table #serialList
(	serial int
,	RowID int not null IDENTITY(1, 1) primary key
)

insert
	#serialList
select
	serial = convert(int, fsstr.value)
from
	dbo.fn_SplitStringToRows(@SerialList, ',') fsstr
where
	fsstr.Value like '%[0-9]%'
	and fsstr.Value not like '%[^0-9]%'

/*	Ensure all serials are valid. */
declare
	@invalidSerialList varchar(max)

select
	@invalidSerialList = Fx.ToList(sl.serial)
from
	#serialList sl
where
	not exists
		(	select
				*
			from
				dbo.object o
			where
				o.serial = sl.serial
		)

if	@invalidSerialList > ''
	begin
	set @Result = 999999
	raiserror ('One or more invalid serials (%s).  Procedure %s.', 16, 1, @invalidSerialList, @ProcName)
	rollback tran @ProcName
	return
end

/*	Ensure all serials can be returned to Honduras. */
declare
	@invalidHondurasSerialList varchar(max)

select
	@invalidHondurasSerialList = Fx.ToList(convert(varchar, sl.serial) + ':' +o.part)
from
	#serialList sl
	join dbo.object o
		on o.serial = sl.serial
where
	not exists
		(	select
				*
			from
				dbo.po_header ph
			where
				ph.blanket_part  = o.part
		)

if	@invalidHondurasSerialList > ''
	begin
	set @Result = 999999
	raiserror ('One or more invalid serials (%s).  Procedure %s.', 16, 1, @invalidHondurasSerialList, @ProcName)
	rollback tran @ProcName
	return
end

/*	Ensure serials don't conflict with any in Honduras. */
declare
	@EEHSelect varchar(max)
	
select
	@EEHSelect = 'select serial from eeh.dbo.object where serial in (' + FX.ToList(sl.serial) + ')'
from
	#serialList sl
--print @EEHSelect

declare
	@OpenQuerySyntax nvarchar(max) = '
select 
	a.*
from 
	openquery(eehsql1, '''+@EEHSelect+''') AS a'
--print @OpenQuerySyntax

declare @temp table
(	Serial int
)

insert into
	@temp
exec 
	sp_executesql @OpenQuerySyntax

if	exists
		(	select
  	 			*
  	 		from
  	 			@temp t
		) begin

	declare @conflictHondurasSerialList varchar(max)
	select
		@conflictHondurasSerialList = FX.ToList(t.Serial)
	from
		@temp t
	set @Result = 999999
	raiserror ('One or more serials already in Honduras (%s).  Procedure %s.', 16, 1, @conflictHondurasSerialList, @ProcName)
	rollback tran @ProcName
	return
end

/*	Add to RTV shipper. */
/*		Generate a list of parts and get GL segment from Honduras. */
declare
	@PartList varchar(max)

select
	@PartList =
	(	select
			FX.ToList(distinct '''''' + o.part + '''''')
		from
			#serialList sl
			join dbo.object o
				on o.serial = sl.serial
	)

select
	@EEHSelect = '
select
	p.part
,	pl.gl_segment
from
	eeh.dbo.part p
		join eeh.dbo.product_line pl
			on pl.id = p.product_line
where
	p.part in (' + @PartList + ')'
--print @EEHSelect

set	@OpenQuerySyntax = '
select 
	a.*
from 
	openquery(eehsql1, '''+@EEHSelect+''') AS a'
--print @OpenQuerySyntax

declare
	@RTVPartGLSegments table
(	Part varchar(25) primary key
,	GLSegment varchar(50)
)

insert into
	@RTVPartGLSegments
exec 
	sp_executesql @OpenQuerySyntax

--select
--	*
--from
--	@RTVPartGLSegments rpgs

/*		Generate a list of parts and get GL segment from Honduras for existing shipper. */
select
	@PartList =
	(	select
			FX.ToList(distinct '''''' + sd.part_original + '''''')
		from
			dbo.shipper_detail sd
		where
			sd.shipper = @RTVShipper
	)

select
	@EEHSelect = '
select
	p.part
,	pl.gl_segment
from
	eeh.dbo.part p
		join eeh.dbo.product_line pl
			on pl.id = p.product_line
where
	p.part in (' + @PartList + ')'
--print @EEHSelect

set	@OpenQuerySyntax = '
select 
	a.*
from 
	openquery(eehsql1, '''+@EEHSelect+''') AS a'
--print @OpenQuerySyntax

declare
	@RTVExistingPartGLSegments table
(	Part varchar(25) primary key
,	GLSegment varchar(50)
)

insert into
	@RTVExistingPartGLSegments
exec 
	sp_executesql @OpenQuerySyntax

--select
--	*
--from
--	@RTVExistingPartGLSegments rpgs

/*		Only one GL Segment can be added. */
declare
	@GLSegmentList varchar(max)
,	@GLSegmentCount int

select
	@GLSegmentList = FX.ToList(rpgs.GLSegment)
,	@GLSegmentCount = count(*)
from
	(	select
			rpgs.GLSegment
		from
			@RTVPartGLSegments rpgs
		group by
			rpgs.GLSegment
	) rpgs

if	@GLSegmentCount != 1 begin
	raiserror ('Only parts from a single GL Segment can be added to an existing RTV (%s).  Procedure %s.', 16, 1, @GLSegmentList, @ProcName)
	rollback tran @ProcName
	return
end

/*		Parts must have same GL Segment as shipper. */
declare
	@ShipperGLSegment varchar(50)
,	@PartGLSegment varchar(50)

select
	@ShipperGLSegment =
		(	select
				max(repgs.GLSegment)
			from
				@RTVExistingPartGLSegments repgs
		)
,	@PartGLSegment =
		(	select
				max(repgs.GLSegment)
			from
				@RTVPartGLSegments repgs
		)

if	coalesce(@ShipperGLSegment, @PartGLSegment) != @PartGLSegment

if	@GLSegmentCount != 1 begin
	raiserror ('Shipper GL Segment (%s) conflicts with new part GL Segment (%s).  Procedure %s.', 16, 1, @ShipperGLSegment, @PartGLSegment, @ProcName)
	rollback tran @ProcName
	return
end

/*		Create shipper details(s) if needed. */
if	exists
		(	select
				*
			from
				@RTVPartGLSegments rpgs
			where
				rpgs.Part not in
					(	select
							repgs.Part
						from
							@RTVExistingPartGLSegments repgs
					)
		) begin

	--- <Insert rows="1+">
	set	@TableName = 'dbo.shipper_detail'

	insert
		dbo.shipper_detail
	(	shipper
	,	part
	,	qty_required
	,	qty_packed
	,	qty_original
	,	accum_shipped
	,	order_no
	,	type
	,	account_code
	,	operator
	,	boxes_staged
	,	alternative_qty
	,	alternative_unit
	,	price_type
	,	customer_part
	,	part_name
	,	part_original
	,	stage_using_weight
	)
	select
		shipper = @RTVShipper
	,	part = o.part
	,	qty_required = sum(o.quantity)
	,	qty_packed = sum(o.quantity)
	,	qty_original = sum(o.quantity)
	,	accum_shipped = 0
	,	order_no = 0
	,	type = 'I'
	,	account_code = '4030'
	,	operator = @OperatorCode
	,	boxes_staged = count(*)
	,	alternative_qty = sum(o.std_quantity)
	,	alternative_unit = max(pInv.standard_unit)
	,	price_type = 'P'
	,	customer_part = o.part
	,	part_name = max(p.name)
	,	part_original = o.part
	,	stage_using_weight = 'N'
	from
		#serialList sl
		join dbo.object o
			join dbo.part p
				on p.part = o.part
			join dbo.part_inventory pInv
				on pInv.part = o.part
			on o.serial = sl.serial
		join @RTVPartGLSegments rpgs
			on rpgs.Part = o.part
	where
		rpgs.Part not in
			(	select
					repgs.Part
				from
					@RTVExistingPartGLSegments repgs
			)
	group by
		o.part

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

--select
--	*
--from
--	dbo.shipper s
--	join dbo.shipper_detail sd
--		on sd.shipper = s.id
--	join @RTVShippers rs
--		on rs.ShipperID = s.id

/*	Stage objects to shippers. */
--- <Update rows="1+">
set	@TableName = 'dbo.object'

update
	o
set	shipper = @RTVShipper
,	show_on_shipper = 'Y'
from
	#serialList sl
	join dbo.object o
		join dbo.part p
			on p.part = o.part
		join dbo.part_inventory pInv
			on pInv.part = o.part
		on o.serial = sl.serial
	join @RTVPartGLSegments rpgs
		on rpgs.Part = o.part

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

declare
	@OperatorCode varchar(5)
,	@SerialList varchar(max)
,	@RTVShipper int

set @OperatorCode = 'EES'
set	@SerialList = '36264629,36307338,36267319,'
set @RTVShipper = 105774

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = RTV.usp_CreateRTV_ImportSerials_ToExistingRTV
	@OperatorCode = @OperatorCode
,	@SerialList = @SerialList
,	@RTVShipper = @RTVShipper
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult

select
	*
from
	dbo.shipper s
where
	s.id = @RTVShipper

select
	*
from
	dbo.shipper_detail sd
where
	sd.shipper = @RTVShipper

select
	*
from
	dbo.object o
where
	o.shipper = @RTVShipper
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
