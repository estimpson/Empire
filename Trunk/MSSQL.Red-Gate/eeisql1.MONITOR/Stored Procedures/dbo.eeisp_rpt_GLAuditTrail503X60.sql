SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE Procedure [dbo].[eeisp_rpt_GLAuditTrail503X60] (@FiscalYear int, @Period int)
as
Begin

--exec eeisp_rpt_GLAuditTrail503X11 2009,1 

Declare	@firstdayofCurrentMonth datetime,
		@firstdayofNextMonth datetime

Select	@firstdayofCurrentMonth = convert(datetime, convert(varchar(4),@FiscalYear)+'-'+convert(varchar(2),@Period)+'-'+'1')
Select	@firstdayofNextMonth = dateadd(m,1, @firstdayofCurrentMonth)
--Select	@firstdayofCurrentMonth
--Select	@firstdayofNextMonth

create table #GLCostTransactions 
(	Serial	int,
	LedgerAccount	varchar(25),
	LineID	int,
	Part		varchar (1000),
	PartName	varchar(1000),
	DateStamp datetime,
	Type char (2) null,
	GLNote varchar(255) null,
	Cost numeric (20,6) null,
	primary key (Serial, DateStamp, LineID))

create  table #AuditTrail
(	Serial	int,
	Part varchar(25),
	DateStamp datetime,
	Notes	varchar(255) null,
	Operator varchar(5) ,
	Type	char(1),
	StdQty	numeric(20,6),
	primary key (Serial, DateStamp))

insert	#GLCostTransactions

Select	(CASE WHEN document_type like 'Journal Entry%' THEN substring(document_id1, 3, 10) ELSE document_id1 END) as document_id1,
		ledger_account,
		document_line,
		(CASE WHEN document_type = 'Journal Entry' THEN document_id1 ELSE document_reference1 END) as document_reference1,
		document_reference2,
		case	when	document_type = 'MON INV' and
				IsDate (document_id2) = 1
			then	convert (datetime, document_id2)
			else	transaction_date
		end,
		(CASE WHEN document_type = 'Journal Entry' THEN 'JE' ELSE document_id3 END) as document_id3,
		(CASE WHEN document_type = 'Journal Entry' THEN document_remarks ELSE NULL END) as GLnote,
		amount
		
		
from		gl_cost_transactions
where	fiscal_year =@FiscalYear and 
		period = @Period and 
		document_type in( 'MON INV', 'Journal Entry') and 
		ledger_account in  ('503060', '503560')


insert	#AuditTrail
Select	serial,
		part,
		date_stamp,
		notes,
		operator,
		type,
		std_quantity
from		audit_trail 
where	type = 'Q' and
		to_loc = 'S'
and		date_stamp >= @firstdayofCurrentMonth and
		date_stamp<@firstdayofNextMonth
UNION
Select	serial,
		part,
		date_stamp,
		notes,
		operator,
		type,
		std_quantity
from		audit_trail 
where	type = 'A' 
and		date_stamp >= @firstdayofCurrentMonth and
		date_stamp<@firstdayofNextMonth


Select	GLCT.Serial,
		GLCT.LedgerAccount,
		GLCT.LineID,
		COALESCE(GLCT.part,AT.Part) as Part	,
		GLCT.PartName,
		GLCT.DateStamp,
		GLCT.Type,
		COALESCE(GLCT.GLNote,AT.Notes) as Note ,
		GLCT.Cost,
		AT.Serial,
		AT.DateStamp,
		AT.Operator ,
		AT.Type,
		AT.StdQty
from		#GLCostTransactions GLCT
left	join	#AuditTrail AT on GLCT.serial = AT.Serial and GLCT.DateStamp = AT.DateStamp 
End


GO
