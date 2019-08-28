SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TROY_MON_SaveCustomer]
(	@Customer		varchar(10)='0',
	@name			varchar(50),
	@address_1		varchar(50),
	@address_2		varchar(50),
	@address_3		varchar(50),
	@address_4		varchar(50),
	@address_5		varchar(50),
	@address_6		varchar(50),
	@phone			varchar(20),
	@fax			varchar(20),
	@contact_mobile	varchar(20),
	@notes			varchar(255),
	@contact		varchar(35),
	@contact_email	nvarchar(50),
	@position		varchar(50),
	@cs_status		varchar(20),
	@terms			varchar(20),
	@currencyunit	varchar(3),
	@operator		varchar(15),
	@result int out
	
)
        
/*

begin tran

declare @result int, @Customer varchar(10)

set @result = 0
set @Customer='TestCust'

exec dbo.SP_TROY_MON_SaveCustomer
	@Customer		=@Customer,
	@name			='Test Customer',
	@address_1		='214 maple',
	@address_2		='MI, Troy',
	@address_3		='',
	@address_4		='',
	@address_5		='',
	@address_6		='',
	@phone			='25452700',
	@fax			='',
	@contact_mobile	='',
	@notes			='prueba creacion cliente troy',
	@contact		='Empire',
	@contact_email	='it@empire.hn',
	@position		='',
	@cs_status		='Approved',
	@terms			='NET 30',
	@currencyunit	='USD',
	@operator		='424',
	@result=@result out


select	RESULT=@result

IF @result=0 BEGIN

SELECT	* FROM Monitor.dbo.customer where customer=@Customer

END

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
DECLARE @error integer, @rowcount integer
DECLARE @TranDT datetime

SET @TranDT =GETDATE()

if @Customer=''
begin
	set @Customer=NULL
end

if isnull(@Customer,'0')='0'
begin
	SET	@Result = 999999
	rollback tran @ProcName
	RAISERROR ('The customer %s cant be created. Please input a valid code.', 16, 1,@Customer)
	return	@Result	
end

--if exists customer, update data, if not create one
IF exists(	select	1
			from	Monitor.dbo.customer
			where	customer=@Customer
) BEGIN

	UPDATE	Monitor.dbo.customer
	SET		name=@name,
			address_1=@address_1,
			address_2=@address_2,
			address_3=@address_3,
			address_4=@address_4,
			address_5=@address_5,
			address_6=@address_6,
			phone=@phone,
			fax=@fax,
			contact=@contact,
			contact_email=@contact_email,
			contact_mobile =@contact_mobile,
			notes=@notes,
			position=@position,
			default_currency_unit=isnull(@currencyunit,'USD'),
			cs_status=isnull(@cs_status,'Approved'),
			terms=@terms,			
			empower_flag='EMPUPD',
			lastupdateby=@operator,
			lastupdatedt=@TranDT 
	WHERE	customer=@Customer  				
	
	select @Error = @@Error,    
		   @RowCount = @@Rowcount
	set @TableName='Monitor.dbo.customer'

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

END
ELSE BEGIN
	
	INSERT INTO Monitor.dbo.customer(customer,name,address_1,address_2,address_3,address_4,address_5,address_6,
				phone,fax,contact,contact_email,contact_mobile,notes,position,default_currency_unit,
				cs_status,create_date,regby,regdt)
	SELECT @customer,@name,@address_1,@address_2,@address_3,@address_4,@address_5,@address_6,
		   @phone,@fax,@contact,@contact_email,@contact_mobile,@notes,@position,isnull(@currencyunit,'USD'),
		   isnull(@cs_status,'Approved'),@TranDT,@operator,@TranDT

	SELECT	@Error = @@Error,    
			@RowCount = @@Rowcount
	SET		@TableName = 'Monitor.dbo.customer'

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



if    @TranCount = 0 begin
    commit transaction @ProcName
end

set @Result = 0
return @Result



GO
