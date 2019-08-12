SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[SP_TROY_MON_SaveDestination]
(	@destination	varchar(20),
	@customer		varchar(10),
	@name			varchar(50),
	@type			varchar(2),
	@address_1		varchar(50),
	@address_2		varchar(50),
	@address_3		varchar(50)=NULL,
	@address_4		varchar(50)=NULL,
	@address_5		varchar(50)=NULL,
	@address_6		varchar(50)=NULL,
	@scheduler		varchar(15)=NULL,	
	@cs_status		varchar(20),
	@currencyunit	varchar(3),
	@custom5		varchar(10),
	@contact		varchar(35)=NULL,
	@phone			varchar(20)=NULL,
	@fax			varchar(20)=NULL,
	@contact_email	nvarchar(50)=NULL,
	@position		varchar(50)=NULL,
	@portal_link	varchar(80)=NULL,
	@portal_link_user				varchar(50)=NULL,
	@portal_link_pass				varchar(50)=NULL,
	@consigned						char(1)='N',
	@primaryLocation_consigned		varchar(10)=NULL,
	@secondaryLocation_consigned	varchar(10)=NULL,
	@operator						varchar(15),
	@result int out
	
)
        
/*

begin tran

declare @result int, @Customer varchar(10),@destination	varchar(20)

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

IF @consigned='Y'
BEGIN
	IF (@primaryLocation_consigned='') OR ( @primaryLocation_consigned IS NULL)
	BEGIN
		SET	@Result = 999999
        RAISERROR ('The destination %s has been selected as consigned, you must set a primary location.', 16, 1,@destination)
        rollback tran @ProcName
        return @Result
	END
END

--if exists destination, update data, if not create one
IF exists(	select	1
			from	Monitor.dbo.destination
			where	destination=@destination
) BEGIN

	UPDATE	Monitor.dbo.destination
	SET		name=@name,
			address_1=@address_1,
			address_2=@address_2,
			address_3=@address_3,
			address_4=@address_4,
			address_5=@address_5,
			address_6=@address_6,			
			default_currency_unit=isnull(@currencyunit,'USD'),
			cs_status=isnull(@cs_status,'Approved'),
			custom5=@custom5,
			type=@type,		
			scheduler=@scheduler,
			contact=@contact ,
			phone=@phone,
			fax=@fax,
			contact_email=@contact_email,
			position=@position,
			portal_link=@portal_link,
			portal_link_user=@portal_link_user,
			portal_link_pass=@portal_link_pass,
			consigned=@consigned,
			primaryLocation_consigned=@primaryLocation_consigned,
			secondaryLocation_consigned=@secondaryLocation_consigned,
			LastUpdateBy=@operator,
			LastUpdateDT=@TranDT 
	WHERE	destination=@destination				
	
	select @Error = @@Error,    
		   @RowCount = @@Rowcount
	set @TableName='Monitor.dbo.destination'

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
	


	INSERT INTO Monitor.dbo.destination(destination,customer,name,address_1,address_2,address_3,address_4,address_5,address_6,
				type,default_currency_unit,cs_status,custom5,scheduler,regby,regdt,
				contact,phone,fax,contact_email,position,portal_link,portal_link_user,portal_link_pass,
				consigned,primaryLocation_consigned,secondaryLocation_consigned )
	SELECT @destination,@customer,@name,@address_1,@address_2,@address_3,@address_4,@address_5,@address_6,
		   @type,isnull(@currencyunit,'USD'),isnull(@cs_status,'Approved'),@custom5,@scheduler,@operator,@TranDT,
		   @contact,@phone,@fax,@contact_email,@position,@portal_link,@portal_link_user,@portal_link_pass,
		   @consigned,@primaryLocation_consigned,@secondaryLocation_consigned

	SELECT	@Error = @@Error,    
			@RowCount = @@Rowcount
	SET		@TableName = 'Monitor.dbo.destination'

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
