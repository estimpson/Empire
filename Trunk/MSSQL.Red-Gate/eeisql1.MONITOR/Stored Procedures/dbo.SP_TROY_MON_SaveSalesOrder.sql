SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TROY_MON_SaveSalesOrder]
		(@SelectSQL varchar(max),
		 @User	varchar(15),
		 @OrdersCountInserted int out,		
		 @result int out)
        
/*
begin tran

declare	@SelectSQL varchar(max), @result int, @OrdersCountInserted  int

set @result = 0
set @SelectSQL='Select Destination=''NALFLORA#3'', Customer=''NALFLORA'', PartNumber=''NAL1314-HA00'', STDPACK=125, CustomerPO=''Free Samples'', Price=0.000001, CreateBy=''424'', WOEngineerID=13318, Plant=''EEI'''

exec dbo.SP_TROY_MON_SaveSalesOrder
	@SelectSQL=@SelectSQL,
	@User='MON',
	@OrdersCountInserted =@OrdersCountInserted  out,
	@result=@result out


select	result=@result,orders=@OrdersCountInserted 


SELECT	top (@OrdersCountInserted) * from Monitor.dbo.order_header order by order_date desc

rollback tran

*/
as

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
DECLARE @error integer

DECLARE @TranDT	datetime
SET @TranDT=GETDATE()


create table ##UploadData
(		ID int identity(1,1),
		Destination varchar(20),
		Customer varchar(10),
		PartNumber varchar(25),
		STDPack decimal(20,6),
		CustomerPO varchar(20),
		Price decimal(20,6),
		Plant varchar(10),
		OperatorCode varchar(15),
		WOEngineerID	int
)

declare @InsertSQL varchar(max)
declare @ExecuteSQL varchar(max)

set @InsertSQL='INSERT INTO ##UploadData(Destination,Customer,PartNumber,STDPack,CustomerPO,Price,OperatorCode,WOEngineerID,Plant)'

IF EXISTS (SELECT	1
			FROM	##UploadData
			--WHERE	OperatorCode=@User
)BEGIN

	DROP TABLE ##UploadData

END


--PRINT @InsertSQL
--PRINT @SelectSQL
set @ExecuteSQL= @InsertSQL + @SelectSQL

EXECUTE(@ExecuteSQL)

DECLARE	@Order int,
		@RowCount int,
		@OrdersCount int

SELECT	@Order = sales_order
FROM	parameters with (TABLOCKX)

SELECT	@RowCount = COUNT(1)
FROM	##UploadData

if	isnull(@RowCount, 0) > 0 
begin
		while	exists
			(	select	order_no
				from	order_header
				where	order_no >= @Order and order_no < @Order + @RowCount) begin
			set	@Order = @Order + 1
		end

		 SET   @TableName = 'parameters'

		UPDATE	parameters
		SET		sales_order = @Order + @RowCount 

		SELECT	@Error = @@Error,    
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

		
		--1.0 CREATE PART CUSTOMER 
		INSERT INTO part_customer (part, Customer,customer_part,customer_standard_pack,type,customer_unit,blanket_price)
		SELECT	DISTINCT CPF.PartNumber,CPF.customer,part.cross_ref,CPF.STDPack ,'B','EA', CPF.Price
		FROM	##UploadData CPF
		LEFT JOIN	part_customer PartCustomer on PartCustomer.customer = CPF.customer and PartCustomer.part = CPF.PartNumber
		JOIN part on CPF.PartNumber =part.part  
		WHERE	PartCustomer.part is NULL

		SET		@TableName = 'part_customer'
		SELECT	@Error = @@ERROR, @OrdersCount = @@ROWCOUNT
		--print @RowCount
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

		--2.0 CREATE PART CUSTOMER PRICE MATRIX
		INSERT INTO part_customer_price_matrix (part, Customer, price, qty_break,alternate_price)
		SELECT	DISTINCT CPF.PartNumber,CPF.customer,CPF.Price,1,CPF.Price
		from	##UploadData CPF
		LEFT JOIN	part_customer_price_matrix CPrice on CPrice.customer = 	CPF.customer  
					and CPrice.part = CPF.PartNumber  
		where	CPrice.part is NULL
		
		SET		@TableName = 'part_customer_price_matrix'
		SELECT	@Error = @@ERROR, @OrdersCount = @@ROWCOUNT
		--print @RowCount
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
		
		--3.0 CREATE SALES ORDER		
		INSERT INTO order_header( order_no, customer, order_date, destination, Blanket_Part, Customer_part,
				box_label,pallet_label, standard_pack, our_cum, order_type, artificial_cum, ship_type, 
				price, price_unit,term, package_type, plant, 
				shipping_unit, currency_unit, alternate_price, cs_status,
				engineering_level, customer_po,salesman)
		
		SELECT	order_no = @Order + cpf.ID - 1, CPF.Customer, order_date = @TranDT, CPF.Destination, Blanket_Part = CPF.PartNumber, Customer_part = part.cross_ref, 
				box_label='FIN' , Pallet_label = 'FIN', CPF.STDPack, our_cum = 0, order_type = 'B', artificial_cum = 'N', ship_type = 'N', 
				CPF.Price, Price_unit = 'P', terms, package_type = Packs.Package, CPF.Plant,
				shipping_unit = part_inventory.standard_unit, currency_unit = customer.default_currency_unit, CPF.Price,customer.cs_status,
				engineering_level=drawing_number, CPF.CustomerPO,customer.salesrep
		FROM	##UploadData CPF
				join part on CPF.PartNumber =part.part
				join part_inventory on CPF.PartNumber =part_inventory.part
				join part_standard on part_standard.Part = CPF.PartNumber
				join customer on customer.customer = CPF.Customer
				left join destination on destination.customer = customer.customer and destination.destination = CPF.Destination
				left join (select Part, Package = MAX(code) from part_packaging group by part ) Packs on Packs.part = CPF.PartNumber

		--select	drawing_number from part where part='TRW0486-DV02'
		--select	* from order_header where order_no=29995
		--select	* from customer where customer='AUTOSYSTEM'
		SET		@TableName = 'order_header'
		SELECT	@Error = @@ERROR, @OrdersCount = @@ROWCOUNT
		--print @RowCount
		if @RowCount != @OrdersCount begin
			set	@Result = 60001
			rollback tran @ProcName
			RAISERROR ('More order than require were created, process is canceled.', 16, 1)
			return @Result
		end		
		
		if	@Error != 0  begin
			set	@Result = 60002
			rollback tran @ProcName
			 RAISERROR ('Error inserting table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
			return @Result
		end

		if @OrdersCount=0 begin
			set	@Result = 60003
			rollback tran @ProcName
			RAISERROR ('No se genero ninguna orden. Favor verificar informacion.', 16, 1)
			return @Result
		end
	
	--4.0 RETURN QTY AFFECTED
	SELECT	@OrdersCountInserted = COUNT(1)
	FROM	order_header
	WHERE	order_date=@TranDT

	DROP TABLE ##UploadData
end


if    @TranCount = 0 begin
    commit transaction @ProcName
end

SELECT @OrdersCountInserted=@OrdersCountInserted
set @Result = 0
return @Result
GO
