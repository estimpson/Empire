SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [EEIUser].[freight_update_pfa]
	@PFA_ID varchar(15)
,	@PFA_DATE datetime = null
,	@PFA_STATUS varchar(25) = null
,	@REQUSTOR varchar(50) = null
,	@APPROVER varchar(50) = null
,	@FROM_PARETTO varchar(25) = null
,	@FROM_NAME varchar(100) = null
,	@FROM_STREET_ADDRESS varchar(100) = null
,	@FROM_CITY varchar(100) = null
,	@FROM_STATE varchar(50) = null
,	@FROM_PROVINCE varchar(50) = null
,	@FROM_ZIP_CODE varchar(10) = null
,	@FROM_COUNTRY varchar(50) = null
,	@FROM_CONTACT varchar(50) = null
,	@FROM_CONTACT_PHONE varchar(25) = null
,	@TO_PARETTO varchar(25) = null
,	@TO_NAME varchar(100) = null
,	@TO_STREET_ADDRESS varchar(100) = null
,	@TO_CITY varchar(100) = null
,	@TO_STATE varchar(50) = null
,	@TO_PROVINCE varchar(50) = null
,	@TO_ZIP_CODE varchar(10) = null
,	@TO_COUNTRY varchar(50) = null
,	@TO_CONTACT varchar(50) = null
,	@TO_CONTACT_PHONE varchar(25) = null
,	@CONTENT_PARETTO varchar(100) = null
,	@PART varchar(200) = null
,	@PART_DESCRIPTION varchar(200) = null
,	@QTY varchar(50) = null
,	@QTY_UOM varchar(10) = null
,	@EST_WEIGHT decimal(18,6) = null
,	@WEIGHT_UOM varchar(10) = null
,	@BOXES decimal(18,6) = null
,	@LENGTH decimal(18,6) = null
,	@WIDTH decimal(18,6) = null
,	@HEIGHT decimal(18,6) = null
,	@REQUIRED_ARRIVAL_DATE datetime = null
,	@CML_ITEM varchar(3) = null
,	@CML_DATE datetime = null
,	@FG_CUSTOMER_PARETTO varchar(3) = null
,	@FG_WHERE_USED varchar(200) = null
,	@FG_LINE_DOWN varchar(3) = null
,	@EMPIRE_COMPANY varchar(3) = null
,	@ROOT_CAUSE_PARETTO varchar(100) = null
,	@ROOT_CAUSE varchar(max) = null
,	@QI_NUMBER varchar(50) = null
,	@QI_NOTES varchar(100) = null
,	@QI_CONTACT varchar(50) = null
,	@QI_CONTACT_EMAIL varchar(50) = null
,	@CORRECTIVE_ACTION varchar(max) = null
,	@CA_CHAMPION varchar(100) = null
,	@CA_CHAMPION_EMAIL varchar(100) = null
,	@PREVENTIVE_ACTION varchar(max) = null
,	@PA_CHAMPION varchar(100) = null
,	@PA_CHAMPION_EMAIL varchar(100) = null
,	@RESONSIBLE_PARTY varchar(50) = null
,	@PAYMENT_METHOD varchar(100) = null
,	@CUSTOMER_PO varchar(50) = null
,	@CUSTOMER_PO_NOTES varchar(200) = null
,	@CUSTOMER_PO_BUYER varchar(50) = null
,	@CUSTOMER_PO_BUYER_EMAIL varchar(50) = null
,	@VENDOR_CHARGEBACK varchar(50) = null
,	@VENDOR_CHARGEBACK_NOTES varchar(200) = null
,	@VENDOR_CHARGEBACK_BUYER varchar(50) = null
,	@VENDOR_CHARGEBACK_BUYER_EMAIL varchar(50) = null
,	@OVERRIDE varchar(3) = null
,	@OVERRIDE_REASON varchar(200) = null
,	@OVERRIDE_APPROVER varchar(50) = null
,	@ATTACHMENT_LINK varchar(200) = null
,	@CARRIER varchar(25) = null
,	@MODE varchar(25) = null
,	@ACCOUNT_NUMBER varchar(100) = null
,	@SPECIAL_INSTRUCTIONS varchar(200) = null
,	@EST_COST decimal(18,6) = null
,	@TRACKING_NUMBER varchar(50) = null
,	@TranDT datetime = null out
,	@Result integer = null out
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
if exists (	select	1
			from	EEIUser.Freight_PFA
			where	PFA_ID = @PFA_ID) begin
	RAISERROR ('PFA ID %s does not exist in the system.', 16, 1, @PFA_ID)
	set	@Result = 999997
	rollback tran @ProcName
	return
end
---	</ArgumentValidation>

--- <Body>
--- <Update rows="1">
set	@TableName = 'EEIUser.Freight_PFA'

update
	pfa
set
	PFA_DATE = @PFA_DATE
