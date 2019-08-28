SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TROY_MON_SavePOHeader]
		(@WOEngineerID int,    
		 @PONumber int out,
		 @result int out)
        
/*
begin tran

declare	@PONumber int,@result int, @WOEngineerID int, @Part varchar(25)

set @WOEngineerID=12941   
set @PONumber = 0
set @result = 0

select @Part=Part from EEHSQL1.EEH.dbo.ENG_WOEngineer where WOEngineerID=@WOEngineerID

exec dbo.SP_TROY_MON_SavePOHeader
	@WOEngineerID=@WOEngineerID,
	@PONumber=@PONumber out ,
	@result=@result out


select	RESULT=@result,PO=@PONumber

if @PONumber >0
begin
	SELECT	* from	po_header where	po_number = @PONumber
	SELECT	* FROM	part_standard WHERE Part =@Part
	SELECT	* FROM	part_online WHERE Part =@Part
	SELECT	* FROM	part_vendor WHERE Part =@Part and vendor='EEH'
	SELECT	* FROM	part_vendor_price_matrix WHERE Part =@Part and vendor='EEH'
end

rollback tran

*/
as

DECLARE	@description varchar(100)
DECLARE  @trancount smallint
DECLARE @CallProcName sysname, @TableName sysname, @ProcName sysname

SET   @result = 999999
SET   @ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)  
SET   @trancount = @@trancount

IF    @trancount = 0 
      begin transaction @ProcName
ELSE
      save transaction @ProcName

DECLARE @procreturn integer, @procresult integer
DECLARE @error integer, @rowcount integer

DECLARE @vendor_code varchar(10), 
		@Type varchar(1), 
		@blanket_part varchar(25),
		@terms varchar(20), 
		@fob varchar(20), 
		@ship_via varchar(15),
		@ship_to_destination varchar(25),
		@status varchar(1),
        @plant varchar(10),  
		@freight_type varchar(20),
		@ship_type varchar(10),
		@currency_unit varchar(3),
		@Buyer varchar(15),
		@Trusted varchar(1),
		@PPAP	VARCHAR(1),
		@IDMS	VARCHAR(1),
		@release_control varchar(1),
		@blanket_frequency	varchar(15),
		@TranDT	datetime,
		@TransferPrice numeric(18,2),
		@ContPrice numeric(18,4),
		@AutomaticTroyPO int

		--TextProdPrice.Text * 0.83
SET @vendor_code= 'EEH'
SET @Type='B'
SET @terms='NET 30'
SET @fob='SHIP POINT'
SET @ship_via='CLAM'
SET @ship_to_destination='EEI'
SET @plant='EEI'
SET @freight_type='Third Party Billing'
SET @ship_type='Normal'
SET @Trusted ='N'
SET	@PPAP='N'
SET @IDMS='N'
SET @release_control='A'
SET @blanket_frequency='T'
SET @TranDT=GETDATE()
SET @status ='A'

SELECT	@blanket_part=Part,@Buyer=EEIScheduler,@ContPrice=ContPrice,@TransferPrice=round(ContPrice*0.83,2),@AutomaticTroyPO=isnull(AutomaticTroyPO,0)
FROM	eehsql1.EEH.dbo.ENG_WOEngineer
WHERE	WOEngineerID=@WOEngineerID

--AutomaticTroyPO
IF (@AutomaticTroyPO > 0) AND NOT EXISTS (SELECT 1 
										  from	po_header 
										  WHERE BLANKET_Part =@blanket_part )
BEGIN

	if	exists(	select	1
				from	po_header
				where	po_number = @AutomaticTroyPO ) begin
		SET	@Result = 999999
		rollback tran @ProcName
		RAISERROR ('The WOEngineer have PO created %i.', 16, 1,@AutomaticTroyPO)
		return	@Result	
	end

END


if	not exists(	select	1
				from	vendor
				where	code = @vendor_code ) begin
	SET	@Result = 999999
	rollback tran @ProcName
	RAISERROR ('The vendor %s does not exists.', 16, 1,@vendor_code)
	return	@Result	
