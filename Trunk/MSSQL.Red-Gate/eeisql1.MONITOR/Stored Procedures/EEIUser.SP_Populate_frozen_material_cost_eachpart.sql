SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [EEIUser].[SP_Populate_frozen_material_cost_eachpart] 
	(	@FiscalYear int, 
		@Period int, 
		@StarDate datetime,
		@EndDate datetime,
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

select eeipsh.part, 
		eeipsh.price, 
		eeipsh.material_cum, 
		eeipsh.frozen_material_cum, 
		eehpsh.material_cum 
from	HistoricalData.dbo.part_standard_historical eeipsh
	left join [eehsql1].[HistoricalData].dbo.part_standard_historical eehpsh 
		on eehpsh.part = eeipsh.part and eehpsh.fiscal_year = eeipsh.fiscal_year and eehpsh.period = eeipsh.period and eehpsh.reason = 'MONTH END' 
	left join HistoricalData.dbo.part_historical eeiph 
		on eeipsh.part = eeiph.part and eeipsh.fiscal_year = eeiph.fiscal_year and eeipsh.period = eeiph.period
where	ISNULL(eeipsh.frozen_material_cum,0)=0 
	and eeipsh.fiscal_year = @FiscalYear
	and eeipsh.period = @Period
	and eeiph.type = 'F'

--using [192.168.1.102].monitor

update 	eeips 
set	eeips.frozen_material_cum = eehpsh.material_cum 
from	part_standard eeips
left join [eehsql1].[HistoricalData].dbo.part_standard_historical_daily eehpsh 
	on eeips.part = eehpsh.part and eehpsh.time_stamp >= @StarDate and eehpsh.time_stamp < @EndDate --and eehpsh.reason = 'MONTH END'
where	ISNULL(eeips.frozen_material_cum,0)=0

SELECT      @Error = @@Error
			IF    @Error != 0 begin
            SET   @Result = 99999
            ROLLBACK TRAN  @ProcName
            RAISERROR ('Error:  The update to eeips is failed..', 16, 1)
        RETURN      @Result
end

update	eeipsh 
set	eeipsh.frozen_material_cum = eehpsh.material_cum 
from	HistoricalData.dbo.part_standard_historical eeipsh 
left join [eehsql1].[HistoricalData].dbo.part_standard_historical eehpsh 
	on eeipsh.part = eehpsh.part and eehpsh.time_stamp >= @StarDate and eehpsh.time_stamp < @EndDate --and eehpsh.reason = 'MONTH END' 
where	eeipsh.time_stamp >= @StarDate
	and ISNULL(eeipsh.frozen_material_cum,0)=0

SELECT      @Error = @@Error
			IF    @Error != 0 begin
            SET   @Result = 99999
            ROLLBACK TRAN  @ProcName
            RAISERROR ('Error:  The update to eeipsh is failed..', 16, 1)
        RETURN      @Result
end

update	eeipshd 
set	eeipshd.frozen_material_cum = eehpsh.material_cum 
from	HistoricalData.dbo.part_standard_historical_daily eeipshd left join [eehsql1].[HistoricalData].dbo.part_standard_historical eehpsh 
	on eeipshd.part = eehpsh.part and eehpsh.time_stamp >= @StarDate and eehpsh.time_stamp < @EndDate --and eehpsh.reason = 'MONTH END'
where	eeipshd.time_stamp >= @StarDate 
	and ISNULL(eeipshd.frozen_material_cum,0)=0

SELECT      @Error = @@Error
			IF    @Error != 0 begin
            SET   @Result = 99999
            ROLLBACK TRAN  @ProcName
            RAISERROR ('Error:  The update to eeipshd is failed..', 16, 1)
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
