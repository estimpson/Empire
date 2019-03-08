SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [EEIUser].[acctg_csm_sp_validate_release]
	@OperatorCode varchar(5)
,	@CurrentRelease char(7)
,	@Region varchar(255)
,	@Message varchar(500) out
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
/* Make sure data has not already been rolled forward and imported for this release and region */
if exists ( 
		select
			coalesce(h.RolledForward, 0)
		from
			acctg_csm_NAIHS_header h
		where
			h.Region = @Region
			and h.Release_ID = @CurrentRelease
			and h.RolledForward = 1 ) begin

	set	@Result = 999999
	RAISERROR ('%s CSM data has already been rolled forward and imported for release %s.  Procedure %s.', 16, 1, @Region, @CurrentRelease, @ProcName)
	rollback tran @ProcName
	return
end

/* Make sure data has not already been imported for this release and region */
if exists ( 
		select
			*
		from
			acctg_csm_NAIHS_header h
		where
			h.Region = @Region
			and h.Release_ID = @CurrentRelease ) begin

	set	@Result = 999999
	RAISERROR ('%s CSM data has already been imported (but not rolled forward) for release %s.  Procedure %s.', 16, 1, @Region, @CurrentRelease, @ProcName)
	rollback tran @ProcName
	return
end


/* Check whether the current release is one month later than the last imported release for the region */
declare
	@PriorRelease char(7)
,	@PriorReleaseDT datetime
,	@CurrentReleaseDT datetime

select
	@PriorRelease = max(h.Release_ID)
from
	eeiuser.acctg_csm_NAIHS_header h
where
	h.[Version] = 'CSM'
	and h.Region = @Region

select @PriorReleaseDT = convert(datetime, (substring(@PriorRelease, 1, 4) + substring(@PriorRelease, 6, 2) + '01'))
select @CurrentReleaseDT = convert(datetime, (substring(@CurrentRelease, 1, 4) + substring(@CurrentRelease, 6, 2) + '01'))

if (@PriorReleaseDT <> dateadd(month, -1, @CurrentReleaseDT) ) begin
   set @Message = 'The last CSM release imported for ' + @Region + ' is ' + @PriorRelease + '. Is the current release correct?'
end
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
