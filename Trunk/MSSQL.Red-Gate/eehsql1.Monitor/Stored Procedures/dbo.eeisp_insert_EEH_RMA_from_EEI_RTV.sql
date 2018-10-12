SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[eeisp_insert_EEH_RMA_from_EEI_RTV]
(	@OperatorPWD varchar(10),
	@ShipperID integer,
	@Result integer = 0 output
--<Debug>
	, @Debug integer = 0
--</Debug>
)
/*
Example:
begin transaction

declare	@ProcReturn int,
	@ProcResult int,
	@ShipperID int

execute	@ProcReturn = eeisp_insert_EEH_RMA_from_EEI_RTV
	@OperatorPWD = '7988',
	@ShipperID = 1,
	@Result = @ProcResult output

select	@ShipperID,
	@ProcReturn,
	@ProcResult

select	*
from		object
where	shipper = @ShipperID and Exists (select 1 from audit_trail where type = 'U' and audit_trail.serial = object.serial and audit_trail.shipper = convert(varchar(25), @shipperID))

rollback
:End Example
*/
as
set nocount on

declare	@Error int
set		@Result = 999999


declare	@ProcReturn integer,
	@ProcResult integer,
	@RowCount integer,
	@operator varchar(5),
	@nextshipperid integer,
	@TransitSQL nvarchar (1000),
	@TranCount smallint,
	@ParmDefinition nvarchar (1000),
	@NewRows int,
	@RTVRowsInAT int,
	@RTVRows int,
	@EEIRTVShipperID int



--		Operator required:
if	not exists
	(	select	1
		from	employee
		where	password = @OperatorPWD) begin

	RAISERROR ('Invalid Operator Password', 16, 1, @OperatorPWD)
	return	-1
end

Select	@operator = operator_code
from		employee
Where	password = @operatorPWD

--		EEI RTV Shipper must be valid.


set	@TransitSQL =N'
select	@EEIRTVShipperID = ID
from	OpenQuery (' + FT.fn_GetLinkedServer ('EEI') + ', ''
		select	ID = max (ID)
		from	Monitor.dbo.shipper where type = ''''V'''' and id =' + convert (varchar,@ShipperID ) +''')'

set	@ParmDefinition = N'@EEIRTVShipperID int output'

execute	@ProcResult = sp_executesql
	@TransitSQL,
	@ParmDefinition,
	@EEIRTVShipperID output

set	@Error = @@Error

if	@ProcResult != 0 or @Error != 0 or isnull (@EEIRTVShipperID, -1) !> 0 begin
	raiserror ('Unable to verify valid EEI RTV...', 16, 1, @ShipperID)
	return -1
end

Truncate table	RTVaudit_trail
set		@Error = @@Error
Select	@RTVRows  = count(1)
from		RTVaudit_trail


if	@Error != 0  or @RTVRows>0 begin
	raiserror ('Unable to clear last EEI RTV...', 16, 1, @ShipperID)
	return -1
end


set	@TransitSQL =N'Insert	RTVaudit_trail 
select	*
from	OpenQuery (' + FT.fn_GetLinkedServer ('EEI') + ', ''
		select	serial,
				date_stamp,
				type,
				part,
				quantity,
				''''RTV'''',
				price,
				customer,
				operator,
				from_loc,
				to_loc,
				on_hand,
				weight,
				''''H'''','''''+convert (varchar,@ShipperID )+''''',
				'''''+convert (varchar,@ShipperID )+''''',
				std_quantity,
				cost,
				''''EEH'''',
				notes,
				''''12'''',
				std_cost,
				''''On Hold'''',
				''''N'''',
				parent_serial,
				''''EEI-Troy'''',
				part_name
	from	 Monitor.dbo.audit_trail
		where	type = ''''V'''' and shipper ='+''''''+convert (varchar,@ShipperID )+'''''' +''') 
set	@NewRows = @@RowCount
'

set	@ParmDefinition = N'@NewRows int output'

execute	@ProcResult = sp_executesql
	@TransitSQL,
	@ParmDefinition,
	@NewRows output

set	@Error = @@Error

if	@ProcResult != 0 or @Error != 0 begin
	raiserror ('Unable to get RTV serials...', 16, 1)
	return -1
end
if	isnull (@NewRows, -1) !> 0 begin
	raiserror ('No valid RTV serials...', 10, 1)
	return 100
end


