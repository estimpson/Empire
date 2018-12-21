SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QL_QuoteTransfer_GetSpecialReqNotes]
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
	srn.RowID
,	srn.[Description]
,	srn.Answer
,	srn.Notes
from
	eeiuser.QL_QuoteTransfer_SpecialReqNotes srn
where
	srn.QuoteNumber = @QuoteNumber
order by
	srn.RowID
--- </Body>


if @initialtrancount = 0  
    commit transaction @ProcName;  

GO
