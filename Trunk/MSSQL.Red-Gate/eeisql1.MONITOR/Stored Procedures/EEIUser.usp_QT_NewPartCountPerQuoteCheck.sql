SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_NewPartCountPerQuoteCheck]
	@EEIPartNumber varchar(30)
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


begin transaction;


--- <Body>
if ( ( 
		select
			count(*)
		from
			eeiuser.QT_QuoteLog ql
		where
			ql.EEIPartNumber = @EEIPartNumber
			and ql.QuoteReason = 'New Part' ) > 0 ) begin

	declare 
		@QuoteNumber varchar(50)
	select
		@QuoteNumber = ql.QuoteNumber
	from
		eeiuser.QT_QuoteLog ql
	where
		ql.EEIPartNumber = @EEIPartNumber
		and ql.QuoteReason = 'New Part'
		
	set @Result = -1
	raiserror ('Only one quote per part can be designated as New Part. Quote %s has quote reason set to New Part.', 16, 1, @QuoteNumber)
	rollback transaction
	return

end
--- </Body>


if @@TRANCOUNT > 0  
    commit transaction;  
GO