Select	 @RTVRowsInAT =count(1)
from		RTVaudit_trail
where	exists (	Select	1 
				from		audit_trail 
				where	audit_trail.serial = RTVaudit_trail.serial and
						audit_trail.type = 'U' and
						(audit_trail.shipper = convert (varchar(15),@nextshipperid) or audit_trail.origin = convert (varchar(15), @ShipperID)))

if	isnull ( @RTVRowsInAT , -1) > 0 begin
	raiserror ('RTV already Processed...', 10, 1)
	return 100
end


begin transaction CreateRMA

--Get next shipper id and invoice Number
Select	@nextshipperid  = shipper
from		parameters
--Increment shipper and invoice Number
update	parameters
set		shipper = @nextshipperid+1,
		next_invoice=@nextshipperid+1

select	@Error = @@Error,
	@RowCount = @@Rowcount


if	@Error != 0  or @RowCount !> 0 begin
	set	@Result = 999999
	RAISERROR ('Failed to Increment Shipper%S', 16, 1, '-Auto Create RMA Process')
	rollback tran CreateRMA
	return	@Result
end
--Insert Audit Trail
Insert	audit_trail (	serial,
					date_stamp,
					type,
					part,
					quantity,
					remarks,
					price,
					customer,
					operator,
					from_loc,
					to_loc,
					on_hand,
					weight,
					status,
					shipper,
					origin,
					std_quantity,
					cost,
					plant,
					notes,
					gl_account,
					std_cost,
					user_defined_status,
					posted,
					parent_serial,
					destination,
					part_name
					)
Select				serial,
					getdate(),
					'U',
					RTVaudit_trail.part,
					quantity,
					'RMA',
					part_standard.price,
					customer,
					operator,
					from_loc,
					isNULL((Select max(location.code) from location where code like '%RTV%' and isNULL(secured_location, 'N') = 'Y' and plant like '%TRAN%'), 'INTRANSIT'),
					(Select sum(quantity) from object where part_standard.part = RTVaudit_trail.part and status = 'A') ,
					weight,
					'H',
					convert(varchar(25), @nextshipperid),
					origin,
					std_quantity,
					part_standard.material_cum,
					plant,
					notes,
					gl_account,
					part_standard.material_cum,
					user_defined_status,
					posted,
					parent_serial,
					destination,
					part_name
From				RTVaudit_trail
join					part_standard on RTVaudit_trail.part = part_standard.part

select	@Error = @@Error,
	@RowCount = @@Rowcount


if	@Error != 0  or @RowCount !> 0 begin
	set	@Result = 999999
	RAISERROR ('Failed to Create Audit Trail%S', 16, 1, '-Auto Create RMA Process')
	rollback tran CreateRMA
	return	@Result
end
--insert object
Insert	object (		serial,
					last_date,
					last_time,
					type,
					part,
					quantity,
					std_quantity,
					unit_measure,
					note,
					operator,
					location,
					Status,
					destination,
					origin,
					cost,
					std_cost,
					parent_serial,
					plant,
					user_defined_status
					)
Select				serial,
					getdate(),
					getdate(),
					NULL ,
					RTVaudit_trail.part ,
					quantity ,
					std_quantity,
					'EA',
					rma ,
					operator ,
					isNULL((Select max(location.code) from location where code like '%RTV%' and isNULL(secured_location, 'N') = 'Y' and plant like '%TRAN%'), 'INTRANSIT'),
					'H',
					destination,
					shipper,
					part_standard.material_cum,
					part_standard.material_cum,
					parent_serial,
					'EEH',
					'On Hold'
	
From				RTVaudit_trail
join					part_standard on RTVaudit_trail.part = part_standard.part

select	@Error = @@Error,
	@RowCount = @@Rowcount


if	@Error != 0  or @RowCount !> 0 begin
	set	@Result = 999999
	RAISERROR ('Failed to Create Objects%S', 16, 1, '-Auto Create RMA Process')
	rollback tran CreateRMA
	return	@Result
end



--Get Last Shipper for RMA Parts

Select	max(shipper) shipper,
		part_original
into		#LastShipperforRMA
from		shipper_detail
join		shipper on shipper_detail.shipper = shipper.id
where	shipper_detail.part_original in (Select part from RTVAudit_Trail) and isNULL(shipper.type, 'A')  != 'R'
group	by	part_original

