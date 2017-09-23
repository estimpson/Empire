
/*
Create Procedure.MONITOR.dbo.usp_ShipRtv.sql
*/

use MONITOR
go

if	objectproperty(object_id('dbo.usp_ShipRtv'), 'IsProcedure') = 1 begin
	drop procedure dbo.usp_ShipRtv
end
go

create procedure dbo.usp_ShipRtv
	@OperatorCode varchar(5)
,	@RtvShipper integer
,	@LocationCode varchar(25)
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
/*  Make sure Rtv shipper has not already been shipped.  */
if exists (
		select
			1
		from
			dbo.shipper s
		where	
			s.id = @RtvShipper
			and s.date_shipped is not null ) begin

	set	@Result = 100
	rollback tran @ProcName
	return
end
---	</ArgumentValidation>

--- <Body>
declare	
	@DateStamp datetime
	
/*  Make sure all objects have a po number  */
declare @tempParts table
(
	Part varchar(25)
,	Po varchar(30)
,	Verified int
)

insert @tempParts
(
	Part
,	Po
,	Verified
)
select
	o.part
,	coalesce(max(o.po_number), '')
,	0
from
	dbo.object o
where 
	shipper = @RtvShipper
group by
	o.part
	
	
declare
	@ObjectPart varchar(25)
,	@ObjectPo varchar(30)
,	@Po varchar(30)	
	
select
	@ObjectPart = min(Part)
from
	@tempParts
where
	Verified = 0
	
select
	@ObjectPo = Po
from
	@tempParts
where
	Part = @ObjectPart
	

while ((select count(1) from @tempParts where Verified = 0) > 0) begin
	
	if (@ObjectPo = '') begin

		-- No PO for this serial/part, so search the po_header table for one
		if not exists
			(	select
					1
				from
					dbo.po_header ph
				where
					ph.blanket_part = @ObjectPart ) begin
		
			set	@Result = 999999
			RAISERROR ('No purchase order exists for part %s.  Cannot return to vendor.  Make sure it is a part that can be sent to Honduras.  Procedure %s.', 16, 1, @ObjectPart, @ProcName)
			rollback tran @ProcName
			return
		end
		else begin
			select
				@Po = max(ph.po_number)
			from
				dbo.object o
				join dbo.po_header ph
					on ph.blanket_part = o.part
			where
				o.part = @ObjectPart
				
			--- <Update>
			set	@TableName = 'dbo.object'

			update
				dbo.object
			set
				po_number = @Po
			where
				part = @ObjectPart
				and shipper = @RtvShipper
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
				
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error updating table %s with PO number in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
				rollback tran @ProcName
				return
			end
			--- </Update>
		end

	end
	
	update 
		@tempParts
	set 
		Verified = 1 
	where 
		Part = @ObjectPart
	
	select
		@ObjectPart = min(Part)
	from
		@tempParts
	where
		Verified = 0
		
	select
		@ObjectPo = Po
	from
		@tempParts
	where
		Part = @ObjectPart

end



/*  Ship out the RTV  */
--- <Call>	
set	@CallProcName = 'dbo.msp_shipout'
execute @ProcReturn = dbo.msp_shipout
	@RtvShipper
,	@DateStamp

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900501
	raiserror ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return
end
if	@ProcReturn != 0 begin
	set	@Result = 900502
	raiserror ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	rollback tran @ProcName
	return
end
---</Call>


/*
/*  Create the Honduras RMA  */
--- <Call>	
set	@CallProcName = 'eeh.dbo.eeisp_insert_EEH_RMA_from_EEI_RTV_withLocation_GlSegment'
execute @ProcReturn = eehsql1.EEH.dbo.eeisp_insert_EEH_RMA_from_EEI_RTV_withLocation_GlSegment
	@OperatorPWD = '5555'
,	@ShipperID = @RtvShipper
,	@LocationCode = @LocationCode
,	@Result = @Result out

set	@Error = @@Error
if	@Error != 0 begin
	set	@Result = 900503
	raiserror ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
	rollback tran @ProcName
	return
end
if	@ProcReturn != 0 begin
	set	@Result = 900504
	raiserror ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
	rollback tran @ProcName
	return
end
---</Call>
*/
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
