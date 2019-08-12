SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TROY_MON_SaveDestinationShipping]
(	@destination	varchar(20),
	@scac_code		varchar(4)=NULL,
	@trans_mode		varchar(2)=NULL,
	@ship_day		varchar(10)=NULL,
	@FOB			varchar(20)=NULL,
	@freigt_type	varchar(20)=NULL,
	@dock_code_flag	varchar(1)='N',
	@allow_mult_po	varchar(1)='N',
	@model_year_flag varchar(1)='N',
	@will_call_customer	varchar(1)='N',
	@allow_overstage varchar(1)='N',
	@result int out
	
)
        
/*

begin tran

declare @result int,@destination	varchar(20)

set @result = 0
set @Customer='TestCust'
set @destination=''

exec dbo.SP_TROY_MON_SaveDestination
	@destination	=@destination,
	@customer		=@customer,
	@name			='',
	@type			='R',
	@address_1		='',
	@address_2		='',
	@address_3		='',
	@address_4		='',
	@address_5		='',
	@address_6		='',
	@scheduler		='',
	@cs_status		='',
	@currencyunit	='',
	@custom5		='',
	@operator		='424',
	@result=@result out


select	RESULT=@result

IF @result=0 BEGIN

SELECT	* FROM Monitor.dbo.destinacion where destination=@destination
SELECT	* FROM Monitor.dbo.destinacion where customer=@customer

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

if not exists (	select	1
				from	Monitor.dbo.destination 
				where	destination=@destination
) begin
	set   @Result = 999999
    RAISERROR ('the destinatiopn %s does not exists,please create firts and then save the shipping data.', 16, 1,@destination)
    rollback tran @ProcName
    return @Result
end


--if exists destination shipping, update data, if not create one
IF exists(	select	1
			from	Monitor.dbo.destination_shipping 
			where	destination=@destination
) BEGIN

	UPDATE	Monitor.dbo.destination_shipping
	SET		scac_code		=@scac_code,
			trans_mode		=@trans_mode,
			ship_day		=@ship_day,
			freigt_type	=@freigt_type,
			dock_code_flag	=@dock_code_flag,
			allow_mult_po	=@allow_mult_po,
			model_year_flag =@model_year_flag,
			will_call_customer=@will_call_customer,
			allow_overstage =@allow_overstage,
			fob=@FOB
	WHERE	destination=@destination				
	
	select @Error = @@Error,    
		   @RowCount = @@Rowcount
	set @TableName='Monitor.dbo.destination_shipping'

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
	
	INSERT INTO Monitor.dbo.destination_shipping (destination,scac_code,
			trans_mode,	ship_day,freigt_type,dock_code_flag,allow_mult_po,
			model_year_flag,will_call_customer,allow_overstage,fob )
	SELECT	@destination,@scac_code,@trans_mode,@ship_day,@freigt_type,@dock_code_flag,@allow_mult_po,
			@model_year_flag,@will_call_customer,@allow_overstage ,@FOB

	SELECT	@Error = @@Error,    
			@RowCount = @@Rowcount
	SET		@TableName = 'Monitor.dbo.destination_shipping'

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
