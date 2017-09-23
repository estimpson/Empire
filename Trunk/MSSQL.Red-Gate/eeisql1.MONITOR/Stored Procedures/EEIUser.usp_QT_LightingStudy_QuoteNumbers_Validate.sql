SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_LightingStudy_QuoteNumbers_Validate]
	@QuoteNumber varchar(50)
,	@Application varchar(50)
,	@Program varchar(50)
,	@LedHarness varchar(50)
,	@Sop datetime
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
if (@Program <> '') begin

	declare 
		@ID int = null
		
	select
		@ID = qn.LightingStudyId
	from
		EEIUser.QT_LightingStudy_QuoteNumbers qn
	where
		qn.QuoteNumber = @QuoteNumber
		and qn.[Application] = @Application
		and qn.Program = @Program
		and qn.LEDHarness = @LedHarness
		and qn.Sop = @Sop
		
	if (@ID is not null) begin
		set	@Result = 99
		RAISERROR ('This quote number is already tied to this Lighting Study record.', 16, 1)
		rollback tran @ProcName
		return	
	end
	
end
else begin

	if exists (
			select
				1
			from
				EEIUser.QT_LightingStudy_QuoteNumbers qn
			where
				qn.QuoteNumber = @QuoteNumber
				and qn.[Application] = @Application ) begin
		
		set	@Result = 99
		RAISERROR ('This quote number is already tied to this lighting study application.', 16, 1)
		rollback tran @ProcName
		return
	end

end
---	</ArgumentValidation>


--- <Body>
select
	hl.ID
from
	EEIUser.ST_LightingStudy_Hitlist_2016 hl
where
	hl.[Application] = @Application
	and hl.Program = @Program
	and hl.[LED/Harness] = @LedHarness
	and hl.Sop = @Sop
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
