SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE procedure [dbo].[ftsp_CommonSerial_CreateMissingReceipt]
	@MissingSerial int
,	@ContainerCode varchar(10)
,	@Shipper int
,	@Notes varchar(100)
,   @EFFectiveDT datetime
,	@TranDT datetime out
,	@Result integer out
as
set nocount on
set ansi_warnings on
set ansi_nulls on
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
--- <Insert rows="1">
set	@TableName = 'dbo.audit_trail'

insert
	dbo.audit_trail
(	serial,	date_stamp,	type,	part,	quantity,	remarks,	price,	vendor,	po_number,	operator,	from_loc,	to_loc,	on_hand,	status,
	shipper,	unit,	std_quantity,	cost,	plant,	gl_account,	std_cost,	user_defined_status,	parent_serial, notes)
select
	serial = ShipLogInProcess.Serial
,	date_stamp = ShipLogInProcess.ShipDT
,	type = 'R'
,	part = ShipLogInProcess.Part
,	quantity = ShipLogInProcess.Quantity
,	remarks = 'Receiving'
,	price = ShipLogInProcess.RcvdPrice
,	vendor = ShipLogInProcess.Origin
,	po_number = ShipLogInProcess.PONumber
,	operator = ShipLogInProcess.Origin
,	from_loc = ShipLogInProcess.Origin
,	to_loc = @ContainerCode
,	on_hand =
	(	select
			coalesce(min(part_online.on_hand),0) + sum(SL2.Quantity)
		from
			FT.vwCommonSerial_ShipLogInProcess SL2
			left outer join part_online
				on SL2.Part = part_online.part
		where
			SL2.Serial <= ShipLogInProcess.Serial
			and SL2.Part = ShipLogInProcess.Part
			and SL2.Status = 'A'
	)
,	status = ShipLogInProcess.Status
,	shipper = ShipLogInProcess.Origin + '-' + convert (varchar,ShipLogInProcess.Shipper)
,	unit = ShipLogInProcess.RcvdUnit
,	std_quantity = ShipLogInProcess.Quantity
,	cost = ShipLogInProcess.RcvdCost
,	plant = ShipLogInProcess.RcvdPlant
,	gl_account = '?'
,	std_cost = ShipLogInProcess.RcvdCost
,	user_defined_status = ShipLogInProcess.UserStatus
,	parent_serial = ShipLogInProcess.PalletSerial
,	notes = @notes
from
	(	select
			ShipLog.RowStatus
		,	ShipLog.Shipper
		,	ShipLog.Serial
		,	ShipLog.Part
		,	ShipLog.Quantity
		,	ShipLog.Unit
		,	ShipLog.PackageType
		,	ShipLog.Status
		,	ShipLog.UserStatus
		,	ShipLog.PalletSerial
		,	ShipLog.Price
		,	ShipLog.Cost
		,	ShipLog.Weight
		,	ShipLog.TareWeight
		,	ShipLog.ShipDT
		,	ShipLog.Origin
		,	ShipLog.Destination
		,	PONumber = po_header.po_number
		,	RcvdUnit = part_inventory.standard_unit
		,	RcvdPrice = part_standard.price
		,	RcvdCost = part_standard.cost
		,	RcvdWeight = part_inventory.unit_weight * ShipLog.Quantity
		,	RcvdTareWeight = package_materials.weight
		,	RcvdPlant = po_header.plant
		from
			FT.CommonSerialShipLog ShipLog
			left outer join part_online
				on ShipLog.Part = part_online.part
			left outer join po_header
				on part_online.default_po_number = po_header.po_number
			left outer join part_inventory
				on ShipLog.Part = part_inventory.part
			left outer join part_standard
				on ShipLog.Part = part_standard.part
			left outer join package_materials
				on ShipLog.PackageType = package_materials.code
	) ShipLogInProcess
	left join dbo.audit_trail at on at.type = 'R'
		and at.serial = ShipLogInProcess.Serial
		and at.date_stamp = ShipLogInProcess.ShipDT
