SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [FT].[usp_APHeaderBarcodes_Get]
	@TranDT datetime out
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

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. custom.usp_Test
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
--- Begin by pulling any new AP records into the table
--- <Insert rows="*">
set	@TableName = 'FT.APHeaderBarcodes'

insert
	FT.APHeaderBarcodes
(	Vendor
,	InvCMFlag
,	InvoiceCM
)
select
	Vendor = aph.vendor
,	IvnCMFlag = aph.inv_cm_flag
,	InvoiceCM = aph.invoice_cm
from
	dbo.ap_headers aph
	left join FT.APHeaderBarcodes ahb
		on ahb.Vendor = aph.vendor
		and ahb.InvCMFlag = aph.inv_cm_flag
		and ahb.InvoiceCM = aph.invoice_cm
where
	ahb.InvoiceCM is null
	
select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Insert>


-- Retrieve all records where a barcode has not been printed
select
	ahb.RowID
,	ahb.Vendor
,	ahb.InvoiceCM
,	ahb.InvCMFlag
from
	FT.APHeaderBarcodes ahb
where
	ahb.Status = 0	
--- </Body>


--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction @ProcName
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	Success.
set	@Result = 0
return
	@Result
GO
