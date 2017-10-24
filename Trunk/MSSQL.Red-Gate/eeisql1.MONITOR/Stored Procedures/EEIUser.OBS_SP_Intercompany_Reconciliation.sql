SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
declare @result int

execute EEIUser.SP_Intercompany_Reconciliation 2015, 7, @result 

*/

CREATE PROCEDURE [EEIUser].[OBS_SP_Intercompany_Reconciliation] 
	(	@FiscalYear int, 
		@Period int, 
		@Result integer = 0 output)
AS

SET NOCOUNT ON;
	SET @Result = 999999
    -- Insert statements for procedure here
	
DECLARE     @TranCount smallint	
--<Tran Required=Yes AutoCreate=Yes>

DECLARE @ProcReturn integer, @ProcResult integer 
DECLARE @Error integer, @RowCount integer,@ProcName sysname
set	@ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)  -- e.g. dbo.usp_Test

SET   @TranCount = @@TranCount
IF    @TranCount = 0 
      BEGIN TRANSACTION @ProcName
ELSE
      SAVE TRANSACTION @ProcName
	  	
	declare @Date as datetime

	set @Date = convert(datetime,convert(varchar,@FiscalYear) + '-' + convert(varchar,@Period) + '-' + '01')

	insert into eeiuser.acctg_inv_reconciliation (product_line, type, part, price, material_cum, frozen_material_cum, date_updated)
	SELECT	distinct(p.product_line)
		,p.type
		,o.part
		,ps.price
		,ps.material_cum
		,ps.frozen_material_cum
		,NULL
			FROM	[HistoricalData].dbo.object_historical o 
				 LEFT JOIN [HistoricalData].dbo.part_historical p on o.part = p.part  and o.time_stamp = p.time_stamp 
				 LEFT JOIN [HistoricalData].dbo.part_standard_historical ps on o.part = ps.part  and o.time_stamp = ps.time_stamp 
			WHERE  o.fiscal_year = @FiscalYear and o.period = @Period and o.reason = 'MONTH END'
					AND p.type not in ('','R','W') 
					AND o.part not like 'ECS%'
					AND o.location not in ('PREOBJECT','PRE-OBJECT','PRE-STOCK','PRESTOCK')
					AND o.user_defined_status not in ('PREOBJECT','PRE-OBJECT','PRE-STOCK','PRESTOCK')
					AND (ISNULL(ps.price,0) < .01 or isnull(ps.material_cum,0) < .01)
 --ORDER BY p.product_line, p.type, o.part
 	
		SELECT      @Error = @@Error
			IF    @Error != 0 begin
            SET   @Result = 99999
            ROLLBACK TRAN  @ProcName
            RAISERROR ('Error:  The insert to acctg_inv_reconciliation is failed..', 16, 1)
        RETURN      @Result
		end

--RUN THIS QUERY SECOND TO POPULATE A SUGGESTED PRICE AND TRANSFER PRICE IN ERROR CORRECTION TABLE (BASED OFF OF SALES ORDER VALUES)
	declare @order_price table
	(part varchar(25), price decimal(18,6))
	
	insert into @order_price
	select blanket_part, order_header.price from (select *, rank() over ( partition by blanket_part order by order_date desc) rnk from order_header) order_header 
		join eeiuser.acctg_inv_reconciliation air on order_header.blanket_part = air.part where air.date_updated is null and order_header.rnk = 1

	SELECT      @Error = @@Error
			IF    @Error != 0 begin
            SET   @Result = 99999
            ROLLBACK TRAN  @ProcName
            RAISERROR ('Error:  The insert to @order_price is failed..', 16, 1)
        RETURN      @Result
	end

	update air
	set air.price = op.price, air.material_cum = round(op.price*.83,2) 
		from eeiuser.acctg_inv_reconciliation air join @order_price op 
				on air.part = op.part 
		where air.date_updated is null

		SELECT      @Error = @@Error
			IF    @Error != 0 begin
            SET   @Result = 99999
            ROLLBACK TRAN  @ProcName
            RAISERROR ('Error:  The update to @air is failed..', 16, 1)
        RETURN      @Result
		end
--	select * from eeiuser.acctg_inv_reconciliation air where air.date_updated is null order by 2, 4

--EEI DATABASE

-- 1. Update the customer selling price (part_standard.price to 4 decimals) and transfer price (part_standard.material_cum to 2 decimals) in EEI db

