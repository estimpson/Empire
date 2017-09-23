SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [HN].[HCSP_Inv_CreateSuperObject]
(	@Operator varchar (10),
	@Pallets tinyint,
	@Result integer = 0 output,
	@Debug integer = 0, 
	@LabelFormat varchar(25) = null,
	@PrintQueue varchar(25) = null,
	@Location varchar(10) = null,
	@FirtsPallet integer out
--</Debug>
)
as
/*
Example:
begin transaction

declare	@ProcReturn int,
	@ProcResult int,
	@NextSerial int,
	@LabelFormat varchar(25) = null,
	@PrintQueue varchar(25),
	@Location varchar(10),
	@FirtsPallet integer 
	
select	@NextSerial = next_serial
from	parameters

execute	@ProcReturn = FT.ftsp_PrestagingCreatePallets
	@Operator = 'MON',
	@Pallets = 2,
	@Result = @ProcResult output,
	@LabelFormat = 'L_CKT_WIP',
	@PrintQueue = '127.0.0.1',
	@Location = 'PCB-Bodega',
	@FirtsPallet = @FirtsPallet out

select	@ProcReturn,
	@ProcResult,@FirtsPallet

select	*
from	object
where	serial >= @NextSerial


select * from PrintQueue 
where SerialNumber >= @NextSerial
rollback
:End Example
*/
set nocount on
set	@Result = 999999

--<Tran Required=Yes AutoCreate=Yes>
declare	@TranCount smallint
set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin transaction PrestagingCreatePallets
end
else	begin
	save transaction PrestagingCreatePallets
end
--</Tran>

--	Argument Validation:
--	Operator required:
if	not exists
	(	select	1
		from	employee
		where	operator_code = @Operator) begin

	set	@Result = 60001
	rollback tran PrestagingCreatePallets
	RAISERROR (@Result, 16, 1, @Operator)
	return	@Result
end

--		Print queue required.

	if @Location is null begin
		set	@Location = FT.fn_VarcharGlobal ('EEI-STAGE')
	end

--	Declarations:
declare	@PalletSerial integer,
	@PalletCount integer,
	@Part varchar (25),
	@LotNumber integer,
	@LotBaseValue integer,
	@LotChecksum integer,
	@LotHumanReadable char (3),
	@LotSkipCount integer,
	@WeekNo integer,
	@Unit char (2),
	@Status char (1),
	@UserStatus varchar (10),
	@ObjectType char (1),
	@TranType char (1),
	@Remark varchar (10),
	@Notes varchar (50)

set	@Part = 'PALLET'
set	@WeekNo = DatePart (week, GetDate ())
set	@Unit = 'EA'
set	@Status = 'A'
set	@UserStatus = 'Approved'
set	@ObjectType = 'S'
set	@TranType = 'P'
set	@Remark = 'PALLET'
set	@Notes = 'New shipper pallet.'

--	I.	Get a block of serial numbers.
--<Debug>
if	@Debug & 1 = 1 begin
	print	'I.	Get a block of serial numbers.'
end
--</Debug>
select	@PalletSerial = next_serial
from	parameters with (TABLOCKX)



while	exists
	(	select	serial
		from	object
		where	serial between @PalletSerial and @PalletSerial + @Pallets - 1 ) or
	exists
	(	select	serial
		from	audit_trail
		where	serial between @PalletSerial and @PalletSerial + @Pallets - 1 ) begin

	set	@PalletSerial = @PalletSerial + 1
end

update	parameters
set	next_serial = @PalletSerial + @Pallets


--	III.	Loop to generate pallets.
set	@PalletCount = 0


while	@PalletCount < @Pallets begin

--		B.	Create object.
	insert	object
	(	serial,
		part,
		lot,
		location,
		last_date,
		unit_measure,
		operator,
		status,
		plant,
		last_time,
		user_defined_status,
		type )
	select	@PalletSerial + @PalletCount,
		@Part,
		lot = '',
		location.code,
		GetDate (),
		@Unit,
		@Operator,
		@Status,
		location.plant,
		GetDate (),
		@UserStatus,
		@ObjectType
	from	location
	where	location.code = @Location


--		C.	Create pallet.
	insert	audit_trail
	(	serial,
		date_stamp,
		type,
		part,
		quantity,
		remarks,
		operator,
		from_loc,
		to_loc,
		lot,
		weight,
		status,
		unit,
		std_quantity,
		plant,
		notes,
		package_type,
		std_cost,
		user_defined_status,
		tare_weight )
	select	object.serial,
		object.last_date,
		@TranType,
		object.part,
		object.quantity,
		@Remark,
		object.operator,
		object.location,
		object.location,
		object.lot,
		object.weight,
		object.status,
		object.unit_measure,
		object.std_quantity,
		object.plant,
		@Notes,
		object.package_type,
		object.cost,
		object.user_defined_status,
		object.tare_weight
	from	object object
	where	object.serial = @PalletSerial + @PalletCount
	
	
--		D.	Add serial to print queue.
if	@PrintQueue is not null begin
	insert	PrintQueue
	(	DateStamp,
		SerialNumber,
		PrintServer,
		Printed,
		LabelFormat) 
	select	date_stamp = getdate (),
		serial_number = @PalletSerial + @PalletCount,
		server_name = @PrintQueue,
		printed = 0,
		(case when @LabelFormat is null then 'PALLET' else @LabelFormat end)
	
end
	
	select	@PalletCount = @PalletCount + 1
	set	@FirtsPallet = @PalletSerial 
end

--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction PrestagingCreatePallets
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	IV.	Success.
set	@Result = 0
return	@Result
GO
