SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [EEIUser].[usp_QL_QuoteTransfer_GetSignOffInitials]
	@Type varchar(50) -- QuoteEngineer, MaterialRep, ProductEngineer, ProgramManager
,	@TranDT datetime = null out
,	@Result integer = null  out
as
set nocount on
set ansi_warnings on
set	@Result = 0

--- <Error Handling>
declare
	--@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	--@ProcReturn integer,
	--@ProcResult integer,
	--@Error integer,
	@RowCount integer


set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
set @TranDT = getdate()

declare
	@initialtrancount int = @@trancount
if	@initialtrancount > 0
	save transaction @ProcName
else
	begin transaction @ProcName 


---	<ArgumentValidation>

---	</ArgumentValidation>


--- <Body>
if (@Type = 'QuoteEngineer') begin
	select
		i.Initials
	from
		eeiuser.QT_EngineeringMaterialsInitials i
	order by
		i.Initials
end
else if (@Type = 'MaterialRep') begin
	select
		i.Initials
	from
		eeiuser.QT_MaterialRepresentativeInitials i
	order by
		i.Initials
end
else if (@Type = 'ProductEngineer') begin
	select
		i.Initials
	from
		eeiuser.QT_ProductEngineerInitials i
	order by
		i.Initials
end
else if (@Type = 'ProgramManager') begin
	select
		i.Initials
	from
		eeiuser.QT_ProgramManagerInitials i
	order by
		i.Initials
end
--- </Body>


if @initialtrancount = 0  
    commit transaction @ProcName;  


GO
