SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Heber Murillo
-- Create date: 02-19-2018
-- Description:	genera un nuevo numero de BOL
-- =============================================

/*
BEGIN TRAN

dECLARE @R INT 
EXEC [HN].[USP_INV_ShippingDock_NewBOL] 116169, @R OUT
sELECT @R
ROLLBACK
*/


CREATE procedure [HN].[USP_INV_ShippingDock_NewBOL]
(	@ShipperID INT,
    @Result int output)
AS


DECLARE @newbol int

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
	DECLARE @Error integer,	@RowCount INTEGER


	EXEC [dbo].[msp_get_next_bol]@newbol
	
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


		INSERT INTO dbo.bill_of_lading
		(
			bol_number,
			scac_transfer,
			scac_pickup,
			trans_mode,
			equipment_initial,
			equipment_description,
			status,
			printed,
			gross_weight,
			net_weight,
			tare_weight,
			destination,
			lading_quantity,
			total_boxes
		)select	bol_number = @newbol ,
			scac_transfer = convert(varchar (35), shipper.ship_via),
			scac_pickup = convert(varchar (35), isnull (shipper.bol_carrier, shipper.ship_via)),
			trans_mode = shipper.trans_mode,
			equipment_initial = convert(varchar (10), null),
			equipment_description = convert(varchar (10), null),
			status = 'O',
			printed = 'N',
			gross_weight = convert(numeric (7,2), shipper.gross_weight),
			net_weight = convert(numeric (7,2), shipper.net_weight),
			tare_weight = convert(numeric (7,2), shipper.tare_weight),
			destination = isnull(shipper.bol_ship_to, shipper.destination),
			lading_quantity = (select convert(numeric (20,6), count (o.serial)) from object o where shipper.id = o.shipper and parent_serial is null),
			total_boxes = convert(numeric (20,6), shipper.staged_objs)
		from	shipper
			left outer join bill_of_lading on convert (int, shipper.bill_of_lading_number) = bill_of_lading.bol_number
		where	shipper.id = @ShipperID
		
		SET	@Error = @@Error
			if	@Error != 0 begin
			set	@Result = 900501
			RAISERROR ('Error inserting in %s.  Error: %d while inserting row to table', 16, 1, @ProcName, @Error, 'bill_of_lading')
			rollback tran @ProcName
			return @Result
		END
        
		UPDATE Shipper SET bill_of_lading_number=@newbol WHERE id=@ShipperID
		set	@Error = @@Error
			if	@Error != 0 begin
			set	@Result = 90001
			RAISERROR ('Error updating bill of lading',16, 1, @ProcName, @Error)
			rollback tran @ProcName
			return @Result
		END
        



IF	@TranCount = 0 BEGIN
	COMMIT TRANSACTION @ProcName
END
--</CloseTran Required=Yes AutoCreate=Yes>

--	III.	Success.
SET	@Result = 0
RETURN	@Result
END

GO
