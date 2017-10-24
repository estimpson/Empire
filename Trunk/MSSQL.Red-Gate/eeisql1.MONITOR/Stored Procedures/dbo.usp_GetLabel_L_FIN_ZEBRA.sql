SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[usp_GetLabel_L_FIN_ZEBRA]
	@BoxSerial int
,	@LabelData varchar(8000) out
,	@Result integer out
as
set nocount on
set ansi_warnings off
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

--- <Body>
/*	Retrieve label data. */
declare
	@serialNumber varchar(25)
,	@internalPart varchar(25)
,	@operator varchar(5)
,	@objectQuantity varchar(12)
,	@crossRef varchar(18)
,	@description1 varchar(17)
,	@description2 varchar(17)
,	@mfgDate char(10)
,	@companyInfo varchar(255)

select
	@serialNumber = convert(varchar, o.serial) -- = {Serial Number}
,	@internalPart = o.part -- = {Internal Part}
,	@operator = o.operator -- = {Operator}
,	@objectQuantity = convert(varchar, convert (int, o.quantity)) -- = {Object Quantity}
,	@crossRef = convert (varchar (18), p.cross_ref) -- = {Cross Ref}
,	@description1 = case when len(p.name) > 17 then left(p.name, 17 - charindex(' ', right(reverse(p.name), 17))) else p.name end -- = {Description s17.1}
,	@description2 = case when len(p.name) > 17 then left(ltrim(substring(p.name, 18 - charindex(' ', right(reverse(p.name), 17)), 18)), 17) else '' end -- = {Description s17.2}
,	@mfgDate = convert(varchar, getdate(), 101) -- = {MfgDate MM/DD/YYYY}
,	@companyInfo = p2.company_name + ' ' + p2.address_1 + ' ' + p2.address_2 + ' ' + p2.address_3 -- = {Company Info}
from
    dbo.object o
    join dbo.part p on
		p.part = o.part
	cross join dbo.parameters p2
where
    o.serial = @BoxSerial

/*	Retreive label code. */
declare
	@labelCode varchar(8000)

select
	@labelCode = LabelCode
from
	dbo.LabelDefinition ld
where
	LabelName = 'L_FIN_ZEBRA'
	and
		PrinterType = 'ZEBRA'

/*	Replace label code with label data for this box. */
set	@labelCode = replace(@labelCode, '{Serial Number}', @serialNumber)
set	@labelCode = replace(@labelCode, '{Internal Part}', @internalPart)
set	@labelCode = replace(@labelCode, '{Operator}', @operator)
set	@labelCode = replace(@labelCode, '{Object Quantity}', @objectQuantity)
set	@labelCode = replace(@labelCode, '{Cross Ref}', @crossRef)
set	@labelCode = replace(@labelCode, '{Description s17.1}', @description1)
set	@labelCode = replace(@labelCode, '{Description s17.2}', @description2)
set	@labelCode = replace(@labelCode, '{MfgDate MM/DD/YYYY}', @mfgDate)
set	@labelCode = replace(@labelCode, '{Company Info}', @companyInfo)
--- </Body>

---	<Return>
set @LabelData = @labelCode

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
	@boxSerial int
,	@labelData varchar(8000)

set	@boxSerial = 10254204

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_GetLabel_L_FIN_ZEBRA
	@BoxSerial = @boxSerial
,	@LabelData = @labelData out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @labelData, @ProcResult
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
