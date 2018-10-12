SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[pf_monthly_report] (@fiscalyear int, @fiscalperiod int)
as
set nocount on
set ansi_warnings on
set ansi_nulls on
set transaction isolation level read uncommitted

-- exec pf_monthly_report 2011, 7

--------------------------------------------------------------------------------------------------------------------------------------------------
/*  1. Create a Temp Table to store the G/L Activity from both databases and decrease query cost on string conversions  */											
--------------------------------------------------------------------------------------------------------------------------------------------------

create table #PF_GL_Activity
(	document_type varchar(25) not null 
,	document_id1 varchar(25) not null 
,	document_id2 varchar(25) not null 
,	document_id3 varchar(25) not null
,	document_line smallint not null
,	ledger_account varchar(50) not null
,	contract_id varchar(25) not null
,	contract_account_id varchar(25) not null
,	costrevenue_type_id varchar(25) not null
,	tracking_no varchar(30)
,	document_remarks text
,	document_amount decimal(18,6)
,	document_currency varchar(25)
,	amount decimal(18,6)
)



--------------------------------------------------------------------------------------------------------------------------------------------------
/*  2. Get the G/L Activity from eehsql1 for the month and year specified  */																							
--------------------------------------------------------------------------------------------------------------------------------------------------

insert	#PF_GL_Activity

select	document_type,
		document_id1,		
		document_id2,
		document_id3,
		document_line,
		ledger_account,
		contract_id,
		contract_account_id,
		costrevenue_type_id,
		left(convert(varchar(25),document_remarks),case patindex('%*%',document_remarks) when 0 then 0 else PATINDEX('%*%',document_remarks)-1 end) as tracking_no,
		document_remarks,  
		document_amount,
		document_currency,
		amount
from	gl_cost_transactions 
where	fiscal_year = @fiscalyear and period = @fiscalperiod and ledger_account in ('504012','504512','505012','505512') and update_balances = 'Y'



--------------------------------------------------------------------------------------------------------------------------------------------------
/*  3. Get the G/L Activity from eeisql1 for the month and year specified  */																						
--------------------------------------------------------------------------------------------------------------------------------------------------

insert	#PF_GL_Activity

select	document_type,
		document_id1,		
		document_id2,
		document_id3,
		document_line,
		ledger_account,
		contract_id,
		contract_account_id,
		costrevenue_type_id,
		left(convert(varchar(25),document_remarks),case patindex('%*%',document_remarks) when 0 then 0 else PATINDEX('%*%',document_remarks)-1 end) as tracking_no,
		document_remarks,  
		document_amount,
		document_currency,
		amount
from	eeisql1.monitor.dbo.gl_cost_transactions 
where	fiscal_year = @fiscalyear and period = @fiscalperiod and ledger_account in ('504011','504511','505011','505511','504021','504521','505021','505521','504060','504560','505060','505560') and update_balances = 'Y'



--------------------------------------------------------------------------------------------------------------------------------------------------
/*  4. Match the Premium Freight Authorization Detail to the G/L Activity  */																	
--------------------------------------------------------------------------------------------------------------------------------------------------

select	right(ledger_account,2) as company
		,ledger_account
		,document_type
		,document_id2
		,document_id1
		,tracking_no
		,amount
		,contract_account_id
		,document_remarks
		,document_currency
		,id
		,ReqBy
		,ReqDate
		,AuthBy
		,AuthDate
		,Reason
		,AccountType
		,Carrier
		,accountno
		,priority
		,estimatedcost
		,estimatedShipDate
		,Tracking
		,shipfrom
		,shipfrom_Customer
		,shipfrom_City
		,shipfrom_State
		,shipfrom_ZIP
		,ShipFrom_Contact
		,ShipFrom_Phone
		,shipto
		,shipto_customer
		,ShipTo_City
		,ShipTo_State
		,ShipTo_ZIP
		,ShipTo_Contact
		,ShipTo_Phone
		,budgetType		
		,budgetno
		,budgetmethod
		,po
		,shipmentaccount
		,reimbursed
		,rebill

from	#PF_GL_Activity
	left join eeh.dbo.pf_master on #pf_gl_activity.tracking_no = NULLIF(eeh.dbo.pf_master.tracking,'')
	




GO
