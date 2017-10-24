SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
begin tran 
exec [HN].[SP_Picklist_RF_SerialOnShipper_beta] 'cDOy',109408,'EEI',1,'S',37882578,0

Select * from object where	serial= 37882578

rollback
*/
CREATE PROC [HN].[SP_Picklist_RF_SerialOnShipper_beta]
	(
	 @Operator varchar(10),
	 @ShipperID int ,
	 @Plant varchar(10)='EEI', 
	 @IsFullStandardPack int = 1,
	 @Action varchar(1)='S',
	 @Serial int,
	 @Result int output)
AS
BEGIN

SET nocount ON
set	@Result = 999999
DECLARE @ProcName  sysname

set	@ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)  -- e.g. dbo.usp_Test

--<Tran Required=Yes AutoCreate=Yes>
	DECLARE	@TranCount SMALLINT
	SET	@TranCount = @@TranCount
	IF	@TranCount = 0 
		BEGIN TRANSACTION @ProcName
	ELSE
		SAVE TRANSACTION @ProcName
--</Tran>

--<Error Handling>
DECLARE @ProcReturn integer, @ProcResult integer
DECLARE @Error integer,	@RowCount integer

/*
@Action: S = Stage
@Action: U = UnStage
@Action: T = Transfer RAN
*/
--	Declarations:
	declare	@TranType char (1),
		@Remark varchar (10),
		@Notes varchar (50),
		@SerialPart varchar(25)
		print 0
	declare	@ShippingDock varchar (10),
		@ShippingDestination varchar(25)

--	Argument Validation:
--		Operator required:
	IF	NOT EXISTS
		(	SELECT 	1
			FROM	employee
			WHERE	operator_code = @Operator) 
			
	BEGIN
		SET	@Result = 60001
		RAISERROR ('Error:  Operator %s is not valid!', 16, 1, @Operator)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END

--		Serial required:
	IF	NOT EXISTS
		(	SELECT 	1
			FROM	object
			WHERE	serial = @Serial) 
	BEGIN

		SET	@Result = 100001
		RAISERROR ('Error:  Object %i does not exists', 16, 1,@Serial)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END
	
	Declare @PalletSerial int = null

	if exists( select	1
				from	object
				where	serial = @serial and type = 'S')
	begin
		set @PalletSerial = @serial

		if not exists( Select 1
						from object
						where	parent_serial = @serial and part <>'PALLET')
		BEGIN

			SET	@Result = 100001
			RAISERROR ('Error:  Pallet Serial %i is empty.', 16, 1,@serial)
			ROLLBACK TRAN @ProcName
			RETURN	@Result
		END
		
	end

	Set @SerialPart = isnull((Select Part
								from object
								where	serial = @Serial 
									and part !='PALLET'),NULL)

