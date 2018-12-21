SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
BEGIN TRAN

dECLARE @R INT 
EXEC [HN].[USP_INV_ShipOut] 'khm',115863, @R OUT
sELECT @R
ROLLBACK
*/


CREATE PROC [HN].[USP_INV_ShipOut]
	(
	 @Operator varchar(10),
	 @ShipperID int ,	 
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
		@SerialPart varchar(25),
		@partes VARCHAR(MAX)
	Declare @From_loc varchar(25)

	declare	@ShippingDock varchar (10),
		@ShippingDestination varchar(25)

		
--	Argument Validation:
--		Operator required:
	IF	NOT EXISTS
		(	SELECT 	1
			FROM	employee
			WHERE	operator_code = @Operator) BEGIN
		SET	@Result = 60001
		RAISERROR ('Error:  Operator %s is not valid!', 16, 1, @Operator)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END

--		Shipper required:
	 declare @bol_number  integer,
          @customerstatus char(1),
          @shipperstatus  char(1),
          @packlistprinted char(1),
          @bolprinted char(1),
		  @Freight_Type VARCHAR(30)
  
  -- check for customer status, shipper status, packlist printed
  SELECT @customerstatus=status_type, 
         @shipperstatus=status, 
         @packlistprinted=printed, 
         @bol_number=bill_of_lading_number,
		 @Freight_Type = b.freight_type
  FROM	customer_service_status as a
	INNER join shipper as b
		ON a.status_name = b.cs_status 
  WHERE b.id = @ShipperID
  
  IF (@@rowcount = 0)
  BEGIN

		SET	@Result = 100001
		RAISERROR ('Error:  Shipper %i does not exists or not found', 16, 1,@ShipperID)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
  END

   IF (@customerstatus<>'A')
  BEGIN

		SET	@Result = 100001
		RAISERROR ('Error:  Customer status is not approved', 16, 1)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
  END

   IF @shipperstatus in ('C','Z')
  BEGIN

		SET	@Result = 100001
		RAISERROR ('Error: shipper is closed by another user', 16, 1)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
  END

   IF @shipperstatus <>'S'
  BEGIN

		SET	@Result = 100001
		RAISERROR ('Error: shipper not staged', 16, 1)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
  END

   IF @packlistprinted <>'Y'
  BEGIN

		SET	@Result = 100001
		RAISERROR ('Error: pack list not printed', 16, 1)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
  END

  IF (@bol_number = 0) 
   BEGIN

		SET	@Result = 100001
		RAISERROR ('Error: Missing BOL, please generate', 16, 1)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
  END
  
  IF (@bol_number > 0) 
	begin 
		SELECT @bolprinted=bill_of_lading.printed  
		FROM bill_of_lading  
		WHERE (bill_of_lading.bol_number = @bol_number)
		
		IF (@bolprinted<>'Y')   -- check bol printed 
		BEGIN

			SET	@Result = 100001
			RAISERROR ('Error: BOL not printed', 16, 1)
			ROLLBACK TRAN @ProcName
			RETURN	@Result
		END		
	END 

 IF (@Freight_Type IS NULL)
    BEGIN
    	SET	@Result = 100001
		RAISERROR ('Error: Freight Type is null, please insert value', 16, 1)
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END

--Verificar que todas las partes tengan Precio

IF(	EXISTS (SELECT (part) FROM dbo.shipper_detail WHERE shipper=@ShipperID AND price IS NULL) )
	BEGIN

		SELECT @partes=part FROM dbo.shipper_detail WHERE shipper=@ShipperID AND price IS NULL
    	SET	@Result = 100001
		RAISERROR ('Error: Estas partes no tienen precio ', 16, 1,  @partes  )
		ROLLBACK TRAN @ProcName
		RETURN	@Result
	END

	--II.	Call shipper proc.

execute	@ProcReturn = [dbo].[msp_shipout]
	@Shipper = @ShipperID
	--,@Result = @ProcResult output


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