update	at 
set	at.posted = 'N' 
from	audit_trail at
join	eeiuser.acctg_inv_reconciliation air on at.part = air.part
where   at.date_stamp >= @Date
	and at.type not in ('T','Z')
	and air.date_updated is null

SELECT      @Error = @@Error
			IF    @Error != 0 begin
            SET   @Result = 99999
            ROLLBACK TRAN  @ProcName
            RAISERROR ('Error:  The update to eei table at is failed..', 16, 1)
        RETURN      @Result
end
update	pshd
set		 pshd.price			= air.price  
		,pshd.material		= air.material_cum
		,pshd.material_cum	= air.material_cum
		,pshd.cost			= air.material_cum
		,pshd.cost_cum		= air.material_cum 
from	HistoricalData.dbo.part_standard_historical_daily pshd
join	eeiuser.acctg_inv_reconciliation air on pshd.part = air.part
where   pshd.fiscal_year = @FiscalYear and pshd.period >= @Period
and 	air.date_updated is null

SELECT      @Error = @@Error
			IF    @Error != 0 begin
            SET   @Result = 99999
            ROLLBACK TRAN  @ProcName
            RAISERROR ('Error:  The update to eei table pshd is failed..', 16, 1)
        RETURN      @Result
		end
update	psh
set		 psh.price			= air.price
		,psh.material		= air.material_cum
		,psh.material_cum	= air.material_cum
		,psh.cost			= air.material_cum
		,psh.cost_cum		= air.material_cum 
from	HistoricalData.dbo.part_standard_historical psh
join	eeiuser.acctg_inv_reconciliation air on psh.part = air.part
where   psh.fiscal_year = @FiscalYear and psh.period >= @Period
and air.date_updated is null

SELECT      @Error = @@Error
			IF    @Error != 0 begin
            SET   @Result = 99999
            ROLLBACK TRAN  @ProcName
            RAISERROR ('Error:  The update to eei table psh is failed..', 16, 1)
        RETURN      @Result
		end
update	ps
set		 ps.price			= air.price
		,ps.material		= air.material_cum
		,ps.material_cum	= air.material_cum
		,ps.cost			= air.material_cum
		,ps.cost_cum		= air.material_cum 
from	monitor.dbo.part_standard ps
join	eeiuser.acctg_inv_reconciliation air on ps.part = air.part
and air.date_updated is null

SELECT      @Error = @@Error
			IF    @Error != 0 begin
            SET   @Result = 99999
            ROLLBACK TRAN  @ProcName
            RAISERROR ('Error:  The update to eei table ps is failed..', 16, 1)
        RETURN      @Result
		end
-- EEH Database
-- 2.  Update the transfer price (part_standard.price to 2 decimals) in EEH db

--declare @acctg_inv_reconciliation table 
--(product_line varchar(25)
--,type varchar(1)
--,part varchar(25)
--,price decimal(18,4)
--,material_cum decimal(18,6)
--)

--insert into @acctg_inv_reconciliation
--select * 
--from	openquery( EEISQL1, 'select product_line, type, part, price, material_cum from monitor.eeiuser.acctg_inv_reconciliation where date_updated IS NULL'  )

----select product_line, type, part, price, material_cum 
----from eeiuser.acctg_inv_reconciliation where date_updated IS NULL

--SELECT      @Error = @@Error
--			IF    @Error != 0 begin
--            SET   @Result = 99999
--            ROLLBACK TRAN  @ProcName
--            RAISERROR ('Error:  The insert to @acctg_inv_reconciliation is failed..', 16, 1)
--        RETURN      @Result
--		end
--update	sd
--set		sd.price = air.material_cum 
--		,sd.alternate_price = air.material_cum 
--from		shipper_detail sd
--join		shipper s on sd.shipper = s.id
--join		@acctg_inv_reconciliation air on sd.part_original = air.part
--where	s.date_shipped >= @Date

--SELECT      @Error = @@Error
--			IF    @Error != 0 begin
--            SET   @Result = 99999
--            ROLLBACK TRAN  @ProcName
--            RAISERROR ('Error:  The update to EEH table sd is failed..', 16, 1)
--        RETURN      @Result
--		end


--update	s
--set		s.posted = 'N' 
--from		shipper s
--join		shipper_detail sd on s.id = sd.shipper
--join		@acctg_inv_reconciliation air on sd.part_original = air.part
--where	s.date_shipped >= @Date

