SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[acctg_csm_sp_base_prices_insert]
	@OperatorCode varchar(5)
,	@TranDT datetime = null out
,	@Result integer = null  out
as
set nocount on
set ansi_warnings on
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDIStanley.usp_Test
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
if not exists (
		select
			*
		from
			dbo.employee e
		where	
			e.operator_code = @OperatorCode ) begin

	set	@Result = 999999
	RAISERROR ('Invalid operator code.  Procedure %s.', 16, 1, @ProcName)
	rollback tran @ProcName
	return
end
---	</ArgumentValidation>


--- <Body>
-- Insert from new job build into base prices table - new parts, awarded quotes
declare @temp table
(
	QuoteNumber varchar(50)
,	BasePart char(7)
,	WOEngineerID int
,	EEHShipDate datetime
)

insert into @temp
(
	QuoteNumber
,	BasePart
,	WOEngineerID
,	EEHShipDate
)
select
	*
from
	openquery(eehsql1, '
select
	rtrim(wo.QuoteNumber)
,	min(left(wo.Part, 7))
,	min(wo.WOEngineerID)
,	min(wop.EEHShipDate)
from
	eeh.dbo.ENG_WOEngineer wo
	join eeh.dbo.ENG_WOAPQP wop
		on wop.WOEngineerID = wo.WOEngineerID
			and wop.EEHShipDate is not null
where
	wo.QuoteNumber is not null
group by
	wo.QuoteNumber
	'
)


--- <Insert>
set	@TableName = 'eeiuser.acctg_csm_base_prices'	
insert into eeiuser.acctg_csm_base_prices
(	BasePart
,	QuoteNumber 
,	Price
,	EffectiveDT 
)
select
	t.BasePart
,	min(t.QuoteNumber)
,	max(coalesce(ql.QuotePrice, 0))
,	min(t.EEHShipDate)
from
	@temp t
	join eeiuser.QT_QuoteLog ql
		on ql.QuoteNumber = t.QuoteNumber
	left join eeiuser.acctg_csm_base_prices bp
		on bp.BasePart = t.BasePart
where
	bp.BasePart is null
	and left(isnull(ql.Awarded, ''), 1) = 'Y'
	and t.EEHShipDate = (
			select
				min(t2.EEHShipDate)
			from
				@temp t2
			where
				t2.BasePart = t.BasePart )
group by
	t.BasePart


select
	@Error = @@Error,
	@RowCount = @@Rowcount
	
if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount = 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: >0.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Insert>
--- </Body>



---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>
GO
