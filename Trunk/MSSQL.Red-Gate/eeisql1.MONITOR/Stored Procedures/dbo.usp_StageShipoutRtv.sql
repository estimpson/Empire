SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[usp_StageShipoutRtv]
	@OperatorCode varchar(5)
,	@RtvShipper integer
,	@Location varchar(25)
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
declare	
	@DateStamp datetime
	

-- Make sure objects have a po number
--
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
	

/*
-- Update objects with the RTV shipper
--
--- <Update>
set	@TableName = 'dbo.object'

update 
	dbo.object 
set 
	shipper = @RtvShipper, 
	show_on_shipper = 'Y'
where 
	shipper = @RmaShipper

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s with RTV shipper in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Update>



-- Update the RTV shipper as staged
--
--- <Update rows="1">
set	@TableName = 'dbo.shipper'

update 
	dbo.shipper
set 
	status = 'S'
where 
	id = @RtvShipper

select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount <> 1 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Rows updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Update>
*/


-- Ship out the RTV
--
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



-- Create Honduras RMA
--
--- <Call>	
set	@CallProcName = 'eeh.dbo.eeisp_insert_EEH_RMA_from_EEI_RTV_withLocation'
execute @ProcReturn = eehsql1.eeh.dbo.eeisp_insert_EEH_RMA_from_EEI_RTV_withLocation
	@OperatorPWD = '5555'
,	@ShipperID = @RtvShipper
,	@LocationCode = @Location
,	@Result = @Result out

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