--Insert Shipper
Insert	shipper(	id,
				destination,
				ship_via,
				status,
				date_shipped,
				customer,
				staged_objs,
				plant,
				type,
				invoice_number,
				time_shipped,
				invoice_printed,
				terms,
				tax_rate,
				date_stamp,
				currency_unit,
				cs_status,
				operator,
				pro_number
				
)
Select	@nextshipperid,
			'EEI-TROY',
			'SBRD',
			'O',
			getdate(),
			'EEI',
			(Select count(1) from RTVAudit_trail),
			'EEH',
			'R',
			@nextshipperid,
			getdate(),
			'Y',
			'NET 30',
			0,
			getdate(),
			'USD',
			'Approved',
			@operator,
			convert(varchar(25), @EEIRTVShipperID)

select	@Error = @@Error,
	@RowCount = @@Rowcount


if	@Error != 0  or @RowCount !> 0 begin
	set	@Result = 999999
	RAISERROR ('Failed to Create RMA Shipper%S', 16, 1, '-Auto Create RMA Process')
	rollback tran CreateRMA
	return	@Result
end

-- Insert Shipper Detail
select		Part ,
			PartName,
			OrderNo ,
			CustomerPart,
			CustomerPO,
			ReleaseNo,
			DueDate,
			Price ,
			Unit,
			WeekNo ,
			AlternatePrice,
			RTVQty,
			BoxCount,
			OldShipper
into #RMADetail
		from	( Select	RTVAudit_trail.part Part,
					Part.name PartName,
					shipper_detail.order_no OrderNo,
					shipper_detail.customer_part CustomerPart,
					shipper_detail.customer_po CustomerPO,
					shipper_detail.release_no ReleaseNo,	
					getdate() DueDate,
					shipper_detail.price Price,
					shipper_detail.alternative_unit Unit,
					DateDiff (week,
					DateAdd (year,
						DateDiff (year,
							parameters.fiscal_year_begin,
							getdate()),
						parameters.fiscal_year_begin),
					getdate()) + 1 WeekNo,
					shipper_detail.alternate_price AlternatePrice,
					sum(RTVAudit_trail.quantity) RTVQty,
					count(1) BoxCount,
					#LastShipperforRMA.shipper OldShipper
					
					
		From	RTVAudit_trail
			join part on RTVAudit_trail.part = part.part
			left	outer join	#LastShipperforRMA on part.part = #LastShipperforRMA.part_original
			left outer join shipper_detail on #LastShipperforRMA.part_original = shipper_detail.part_original and #LastShipperforRMA.shipper = shipper_detail.shipper
			cross join parameters
		group by
			RTVAudit_trail.part,
			Part.name,
			shipper_detail.order_no,
			shipper_detail.customer_part,
			shipper_detail.customer_po,
			shipper_detail.release_no,	
			shipper_detail.date_shipped,
			shipper_detail.price,
			shipper_detail.alternative_unit,
			DateDiff (week,
				DateAdd (year,
					DateDiff (year,
						parameters.fiscal_year_begin,
							getdate()),
						parameters.fiscal_year_begin),
					getdate()) + 1,
			shipper_detail.alternate_price,
			#LastShipperforRMA.shipper) GroupedRTVAudit_trail

insert	shipper_detail
(	shipper,
	part,
	qty_original,
	alternative_qty,
	qty_required,
	qty_packed,
	order_no,
	customer_po,
	release_no,
	release_date,
	price,
	alternative_unit,
	week_no,
	taxable,
	price_type,
	customer_part,
	part_name,
	part_original,
	alternate_price,
	suffix,
	account_code,
	type,
	boxes_staged,
	old_shipper)
select		@nextshipperid,
			Part+'-1' ,
			RTVQty*-1,
			RTVQty*-1,
			RTVQty*-1,
			RTVQty*-1,
			OrderNo ,
			CustomerPO,
			ReleaseNo,
			DueDate,
			Price ,
			Unit,
			WeekNo ,
			'N',
			'P',
			CustomerPart,
			PartName,			
			Part,
			AlternatePrice,
			1,
			'4011',
			'I',
			BoxCount,
			OldShipper
from			 #RMADetail

select	@Error = @@Error,
	@RowCount = @@Rowcount


if	@Error != 0  or @RowCount !> 0 begin
	set	@Result = 999999
	RAISERROR ('Failed to Create RMA Shipper Detail %S', 16, 1, '-Auto Create RMA Process')
	rollback tran CreateRMA
	return	@Result
end
--</CloseTran Required=Yes AutoCreate=Yes>

commit transaction CreateRMA


--	Success.
set	@Result = 0
return	@Result

GO