end


if	@Type = 'B' begin
	if	not exists(	select	1
					from	part
					where	part = @blanket_part ) begin
		SET	@Result = 999999
		rollback tran @ProcName
		RAISERROR ('The part %s does not exists.', 16, 1,@blanket_part)
		return	@Result	
	end
	
	SELECT	@description = name FROM part WHERE part = @blanket_part
end
 
 if exists (select	1
			from	po_header
			where	blanket_part=@blanket_part)
begin
	
	select	top 1 @PONumber=po_number
	from	po_header
	where	blanket_part=@blanket_part

end

if @PONumber=0 begin
	--STEP 1. create PO with wo engineer information and static data request by Irene Aragon	

    SELECT  @PONumber = purchase_order, @currency_unit = base_currency  
	FROM	parameters WITH (TABLOCKX)
	   
    WHILE exists
          (		select	po_number
                from	po_header 
                where	po_number = @PONumber
          )begin
         SET @PONumber =   @PONumber + 1 
    END
  
	

    SET   @TableName = 'parameters'
    UPDATE parameters
    SET   purchase_order = @PONumber + 1

    select @Error = @@Error,    
		   @RowCount = @@Rowcount
	
    if    @Error != 0 begin
          set   @Result = 999999
          RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
          rollback tran @ProcName
          return @Result
    end
    if    @RowCount != 1 begin
          set   @Result = 999999
          RAISERROR ('Error updating table %s in procedure %s.  Rows inserted: %d.  Expected rows: %d.', 16, 1, @TableName, @ProcName, @RowCount, 1)
          rollback tran @ProcName
          return @Result
    end
		
	INSERT INTO po_header
              (	po_number, vendor_code, po_date,terms, fob, ship_via, 
				ship_to_destination,status,	type, description, plant, 
				freight_type, buyer, blanket_frequency, blanket_part, 
				ship_type, release_control, trusted, currency_unit, cum_received_qty,PPAP,IDMS)	
	SELECT		@PONumber, upper(@vendor_code),@TranDT, @terms, @fob, @ship_via, 
				@ship_to_destination,@status,@Type,	@description,@plant,
				@freight_type,@Buyer,@blanket_frequency,case when @Type = 'N' then null else rtrim(upper(@blanket_part)) end,
				@ship_type, @release_control, @Trusted,@currency_unit ,0,@PPAP,@IDMS
			
		
    SELECT	@Error = @@Error,    
			@RowCount = @@Rowcount
	SET		@TableName = 'po_header'
    IF    @Error != 0 begin
          SET   @Result = 999999
          RAISERROR ('Error inserting table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
          rollback tran @ProcName
          RETURN @Result
    END
    
    if    @RowCount != 1 begin
          set   @Result = 999999
          RAISERROR ('Error inserting table %s in procedure %s.  Rows inserted: %d.  Expected rows: %d.', 16, 1, @TableName, @ProcName, @RowCount, 1)
          rollback tran @ProcName
          return @Result
    end

	--STEP 2. Update Cost and material cum with trasnfer price in part standard
	--2.1 update material
	UPDATE	part_standard
	SET		material=@TransferPrice,
			cost_changed_date=GETDATE()		
	WHERE	part=@blanket_part

	SET @Error = @@Error 
	SET @RowCount = @@Rowcount
	SET	@TableName = 'part_standard'
	
	IF    @Error != 0 begin
		SET   @Result = 999999
		RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		RETURN @Result
	END

	IF    @RowCount != 1 begin
		SET   @Result = 999999
		RAISERROR ('Error updating table %s in procedure %s.  Rows inserted: %d.  Expected rows: %d.', 16, 1, @TableName, @ProcName, @RowCount, 1)
		rollback tran @ProcName
		RETURN @Result
	END

	IF	not exists(	select	1
					from	ft.xrt
					where	toppart=@blanket_part ) begin 
		execute FT.ftsp_IncUpdXRt
	end

	--2.2 CALL RollUp Part
	exec msp_calc_costs_FT @blanket_part
	


	--STEP 3. Update Dfeault PO with the New part in Part ONline
	UPDATE	part_online
	SET		default_po_number=@PONumber
	where	part=@blanket_part

	SET @Error = @@Error 
	SET @RowCount = @@Rowcount
	SET	@TableName = 'part_online'
	
	IF    @Error != 0 begin
		SET   @Result = 999999
		RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		RETURN @Result
	END

	IF    @RowCount != 1 begin
		SET   @Result = 999999
		RAISERROR ('Error updating table %s in procedure %s.  Rows inserted: %d.  Expected rows: %d.', 16, 1, @TableName, @ProcName, @RowCount, 1)
		rollback tran @ProcName
		RETURN @Result
	END

	--STEP 4. Create PartVendor with blanket part, and created in Matrix Price
	--4.1 PART VENDOR
	IF NOT exists (	SELECT	1
					FROM	part_vendor
					WHERE	part=@blanket_part and vendor=@vendor_code
	)BEGIN
		
		INSERT INTO part_vendor (part, vendor, vendor_part, qty_over_received,receiving_um)
		SELECT	@blanket_part, @vendor_code ,@blanket_part, 0.00, 'EA'

		SELECT	@Error = @@Error,    
				@RowCount = @@Rowcount
		SET		@TableName = 'part_vendor'
		IF    @Error != 0 begin
				SET   @Result = 999999
				RAISERROR ('Error inserting table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
				rollback tran @ProcName
				RETURN @Result
		END
    
		if    @RowCount != 1 begin
				set   @Result = 999999
				RAISERROR ('Error inserting table %s in procedure %s.  Rows inserted: %d.  Expected rows: %d.', 16, 1, @TableName, @ProcName, @RowCount, 1)
				rollback tran @ProcName
				return @Result
		end
	END

	--4.2 PART VENDOR PRICE MATRIX 
	IF NOT exists (	SELECT	1
					FROM	part_vendor_price_matrix
					WHERE	part=@blanket_part and vendor=@vendor_code
	)BEGIN
		
		INSERT INTO part_vendor_price_matrix (part, vendor, price, break_qty,alternate_price)
		SELECT	@blanket_part, @vendor_code , @TransferPrice, 1.00,@TransferPrice

		SELECT	@Error = @@Error,    
				@RowCount = @@Rowcount
		SET		@TableName = 'part_vendor_price_matrix'
		IF    @Error != 0 begin
				SET   @Result = 999999
				RAISERROR ('Error inserting table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
				rollback tran @ProcName
				RETURN @Result
		END
    
		if    @RowCount != 1 begin
				set   @Result = 999999
				RAISERROR ('Error inserting table %s in procedure %s.  Rows inserted: %d.  Expected rows: %d.', 16, 1, @TableName, @ProcName, @RowCount, 1)
				rollback tran @ProcName
				return @Result
		end
	END
	ELSE BEGIN

		UPDATE part_vendor_price_matrix
		SET		Price=@TransferPrice,
				alternate_price=@TransferPrice,
				break_qty=1.00
		WHERE	part=@blanket_part and vendor=@vendor_code
				
		SET @Error = @@Error 
		SET @RowCount = @@Rowcount
		SET	@TableName = 'part_vendor_price_matrix'
	
		IF    @Error != 0 begin
			SET   @Result = 999999
			RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			rollback tran @ProcName
			RETURN @Result
		END

		IF    @RowCount != 1 begin
			SET   @Result = 999999
			RAISERROR ('Error updating table %s in procedure %s.  Rows inserted: %d.  Expected rows: %d.', 16, 1, @TableName, @ProcName, @RowCount, 1)
			rollback tran @ProcName
			RETURN @Result
		END

	END


end

if    @TranCount = 0 begin
    commit transaction @ProcName
end

set @PONumber=@PONumber
set @Result = 0
return @Result



GO
