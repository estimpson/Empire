SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [FT].[usp_GetLabelCode_RmaMaintenance]
	@Serial int
,	@LabelName sysname
,	@PrinterType sysname
,	@NumberOfLabels int
,	@LabelCode varchar(8000) out
as
set nocount on
set ansi_warnings off

--- <Error Handling>
declare
    @CallProcName sysname
,	@TableName sysname
,	@ProcName sysname
,	@ProcReturn integer
,	@ProcResult integer
,	@Error integer
,	@RowCount integer
,	@Result integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. <schema_name, sysname, dbo>.usp_Test
--- </Error Handling>

--- <Validation>
/*  Object exists  */
if not exists (
		select
			1
		from
			dbo.object o
		where
			o.serial = @Serial ) begin

	return
end
--- </Validation>

--- <Body>
declare
	@PartCode varchar(25)
,	@CustomerPart varchar(18)
,	@ObjectQty varchar(8)
,	@OperatorCode varchar(25)
,	@Description1 varchar(50)
,	@Description2 varchar(50)
,	@EngineeringLevel varchar(10)
,	@MfgDate varchar(12)
,	@CompanyAddress varchar(50)


--- <Get label data>
set			@CallProcName = 'dbo.usp_GetLabelData_GenericFin'
execute		@ProcReturn = dbo.usp_GetLabelData_GenericFin
				@Serial = @Serial
			,	@PartCode = @PartCode out
			,	@CustomerPart = @CustomerPart out
			,	@ObjectQty = @ObjectQty out
			,	@OperatorCode = @OperatorCode out
			,	@Description1 = @Description1 out
			,	@Description2 = @Description2 out
			,	@EngineeringLevel = @EngineeringLevel out
			,	@MfgDate = @MfgDate out
			,	@CompanyAddress = @CompanyAddress out
--- </Get label data>	


declare
	@labelRaw varchar(8000)

select
	@labelRaw = ld.LabelCode
from
	dbo.LabelDefinitions ld
where
	LabelName = 'FIN'
	and PrinterType = 'Zebra'

/*	Replace label code with the read values. */
set	@labelRaw = replace(@labelRaw, '[ObjectSerial]', coalesce(convert(varchar, @Serial),''))
set	@labelRaw = replace(@labelRaw, '[ObjectQty]', coalesce(convert(varchar, @ObjectQty),''))
set	@labelRaw = replace(@labelRaw, '[PartCode]', coalesce(@PartCode,''))
set	@labelRaw = replace(@labelRaw, '[CustomerPart]', coalesce(@CustomerPart,''))
set	@labelRaw = replace(@labelRaw, '[OperatorCode]', coalesce(@OperatorCode,''))
set	@labelRaw = replace(@labelRaw, '[Description1]', coalesce(@Description1,''))
set	@labelRaw = replace(@labelRaw, '[Description2]', coalesce(@Description2,''))
set	@labelRaw = replace(@labelRaw, '[MfgDate]', coalesce(@MfgDate,''))
set	@labelRaw = replace(@labelRaw, '[CompanyAddress]', coalesce(@CompanyAddress,''))
set	@labelRaw = replace(@labelRaw, '[NumberOfLabels]', '1')

set	@LabelCode = @labelRaw
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
	@serial int
,	@labelName sysname
,	@printerType sysname
,	@numberOfLabels int
,	@labelCode varchar(8000)

set	@serial = 10580799
set	@labelName = 'GenericFin'
set	@printerType = 'Zebra'
set	@numberOfLabels = 2

begin transaction Test

declare
	@ProcReturn integer
,	@Error integer

execute
	@ProcReturn = FT.usp_GetLabelCode
	@Serial = @serial
,	@LabelName = @labelName
,	@PrinterType = @printerType
,	@NumberOfLabels = @numberOfLabels
,	@LabelCode = @labelCode out

set	@Error = @@error

select
	@Error, @ProcReturn, @Serial, @LabelCode
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
