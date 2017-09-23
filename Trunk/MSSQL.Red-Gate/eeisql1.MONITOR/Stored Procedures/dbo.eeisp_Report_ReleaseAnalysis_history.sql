SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[eeisp_Report_ReleaseAnalysis_history]  (@weekshistory integer)

as
/*
Arguments:
Customer Code.

Result set:
Current Release Plan Compared to last Release Plan Generated for Prior Week

Description:
I. Calls Procedure to take current snapshot of order detail.
II. Gets last release snap shot from prior week and joins on current snap shot of order_detail (grouped by delivery week - analysis is done by week)
	into temp table.
III. Selects data from temp table.

Author:
Andre S. Boulanger
Copyright © Empire Electronics, Inc.


Andre S. Boulanger May 23, 2004

Process:
--	Declarations.
--	I.		Create Snapshot of current Customer Release Plan. Fill variables. Create temp tables
--	II.		Select last snap shot into #releasehistory.
--	III.	Select from history tables for result set
*/


begin

declare	@CustomerReleasePlanID 	integer,
				@currentweek						integer




---- I
---- This procedure creates rows in currentcustomerreleaseplan and customerreleaseplanraw
	
	
--	execute	csp_RecordCustomerReleasePlan
--	@CustomerReleasePlanID = @CustomerReleasePlanID output
	
	Select @currentweek =  DateDiff ( week, (	select	FT.DTGlobals.Value
																			from	FT.DTGlobals
																		where	FT.DTGlobals.Name = 'BaseWeek' ), GetDate ( ) )
	
	
	Create table #releasehistory (
						releaseplanid 	integer,
						orderNumber	integer,
						WeekNo			integer,
						
						primary key
					(	ReleasePlanID,
						OrderNumber,
						WeekNo						 ) )
---- II.						
----		Get last release for just current orders considered				
		Insert	#releasehistory
		Select	distinct 	Max(releaseplanid),
		ordernumber,
		weekNo
		from		CustomerReleasePlanRaw
		where	currentweek>= 300
		and		ordernumber in (Select 	ordernumber
												from		currentcustomerreleaseplan) 
		group by ordernumber, currentweek, weekNo
order by 1, 2
						
--	III					
----		Get data from current and last to compare				
						Select	CRPRAw.ordernumber as currentorderno,
									CRPRAw.part as currentreleasepart,
									dateadd(dd,((CRPRAw.currentweek*7)+1), '1999/01/03')	 as releaseweek,
									dateadd(dd,((CRPRAw.weekno*7)+1), '1999/01/03')	 as currentreleaseweekdue,
									max(CRPRAw.postaccum)  as currentaccumdueforweek,
									(Select max(description)
										from	user_definable_data
										Where	module = 'CM' and
													sequence = 2 and
													code = customer.custom2) as CustomerGroup,
													
									Customer.Customer,
									Customer.name,
									Customer.contact,
									Customer.phone,
									order_header.customer_po,
									max(AccumShipped),
									FirmWeeks,
									FABWeeks,
									MATWeeks,
									order_header.customer_part
									
						from		CustomerReleasePlanRaw CRPRAw
									join #releasehistory
										on CRPRAw.releaseplanID= #releasehistory.releaseplanID and
										CRPRAw.ordernumber = #releasehistory.ordernumber and
										CRPRAw.weekno = #releasehistory.weekno
									join order_header
										on order_header.order_no = CRPRAw.ordernumber
									left join part_customer
										on order_header.customer = part_customer.customer
										and order_header.blanket_part = part_customer.part
									join Customer
										on order_header.customer = customer.customer

									group by 
									
									CRPRAw.ordernumber,
									CRPRAw.part ,
									CRPRAw.weekno,
									dateadd(dd,((CRPRAw.weekno*7)+1), '1999/01/03'),
									custom2,
									Customer.Customer,
									Customer.name,
									Customer.contact,
									Customer.phone,
									order_header.customer_po,
									FirmWeeks,
									FABWeeks,
									MATWeeks,
									CRPRAw.currentweek,
									dateadd(dd,((CRPRAw.currentweek*7)+1), '1999/01/03'),
									order_header.customer_part
									
									having dateadd(dd,((CRPRAw.weekno*7)+1), '1999/01/03')> '2005/01/01'
									
									
				
									
									order by 1,2,3,4
									
				
									 								
									
end
															
									
									
									
									
	
	
	
GO