where
	ShipLogInProcess.Serial = @MissingSerial
	and ShipLogInProcess.shipper = @Shipper

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount != 1 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end


insert [HistoricalData].dbo.object_historical_daily
(
		[time_stamp]
      ,	[fiscal_year]
	,	[period]
      ,	[reason]
      ,[serial]
      ,[part]
      ,[location]
      ,[last_date]
      ,[unit_measure]
      ,[operator]
      ,[status]
      ,[destination]
      ,[station]
      ,[origin]
      ,[cost]
      ,[weight]
      ,[parent_serial]
      ,[note]
      ,[quantity]
      ,[last_time]
      ,[date_due]
      ,[customer]
      ,[sequence]
      ,[shipper]
      ,[lot]
      ,[type]
      ,[po_number]
      ,[name]
      ,[plant]
      ,[start_date]
      ,[std_quantity]
      ,[package_type]
      ,[field1]
      ,[field2]
      ,[custom1]
      ,[custom2]
      ,[custom3]
      ,[custom4]
      ,[custom5]
      ,[show_on_shipper]
      ,[tare_weight]
      ,[suffix]
      ,[std_cost]
      ,[user_defined_status]
      ,[workorder]
      ,[engineering_level]
      ,[kanban_number]
      ,[dimension_qty_string]
      ,[dim_qty_string_other]
      ,[varying_dimension_code]
      ,[posted]
   
)
	select distinct
	   tIME_STAMP
      ,convert(varchar(5),datepart(YYYY, TIME_STAMP))
	  ,convert(smallint,datepart(MM, TIME_STAMP))
      ,(case when datediff(d,TIME_STAMP, DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,TIME_STAMP)+1,0))) = 0 then 'MONTH END' else 'DAILY' end)
      ,at.[serial]
      ,at.[part]
      ,AT.from_loc
      ,@EFFectiveDT
      ,unit
      ,[operator]
      ,[status]
      ,[destination]
      ,NULL
      ,[origin]
      ,[cost]
      ,[weight]
      ,[parent_serial]
      ,[notes]
      ,[quantity]
      ,@EffectiveDT
      ,NULL
      ,[customer]
      ,[sequence]
      ,[shipper]
      ,[lot]
      ,[type]
      ,[po_number]
      ,NULL
      ,[plant]
      ,[start_date]
      ,[std_quantity]
      ,[package_type]
      ,[field1]
      ,[field2]
      ,[custom1]
      ,[custom2]
      ,[custom3]
      ,[custom4]
      ,[custom5]
      ,[show_on_shipper]
      ,[tare_weight]
      ,[suffix]
      ,[std_cost]
      ,[user_defined_status]
      ,[workorder]
      ,[engineering_level]
      ,[kanban_number]
      ,[dimension_qty_string]
      ,[dim_qty_string_other]
      ,[varying_dimension_code]
      ,[posted]

			
			
			from eehsql1.eeh.dbo.audit_trail AT
			cROSS APPLY ( SELECT DISTINCT TIME_STAMP FROM HistoricalData.DBO.object_historical_daily WHERE Time_stamp>= @EffectiveDT) tIMEsTAMPS
			where AT.serial = @MissingSerial and AT.type = 'S' AND AT.DATE_STAMP = ( SELECT MAX(DATE_STAMP) FROM eehsql1.eeh.dbo.audit_trail AT2 WHERE AT2.TYPE = 'S' AND AT2.SERIAL = AT.SERIAL)
			and not exists ( select 1 from HistoricalData.DBO.object_historical_daily  ohd2 where ohd2.serial =  @MissingSerial and ohd2.time_stamp =  tIMEsTAMPS.time_stamp )

	INSERT INTO [dbo].[object_historical]
           ([Time_stamp]
           ,[fiscal_year]
           ,[period]
           ,[reason]
           ,[serial]
           ,[part]
           ,[location]
           ,[last_date]
           ,[unit_measure]
           ,[operator]
           ,[status]
           ,[destination]
           ,[station]
           ,[origin]
           ,[cost]
           ,[weight]
           ,[parent_serial]
           ,[note]
           ,[quantity]
           ,[last_time]
           ,[date_due]
           ,[customer]
           ,[sequence]
           ,[shipper]
           ,[lot]
           ,[type]
           ,[po_number]
           ,[name]
           ,[plant]
           ,[start_date]
           ,[std_quantity]
           ,[package_type]
           ,[field1]
           ,[field2]
           ,[custom1]
           ,[custom2]
           ,[custom3]
           ,[custom4]
           ,[custom5]
           ,[show_on_shipper]
           ,[tare_weight]
           ,[suffix]
           ,[std_cost]
           ,[user_defined_status]
           ,[workorder]
           ,[engineering_level]
           ,[kanban_number]
           ,[dimension_qty_string]
           ,[dim_qty_string_other]
           ,[varying_dimension_code]
           ,[posted])




		select distinct
	   tIME_STAMP
      ,convert(varchar(5),datepart(YYYY, TIME_STAMP))
	  ,convert(smallint,datepart(MM, TIME_STAMP))
      ,(case when datediff(d,TIME_STAMP, DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,TIME_STAMP)+1,0))) = 0 then 'MONTH END' else 'DAILY' end)
      ,at.[serial]
      ,at.[part]
      ,AT.from_loc
      ,@EFFectiveDT
      ,unit
      ,[operator]
      ,[status]
      ,[destination]
      ,NULL
      ,[origin]
      ,[cost]
      ,[weight]
      ,[parent_serial]
      ,[notes]
      ,[quantity]
      ,@EffectiveDT
      ,NULL
      ,[customer]
      ,[sequence]
      ,[shipper]
      ,[lot]
      ,[type]
      ,[po_number]
      ,NULL
      ,[plant]
      ,[start_date]
      ,[std_quantity]
      ,[package_type]
      ,[field1]
      ,[field2]
      ,[custom1]
      ,[custom2]
      ,[custom3]
      ,[custom4]
      ,[custom5]
      ,[show_on_shipper]
      ,[tare_weight]
      ,[suffix]
      ,[std_cost]
      ,[user_defined_status]
      ,[workorder]
      ,[engineering_level]
      ,[kanban_number]
      ,[dimension_qty_string]
      ,[dim_qty_string_other]
      ,[varying_dimension_code]
      ,[posted]

			
			
			from eehsql1.eeh.dbo.audit_trail AT
			cROSS APPLY ( SELECT DISTINCT TIME_STAMP FROM HistoricalData.DBO.object_historical WHERE Time_stamp>= @EffectiveDT) tIMEsTAMPS
			where AT.serial = @MissingSerial and AT.type = 'S' AND AT.DATE_STAMP = ( SELECT MAX(DATE_STAMP) FROM eehsql1.eeh.dbo.audit_trail AT2 WHERE AT2.TYPE = 'S' AND AT2.SERIAL = AT.SERIAL)
			and not exists ( select 1 from HistoricalData.DBO.object_historical  ohd2 where ohd2.serial =  @MissingSerial and ohd2.time_stamp =  tIMEsTAMPS.time_stamp ) and 
			(case when datediff(d,TIME_STAMP, DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,TIME_STAMP)+1,0))) = 0 then 'MONTH END' else 'DAILY' end) = 'MONTH END'
			




--- </Insert>

--- </Body>

--- <Tran>
if	@tranCount = 0 begin
	commit tran @ProcName
end

--- </Tran>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>

/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go

declare
	@Param1 [scalar_data_type]

set	@Param1 = [test_value]

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.ftsp_CommonSerial_CreateMissingReceipt
	@Param1 = @Param1
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

if	@@trancount > 0 begin
	rollback
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/



GO
