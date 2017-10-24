SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[usp_GetLabelData_GenericFin]
	@Serial int
,	@PartCode varchar(25) output
,	@CustomerPart varchar(18) output
,	@ObjectQty varchar(8) output
,	@OperatorCode varchar(25) output
,	@Description1 varchar(50) output
,	@Description2 varchar(50) output
,	@EngineeringLevel varchar(10) output
,	@MfgDate varchar(12) output
,	@CompanyAddress varchar(50) output
as
set nocount on
set ansi_warnings off

--- <Body>
declare
	@partName varchar(50)

select
	@PartCode = p.part
,	@partName = p.name
,	@CustomerPart = p.cross_ref
,	@ObjectQty = convert(varchar, convert(int, o.std_quantity))
,	@OperatorCode = o.operator
,	@EngineeringLevel = (select max(engineering_level) from dbo.order_header where blanket_part = o.part)
,	@MfgDate = convert(char(8), coalesce(ws.ShiftDate, getdate()), 1)
,	@CompanyAddress = p2.company_name + ' ' + p2.address_1 + ' ' + p2.address_2 + ' ' + p2.address_3
from
	dbo.object o
	join dbo.part p on
		p.part = o.part
	left join FT.PreObjectHistory poh
		join dbo.WODetails wd
			on wd.ID = poh.WODID
		join dbo.WOShift ws
			on ws.WOID = wd.WOID
		on poh.Serial = o.serial
	cross join dbo.parameters p2
where
	o.serial = @Serial

set	@Description1 = (select Value from FT.udf_SplitOnWordsToRows(@partName, 16) where ID = 1)
set	@Description2 = (select Value from FT.udf_SplitOnWordsToRows(@partName, 16) where ID = 2)

--- </Body>

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
	@ProcReturn = dbo.usp_[NewProcedure]
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