,	PFA_STATUS = @PFA_STATUS
,	REQUESTOR = @REQUSTOR
,	APPROVER = @APPROVER
,	FROM_PARETTO = @FROM_PARETTO
,	FROM_NAME = @FROM_NAME
,	FROM_STREET_ADDRESS = @FROM_STREET_ADDRESS
,	FROM_CITY = @FROM_CITY
,	FROM_STATE = @FROM_STATE
,	FROM_PROVINCE = @FROM_PROVINCE
,	FROM_ZIP_CODE = @FROM_ZIP_CODE
,	FROM_COUNTRY = @FROM_COUNTRY
,	FROM_CONTACT = @FROM_CONTACT
,	FROM_CONTACT_PHONE = @FROM_CONTACT_PHONE
,	TO_PARETTO = @TO_PARETTO
,	TO_NAME = @TO_NAME
,	TO_STREET_ADDRESS = @TO_STREET_ADDRESS
,	TO_CITY = @TO_CITY
,	TO_STATE = @TO_STATE
,	TO_PROVINCE = @TO_PROVINCE
,	TO_ZIP_CODE = @TO_ZIP_CODE
,	TO_COUNTRY = @TO_COUNTRY
,	TO_CONTACT = @TO_CONTACT
,	TO_CONTACT_PHONE = @TO_CONTACT_PHONE
,	CONTENT_PARETTO = @CONTENT_PARETTO
,	PART = @PART
,	PART_DESCRIPTION = @PART_DESCRIPTION
,	QTY = @QTY
,	QTY_UOM = @QTY_UOM
,	EST_WEIGHT = @EST_WEIGHT
,	WEIGHT_UOM = @WEIGHT_UOM
,	BOXES = @BOXES
,	LENGTH = @LENGTH
,	WIDTH = @WIDTH
,	HEIGHT = @HEIGHT
,	REQUIRED_ARRIVAL_DATE = @REQUIRED_ARRIVAL_DATE
,	CML_ITEM = @CML_ITEM
,	CML_DATE = @CML_DATE
,	FG_CUSTOMER_PARETTO = @FG_CUSTOMER_PARETTO
,	FG_WHERE_USED = @FG_WHERE_USED
,	FG_LINE_DOWN = @FG_LINE_DOWN
,	EMPIRE_COMPANY = @EMPIRE_COMPANY
,	ROOT_CAUSE_PARETTO = @ROOT_CAUSE_PARETTO
,	ROOT_CAUSE = @ROOT_CAUSE
,	QI_NUMBER = @QI_NUMBER
,	QI_NOTES = @QI_NOTES
,	QI_CONTACT = @QI_CONTACT
,	QI_CONTACT_EMAIL = @QI_CONTACT_EMAIL
,	CORRECTIVE_ACTION = @CORRECTIVE_ACTION
,	CA_CHAMPION = @CA_CHAMPION
,	CA_CHAMPION_EMAIL = @CA_CHAMPION_EMAIL
,	PREVENTIVE_ACTION = @PREVENTIVE_ACTION
,	PA_CHAMPION = @PA_CHAMPION
,	PA_CHAMPION_EMAIL = @PA_CHAMPION_EMAIL
,	RESPONSIBLE_PARTY = @RESONSIBLE_PARTY
,	PAYMENT_METHOD = @PAYMENT_METHOD
,	CUSTOMER_PO = @CUSTOMER_PO
,	CUSTOMER_PO_NOTES = @CUSTOMER_PO_NOTES
,	CUSTOMER_PO_BUYER = @CUSTOMER_PO_BUYER
,	CUSTOMER_PO_BUYER_EMAIL = @CUSTOMER_PO_BUYER_EMAIL
,	VENDOR_CHARGEBACK = @VENDOR_CHARGEBACK
,	VENDOR_CHARGEBACK_NOTES = @VENDOR_CHARGEBACK_NOTES
,	VENDOR_CHARGEBACK_BUYER = @VENDOR_CHARGEBACK_BUYER
,	VENDOR_CHARGEBACK_BUYER_EMAIL = @VENDOR_CHARGEBACK_BUYER_EMAIL
,	OVERRIDE = @OVERRIDE
,	OVERRIDE_REASON = @OVERRIDE_REASON
,	OVERRIDE_APPROVER = @OVERRIDE_APPROVER
,	ATTACHMENT_LINK = @ATTACHMENT_LINK
,	CARRIER = @CARRIER
,	MODE = @MODE
,	ACCOUNT_NUMBER = @ACCOUNT_NUMBER
,	SPECIAL_INSTRUCTIONS = @SPECIAL_INSTRUCTIONS
,	EST_COST = @EST_COST
,	TRACKING_NUMBER = @TRACKING_NUMBER
from
	EEIUser.Freight_PFA pfa
where
	PFA_ID = @PFA_ID


select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999998
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
if	@RowCount != 1 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
	rollback tran @ProcName
	return
end
--- </Insert>
--- </Body>

--- <Tran AutoClose=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
--- </Tran>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>
GO
