SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [EEIUser].[usp_ST_SalesLeadLog_Hitlist_SearchForSalesLeads]
	@HitlistId int
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

---	</ArgumentValidation>


--- <Body>
/*  For the selected sales opportunity (HitlistId), has a sales lead been created?  */
if exists ( 
		select	
			1
		from
			eeiuser.ST_SalesLeadLog_Header h
		where
			h.CombinedLightingId = @HitlistId
			and h.Status < 2 ) begin

	set	@Result = 100600
	RAISERROR ('A sales lead for this Customer/Program/Application already exists and has not yet been awarded or closed.', 16, 1)
	rollback tran @ProcName
	return
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
