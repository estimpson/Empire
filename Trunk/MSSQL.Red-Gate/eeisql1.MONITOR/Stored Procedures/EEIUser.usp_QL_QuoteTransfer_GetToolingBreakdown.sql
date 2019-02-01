SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QL_QuoteTransfer_GetToolingBreakdown]
	@QuoteNumber varchar(50)
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
select
	tb.RowID
,	tb.[Description]
,	tb.Quantity
,	tb.Value
from
	eeiuser.QL_QuoteTransfer_ToolingBreakdown tb
where
	tb.QuoteNumber = @QuoteNumber
order by
	tb.RowID
--- </Body>


if @initialtrancount = 0  
    commit transaction @ProcName;   

GO