--SELECT      @Error = @@Error
--			IF    @Error != 0 begin
--            SET   @Result = 99999
--            ROLLBACK TRAN  @ProcName
--            RAISERROR ('Error:  The update to EEH table s is failed..', 16, 1)
--        RETURN      @Result
--		end

--update  od
--set		 od.price = air.material_cum
--		,od.alternate_price = air.material_cum
--from		order_detail od
--join		@acctg_inv_reconciliation air on od.part_number = air.part

--SELECT      @Error = @@Error
--			IF    @Error != 0 begin
--            SET   @Result = 99999
--            ROLLBACK TRAN  @ProcName
--            RAISERROR ('Error:  The update to EEH table od is failed..', 16, 1)
--        RETURN      @Result
--		end

--update  oh
--set		 oh.price = air.material_cum 
--		,oh.alternate_price = air.material_cum
--from		order_header oh
--join		@acctg_inv_reconciliation air on oh.blanket_part = air.part		

--SELECT      @Error = @@Error
--			IF    @Error != 0 begin
--            SET   @Result = 99999
--            ROLLBACK TRAN  @ProcName
--            RAISERROR ('Error:  The update to EEH table oh is failed..', 16, 1)
--        RETURN      @Result
--		end




--update	pc
--set		pc.blanket_price = air.material_cum 
--from		part_customer pc
--join		@acctg_inv_reconciliation air on pc.part = air.part		

--SELECT      @Error = @@Error
--			IF    @Error != 0 begin
--            SET   @Result = 99999
--            ROLLBACK TRAN  @ProcName
--            RAISERROR ('Error:  The update to EEH table pc is failed..', 16, 1)
--        RETURN      @Result
--		end


--/*---------------------------------------------*/


--update	pcpm
--set		 pcpm.price = air.material_cum
--		,pcpm.alternate_price = air.material_cum
--from		part_customer_price_matrix pcpm
--join		@acctg_inv_reconciliation air on pcpm.part = air.part

--SELECT      @Error = @@Error
--			IF    @Error != 0 begin
--            SET   @Result = 99999
--            ROLLBACK TRAN  @ProcName
--            RAISERROR ('Error:  The update to EEH table pcpm is failed..', 16, 1)
--        RETURN      @Result
--		end
-------------------------------

--update	ps
--set		ps.price = air.material_cum
--from		part_standard ps
--join		@acctg_inv_reconciliation air on ps.part = air.part

--SELECT      @Error = @@Error
--			IF    @Error != 0 begin
--            SET   @Result = 99999
--            ROLLBACK TRAN  @ProcName
--            RAISERROR ('Error:  The update to  EEH table ps is failed..', 16, 1)
--        RETURN      @Result
--		end

--update	psh
--set		psh.price = air.material_cum
--from		HistoricalData.dbo.part_standard_historical psh
--join		@acctg_inv_reconciliation air on psh.part = air.part
--where	psh.fiscal_year = @FiscalYear and psh.period >= @Period

--SELECT      @Error = @@Error
--			IF    @Error != 0 begin
--            SET   @Result = 99999
--            ROLLBACK TRAN  @ProcName
--            RAISERROR ('Error:  The update to EEH table psh is failed..', 16, 1)
--        RETURN      @Result
--		end

--update	pshd
--set		pshd.price = air.material_cum
--from		HistoricalData.dbo.part_standard_historical_daily pshd
--join		@acctg_inv_reconciliation air on pshd.part = air.part
--where	pshd.fiscal_year = @FiscalYear and pshd.period >= @Period

--SELECT      @Error = @@Error
--			IF    @Error != 0 begin
--            SET   @Result = 99999
--            ROLLBACK TRAN  @ProcName
--            RAISERROR ('Error:  The update to EEH table pshd is failed..', 16, 1)
--        RETURN      @Result
--		end


-- EEI Database

 ---3. Update the reconciliation table

update	eeiuser.acctg_inv_reconciliation 
set	date_updated = getdate()
where	date_updated is null

SELECT      @Error = @@Error
			IF    @Error != 0 begin
            SET   @Result = 99999
            ROLLBACK TRAN  @ProcName
            RAISERROR ('Error:  The update to EEH table eeiuser.acctg_inv_reconciliation is failed..', 16, 1)
        RETURN      @Result
		end
--<CloseTran Required=Yes AutoCreate=Yes>
IF	@TranCount = 0 BEGIN
	COMMIT TRANSACTION @ProcName
END
--</CloseTran Required=Yes AutoCreate=Yes>

--	III.	Success.
SET	@Result = 0
RETURN	@Result
GO