IF @Action='S'
BEGIN
	Create Table #ShipperSummary (
		Part varchar(25),
		Status varchar(15))

	Create table #ObjectInformation (
		Serial int primary key,
		Part varchar(25),
		Status varchar(1),
		Location varchar(25),
		Shipper int,
		Parent_serial int,
		StandardPack int,
		Quantity int,
		weeks_on_stock int)

	Insert into #ObjectInformation
	Select	Serial, object.Part, Status, Location, Shipper, Parent_Serial, Standard_Pack, Quantity, 
		weeks_on_stock=case when datediff(week,ObjectBirthday,getdate())>12 then 13 else datediff(week,ObjectBirthday,getdate()) end
	from	object
		left join part_inventory PInv
			 on object.part = PInv.part
		where	(Serial= @Serial
				 or Parent_Serial=@serial )
	
	if exists (
		Select 1
		from (Select	part, weekonstock, boxesPending
				from	[HN].[fn_PickList_ShipperDetail_ByShipper](@ShipperID, @Plant, @IsFullStandardPack,null)) Details
				inner join 
						(Select	Part,
								weeks_on_stock,
								Boxes = count(serial)
						from	#ObjectInformation
						group by Part, weeks_on_stock) Boxes
					on details.part = boxes.part
						and details.weekonstock = boxes.weeks_on_stock
				where	Boxes.boxes > details.boxesPending)
	BEGIN
		SET	@Result = 100001
		RAISERROR ('The Qty boxes picked exceed the boxes pending required', 16, 1)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END
	
	Insert into #ShipperSummary
	SELECT 	Part, Status
	FROM	[HN].[fn_PickList_ShipperSummary_ByShipper] ( @ShipperID, @plant, @IsFullStandardPack,@SerialPart)
	
	Declare @ListPart varchar(max)

	Select	@ListPart = coalesce(@ListPart + ', ' + part,  part)
	from (
		Select	distinct part
		from	#ObjectInformation object
		where	part not in (Select	Part
								from #ShipperSummary) and part !='PALLET') ListPartOutOfShipper
	
	if isnull(@ListPart,'') != ''
	BEGIN
		SET	@Result = 100001
		RAISERROR ('Parts: %s not belong to this shipper', 16, 1,@ListPart)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END

	set @ListPart = null

	Select	@ListPart = coalesce(@ListPart + ', ' + part,  part)
	from (
		Select	distinct part
		from	#ObjectInformation object
		where	part  in (Select	Part
								from #ShipperSummary
								where	status='Complete') and part !='PALLET') ListPartCompleteStatus
	
	if isnull(@ListPart,'') != ''
	BEGIN
		SET	@Result = 100001
		RAISERROR ('Parts: %s are completed in this shipper', 16, 1,@ListPart)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END

	set @ListPart = null

	Select	@ListPart = coalesce(@ListPart + ', ' + serial,  serial)
	from (
		Select	serial = convert(varchar,serial)
		from	#ObjectInformation object
		where	status='H' and part !='PALLET') ListPartOnHold
			
	if isnull(@ListPart,'') != ''
	BEGIN
		SET	@Result = 100001
		RAISERROR ('Serials: %s are On-Hold', 16, 1,@ListPart)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END

	set @ListPart = null

	Select	distinct @ListPart = coalesce(@ListPart + ', ' + serial,  serial)
	from (
		Select	serial = convert(varchar,serial)
		from	#ObjectInformation object
		where	Shipper is not null and part !='PALLET') ListSerialPicked
	
	if isnull(@ListPart,'') != ''
	BEGIN
		SET	@Result = 100001
		RAISERROR ('Serials: %s are stage in this or another ShipperID', 16, 1,@ListPart)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END

	if @IsFullStandardPack = 1
	begin
		set @ListPart = null

		Select	distinct @ListPart = coalesce(@ListPart + ', ' + serial,  serial)
		from (
			Select	serial = convert(varchar,serial)
			from	#ObjectInformation object
			where	part !='PALLET' and  isnull(StandardPack,0) <> quantity) ListSerialPicked

	
		if isnull(@ListPart,'') != ''
		BEGIN
			SET	@Result = 100001
			RAISERROR ('Serials: %s is/are out of standard pack and you choose ONLY USE FULL STANDARD PACK. If you want to pick this/those serial disabled that option.', 16, 1,@ListPart)
			ROLLBACK TRAN @ProcName
			RETURN	@Result
		END
	end 

	set @ListPart = null

	Select	distinct @ListPart = coalesce(@ListPart + ', ' + serial,  serial)
	from (
		Select	serial = convert(varchar,serial)
		from	#ObjectInformation object
		where	serial not in (	SELECT Serial
								from [HN].[fn_PickList_SerialDetail_ByShipper]( @ShipperID, @plant, @IsFullStandardPack,@SerialPart))
				and part !='PALLET') ListSerialPicked
	
	if isnull(@ListPart,'') != ''
	BEGIN
		SET	@Result = 100001
		RAISERROR ('Serials: %s is not in FIFO.', 16, 1,@ListPart)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END
		
	
	set	@TranType = 'T'
	set	@Remark = 'STAGE-BOX'
	set	@Notes = 'RFPicklist: Add a box to a shipper'

	--	I.	Update the object location and shipper.	
	select	@ShippingDock = shipping_dock,
			@ShippingDestination = destination
	from	shipper
	where	id = @ShipperID

	update	object
	set	last_date = GetDate (),
		operator = @Operator,
		last_time = GetDate (),
		Custom5= location,
		shipper = @ShipperID,
		show_on_shipper = case 
							when isnull(@PalletSerial,0) != 0 and part ='Pallet' 
								then  'Y'
							when isnull(@PalletSerial,0) = 0
								then  'Y'
							else null end,									
		parent_serial = case when part = 'Pallet' then null else @PalletSerial end,
		Destination = @ShippingDestination,
		Note= @Notes
	where	serial = @Serial or parent_serial = @Serial 

		set	@Error = @@Error
		if	@Error != 0 begin
			set	@Result = 999999
			rollback tran @ProcName			
			RAISERROR ('Error staging stage serial %s ', 16, 1)
			return @Result
		end

	--	II.	Insert audit trail.
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
		parent_serial,
		lot,
		weight,
		status,
		shipper,
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
		ObjectInformation.location,
		object.location,
		object.parent_serial,
		object.lot,
		object.weight,
		object.status,
		object.shipper,
		object.unit_measure,
		object.std_quantity,
		object.plant,
		@Notes,
		object.package_type,
		object.cost,
		object.user_defined_status,
		object.tare_weight
	from	object object
		inner join #ObjectInformation ObjectInformation
			on object.Serial = ObjectInformation.Serial
	
		set	@Error = @@Error
		if	@Error != 0 begin
			set	@Result = 999999
			rollback tran @ProcName			
			RAISERROR ('Error staging stage serial %s ', 16, 1)
			return @Result
		end

	
	Insert into HN.Picklist_RF_SerialPickedLog (
		Operator, 
		Serial, 
		LastAction,
		LastUpdateDT,
		LastOperatorAction,
		CreateDT,
		ShipperID)
	Select	@Operator, 
			object.serial,
			'S',
			NULL,
			NULL,
			Getdate(),
			@ShipperID
	from	object object
		inner join #ObjectInformation ObjectInformation
			on object.Serial = ObjectInformation.Serial

		set	@Error = @@Error
		if	@Error != 0 begin
			set	@Result = 999999
			rollback tran @ProcName			
			RAISERROR ('Error making serial picked log', 16, 1)
			return @Result
		end

END
ELSE
BEGIN
	IF  @Action='T'
	BEGIN
	declare @toloc varchar(20)
	set @toloc='RAN-'+ @Plant

				 execute	@ProcReturn = [INV].[USP_Inv_Transfer] 
					@Operator = @Operator
				   ,@Serial=@Serial
				   ,@Toloc=  @toloc
				   ,@ToSerial=NULL
				    ,@Note='',
					@Result = @ProcResult output
	

				set	@Error = @@error

				if @ProcResult != 0 begin

					set	@Result = @ProcResult
					rollback tran @ProcName
					return	@Result
				end		
				if @Error != 0 or @ProcReturn != 0 begin

					rollback tran @ProcName
					RAISERROR (@Result, 16, 1, @ProcName)
					return	@Result
				end

	END 
	ELSE  
	BEGIN

	set	@TranType = 'U'
	set	@Remark = 'UNSTAGE-BOX'
	set	@Notes = 'RFPicklist: Remove a box from shipper'

	--	I.	Update the object location and shipper.	
	
	if not exists (Select 1
					from object
					where	serial =@Serial
						and note like '%RFPicklist%') 
	BEGIN
		SET	@Result = 100001
		RAISERROR ('Serial: %i was not stage using RF-GUN, please use Shipping Dock to unstage.', 16, 1,@Serial)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END

	Declare @From_loc varchar(25)
	Select @From_loc = location
	from object
	where	serial = @serial

	
	--if not exists (Select	1
	--				from	object
	--				where	serial =@Serial
	--					and shipper = @ShipperID) 
	--BEGIN
	--	SET	@Result = 100001
	--	RAISERROR ('Serial: %i must be stage to proceed with this action.', 16, 1,@Serial)
	--	ROLLBACK TRAN @ProcName
	--	RETURN	@Result
	--END

	update	object
	set	last_date = GetDate (),
		operator = @Operator,
		last_time = GetDate (),
		location = isnull(nullif(custom5,''),location),
		shipper = NULL,
		show_on_shipper = 'N',
		parent_serial = @PalletSerial,
		Destination = NULL,
		Note= @Notes
	where	serial = @Serial 

		set	@Error = @@Error
		if	@Error != 0 begin
			set	@Result = 999999
			rollback tran @ProcName			
			RAISERROR ('Error staging stage serial %s ', 16, 1)
			return @Result
		end

	
	--	II.	Insert audit trail.
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
		parent_serial,
		lot,
		weight,
		status,
		shipper,
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
		from_location = @From_loc,
		to_location = isnull(nullif(custom5,''),location),
		object.parent_serial,
		object.lot,
		object.weight,
		object.status,
		object.shipper,
		object.unit_measure,
		object.std_quantity,
		object.plant,
		@Notes,
		object.package_type,
		object.cost,
		object.user_defined_status,
		object.tare_weight
	from	object object
	where object.Serial = @Serial
	
		set	@Error = @@Error
		if	@Error != 0 begin
			set	@Result = 999999
			rollback tran @ProcName			
			RAISERROR ('Error staging stage serial %s ', 16, 1)
			return @Result
		end

	if exists(Select	1
				from	HN.Picklist_RF_SerialPickedLog
				where	shipperId= @shipperID
					and Serial =@Serial)
	BEGIN
		
		UPDATE HN.Picklist_RF_SerialPickedLog
		SET	LastAction='U',
			LastUpdateDT=GETDATE(),
			LastOperatorAction= @Operator
		where	ShipperID=@ShipperID
			and Serial=@Serial

			set	@Error = @@Error
			if	@Error != 0 begin
				set	@Result = 999999
				rollback tran @ProcName			
				RAISERROR ('Error making serial picked log', 16, 1)
				return @Result
			end
	END
	ELSE BEGIN
			Insert into HN.Picklist_RF_SerialPickedLog (
				Operator, 
				Serial, 
				LastAction,
				LastUpdateDT,
				LastOperatorAction,
				CreateDT,
				ShipperID)
			Select	@Operator, 
					@Serial,
					'U',
					NULL,
					NULL,
					Getdate(),
					@ShipperID

			set	@Error = @@Error
			if	@Error != 0 begin
				set	@Result = 999999
				rollback tran @ProcName			
				RAISERROR ('Error making serial picked log', 16, 1)
				return @Result
			end
		END
END
END

	--II.	Reconcile shipper.
print @From_loc
execute	@ProcReturn = FT.ftsp_StagingReconcileShipper_Troy
	@ShipperID = @ShipperID,
	@Result = @ProcResult output
print @From_loc

set	@Error = @@error

if @ProcResult != 0 begin

	set	@Result = @ProcResult
	rollback tran @ProcName
	return	@Result
end		
if @Error != 0 or @ProcReturn != 0 begin

	rollback tran @ProcName
	RAISERROR (@Result, 16, 1, @ProcName)
	return	@Result
end

--<CloseTran Required=Yes AutoCreate=Yes>
IF	@TranCount = 0 BEGIN
	COMMIT TRANSACTION @ProcName
END
--</CloseTran Required=Yes AutoCreate=Yes>

--	III.	Success.
SET	@Result = 0
RETURN	@Result
END


GO
