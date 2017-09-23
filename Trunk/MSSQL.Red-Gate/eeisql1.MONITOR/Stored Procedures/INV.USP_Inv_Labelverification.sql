SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [INV].[USP_Inv_Labelverification]
	-- Add the parameters for the stored procedure here
	@Operator varchar(5),
	@Serial as int,
	@LabelRAN as varchar(20), 
	@LableSupplier as varchar(20),
	@LabelQuantity as numeric(20,6), 
	@LableCustomerPart as varchar(25),
	@result int OUT
AS
BEGIN

set nocount on
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@Procreturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer,
	@TranDT datetime,
	@Table varchar(20)

set	@ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)  -- e.g. dbo.usp_Test
--- </Error Handling>

--- <Tran required=Yes autoCreate=Yes tranDTParm=Yes>
declare	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end

set	@TranDT =  GetDate()

	--Obtener el numero de parte de Object 
	Declare  @EmpirePart as varchar(25),
			@CustomerPart varchar(25),
			@RAN varchar(20)

	declare @Destination as nvarchar(30),
			@ObjectQty numeric(20,6)

	set @result = 99999

	select	@ObjectQty = Quantity, @EmpirePart = object.Part, @CustomerPart = cross_ref , @RAN = custom1
	from	object
			join part on part.part = object.part
	where	serial = @Serial


	select	@Destination = Destination
	from	order_header
	where	order_no in (
						select	max(order_no)
						from	order_header
						where	blanket_part = @EmpirePart)

	if not exists(	select   1
				from	edi_setups  
				where	destination = @Destination
						and supplier_code = @LableSupplier ) begin
		set @Result = 2
		rollback tran @ProcName
		return @Result
	end

	if	@CustomerPart != @LableCustomerPart begin
		set @Result = 3
		rollback tran @ProcName
		return @Result
	end

	if	@ObjectQty != @LabelQuantity begin
		set @Result = 4
		rollback tran @ProcName
		return @Result
	end

	if	@RAN != @LabelRAN begin
		set @Result = 5
		rollback tran @ProcName
		return @Result
	end




	insert audit_trail
	(      serial, date_stamp, type, part, quantity, remarks, po_number, operator,
			from_loc, to_loc, lot, status, shipper, unit, std_quantity, cost, 
			custom1, custom2, custom3, custom4, custom5, plant,    notes, std_cost, 
			user_defined_status, parent_serial, object_type )
	select serial = serial, date_stamp = @TranDT, type = 'H', part,
			quantity, remarks = 'Verificate', po_number = po_number, operator = @Operator,
			from_loc = location, to_loc = location, lot = lot, status = status, shipper = shipper, 
			unit = unit_measure, std_quantity, cost, custom1, custom2, custom3, custom4, custom5, 
			plant, notes = 'Verification of Label readable.', std_cost, user_defined_status,
			parent_serial, object_type = type
	from   object
	where  serial = @Serial
		
	select	@Error = @@Error

	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error registering the Verification on AuditTrail [%s].', 16, 1,@ProcName )
		rollback tran @ProcName
		return	@Result
	end

		--<CloseTran Required=Yes AutoCreate=Yes>
	if	@TranCount = 0 begin
		commit transaction @ProcName
	end
	--</CloseTran Required=Yes AutoCreate=Yes>

	--	II.	Return.
	set	@Result = 0

	return @result
END
GO
