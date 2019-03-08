SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [HN].[SP_Inv_UpdateStandardPackInformation]( 
		@Result integer = 0 output
) AS



SET nocount ON
SET	@Result = 999999

--<Tran Required=Yes AutoCreate=Yes>
DECLARE	@TranCount smallint


--<Error Handling>
DECLARE @ProcReturn integer, @ProcResult integer
DECLARE @Error integer,	@RowCount integer

declare @CallProcName sysname, @TableName sysname, @ProcName sysname

Set   @result = 999999
Set   @ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)  
Set   @trancount = @@trancount

If    @trancount = 0 
      begin transaction @ProcName
Else
      save transaction @ProcName

declare @TranDT datetime

set @TranDT=GETDATE()

Create table #ListPartEEH (
	Part varchar(25),
	EEHSTDPack numeric(20,6),
	EEISTDPACK numeric(20,6)
	)


--Listado de partes con standarkpack
insert into #ListPartEEH
Select	troypi.part, 
		EEHSTDPack=  isnull(eehpi.standard_pack,0),
		EEISTDPACK=isnull(troypi.standard_pack,0)
from	dbo.part_inventory troypi
join	eehsql1.eeh.dbo.part_inventory eehpi on troypi.part = eehpi.part
where	isnull(troypi.standard_pack,0) <> isnull(eehpi.standard_pack,0)
		and troypi.part not in (select part from part where RIGHT(part, 1)='P' and type='F')

set	@Error = @@Error
                	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting ListPartEEH in procedure %s', 16, 1,@ProcName)
	rollback tran @ProcName
	return	@Result
end

if exists (Select 1
			from #ListPartEEH
)begin			


	insert into Monitor.dbo.EEH_HistoricalPart_StdPackUpdated(part,standard_pack_eeh,standard_pack_eei,RegDT)
	select Part,EEHSTDPack,EEISTDPACK,RegDT=@TranDT
	from #ListPartEEH	

	set	@Error = @@Error
	set	@RowCount = @@Rowcount
                	
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting EEH_HistoricalPart_StdPackUpdated in procedure %s', 16, 1,@ProcName)
		rollback tran @ProcName
		return	@Result
	end

	if	@RowCount != 1 begin
		set	@Result = 999999
		rollback tran @ProcName
		RAISERROR ('Error inserting EEH_HistoricalPart_StdPackUpdated in procedure %s', 16, 1,@ProcName)
		RAISERROR (@Result, 16, 1, @ProcName)
		return	@Result
	end


	--actualizar std pack de honduras a troy
	update	 Monitor.dbo.part_inventory
	set		standard_pack  = listado.EEHSTDPack 
	from	dbo.part_inventory TroyPartInv
	inner join  #ListPartEEH listado on TroyPartInv.Part = listado.Part 


	SELECT	@Error = @@Error, @RowCount = @@RowCount
	IF	@Error != 0 begin
		SET	@Result = 999999
		ROLLBACK TRAN @ProcName
		RAISERROR ('Error:  Unable to update standard_pack in table dbo.part_inventory in procedure!', 16, 1,@ProcName)
		RETURN	@Result
	END

end

drop table #ListPartEEH

--<CloseTran Required=Yes AutoCreate=Yes>
IF	@TranCount = 0 BEGIN
	COMMIT TRANSACTION @ProcName
END
--</CloseTran Required=Yes AutoCreate=Yes>

--	III.	Success.
SET	@Result = 0
RETURN	@Result

GO
