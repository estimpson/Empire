SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure	[dbo].[eeisp_rpt_arscloseout] 
 
 as
Begin
 	
 	declare 	@currentweekno integer
 					
 					
 			select @currentweekno = 	datediff(wk,'1999/01/03', getdate() ) 	
 				
 			
 			delete	eei_weekly_receipts
 			where	weekno >=(@currentweekno-3)
 			
 			delete	eei_weekly_accumreceipts
 			
 			
 			
 
 Insert 	eei_weekly_receipts
																
	
 Select	sum(quantity), 
			audit_trail.part,
			convert(int, po_number) as i_poNumber,
			datediff(wk,'1999/01/03', date_stamp ) as weekNo
from		audit_trail
join		FT.HighFABAuthorizations on audit_trail.part = FT.HighFABAuthorizations.part and audit_trail.po_number = convert(varchar(20), FT.HighFABAuthorizations.PONumber)
where	type = 'R'  and datediff(wk,'1999/01/03', date_stamp ) >=(@currentweekno-3)
group by	audit_trail.part,
				convert(int, po_number),
				datediff(wk,'1999/01/03', date_stamp ) 
				
				delete eei_weekly_accumreceipts
				
				insert  eei_weekly_accumreceipts
Select ponumber,
			part,
			weekno,
			isNULL((Select sum(qty)
				from eei_weekly_receipts eeiwr
			where	eeiwr.ponumber = eei_weekly_receipts.ponumber and
						eeiwr.part = eei_weekly_receipts.part and
						eeiwr.weekno<=eei_weekly_receipts.weekno),0)
from		eei_weekly_receipts


Create table #Authorizations(
						AuthatLeadTime	numeric (20,6),
						AuthReleasePlanID	integer,
						PONumber				integer,
						Part							varchar(25),
						WeekNo					integer,
						HighFAB					numeric (20,6),
						WeekNoPrior			integer,
						primary key
						(	AuthReleasePlanID,
							PONumber,
							Part ))
							
	create index idx_authorizations on #Authorizations ( WeekNo )
						
Insert	#Authorizations


select		max(FT.FABAuthorizations.authorizedAccum), 
				min(FT.FABauthorizations.ReleasePlanID), 
				FT.FABAuthorizations.PONumber,
				FT.FABAuthorizations.Part,
				FT.FABAuthorizations.weekNo, 
				FT.HighFABauthorizations.AuthorizedAccum as HighestAccumAuth,
				isNULL((select 	max(generatedWeekNo)
 					   from		FT.releaseplans
 					   JOIN		FT.ReleaseplanRaw on FT.releaseplans.id = FT.ReleaseplanRaw.ReleasePlanID
 					   where	FT.ReleasePLanRAW.PArt = 	FT.FABAuthorizations.part and	
 					   				FT.ReleasePLanRAW.PONumber = 	FT.FABAuthorizations.POnumber and
 					   				FT.ReleasePlanRaw.WeekNo <= @currentWeekno and
 					   				FT.ReleasePlanRaw.WeekNo >= (@currentWeekno-2) and
 					   				generatedweekno<= (FT.FABAuthorizations.WeekNo-2)),0)
from			FT.FABAuthorizations,
				FT.HighFABAuthorizations
where 		FT.FABAuthorizations.weekNo >= @currentWeekno  and
				FT.FABAuthorizations.AuthorizedAccum > 0 and
				FT.FABAuthorizations.PONumber = FT.HighFABauthorizations.PONumber and
				FT.FABAuthorizations.Part = Ft.HighFABauthorizations.Part			 
group by FT.FABAuthorizations.PONumber,FT.FABAuthorizations.Part, FT.FABAuthorizations.weekno, Ft.HighFABauthorizations.AuthorizedAccum
order by FT.FABAuthorizations.PONumber, FT.FABAuthorizations.WeekNo


Create table #RawReleases(
						PONumber					integer,
						Part								varchar(25),
						WeekNo						integer,
						MaxPostAccum			numeric (20,6),
						MinPostAccum				numeric(20,6),
						ReleaseplanID				integer,
						primary key
						(	ReleasePlanID,
							PONumber,
							Part,
							WeekNo ))
							
	create index idx_rawreleases on #RawReleases ( WeekNo )
						
Insert			#RawReleases
select			PONumber,
					Part,
					WeekNo,
					min(PostAccum),
					max(PostAccum),
					ReleaseplanID
					
from				FT.ReleaseplanRaw
JOIN				FT.ReleasePlans on FT.ReleaseplanRaw.ReleasePlanID = FT.ReleasePlans.ID
where			FT.ReleasePlans.ID >= (Select min(AuthReleasePlanID) from #Authorizations)
Group by		PONumber,
					Part,
					WeekNo,
					ReleaseplanID
					
order by		PONumber,
					Part,
					WeekNo

				
 



SELECT 		Authorizations.PONumber, 
 					vendor.code, 
 					Authorizations.Part, 
 					Authorizations.WeekNo, 
 					vendor.name,
 					isNULL((Select 	max(maxPostAccum)
 					  from		#RawReleases
							JOIN		FT.ReleasePlans on #RawReleases.ReleasePlanID = FT.ReleasePlans.ID
 					  where	FT.ReleasePlans.GeneratedWeekNo = Authorizations.WeekNoPrior and
 					  				#RawReleases.Part = Authorizations.Part and
 					  				#RawReleases.PONumber = Authorizations.PONumber and
 					  				#RawReleases.Weekno <= Authorizations.WeekNo ),0) as LastAccumGenInsideLead, 
 					Authorizations.AuthatLeadTime, 
 					Authorizations.AuthReleasePlanID, 
 					Authorizations.HighFAB,
 					isNULL(eei_weekly_receipts.Qty,0) as WeeklyReceived,
 					isNULL((Select sum(qty)
									from 		eei_weekly_receipts eeiwr
									where		eeiwr.ponumber = Authorizations.ponumber and
													eeiwr.part = Authorizations.part and
													eeiwr.weekno<=Authorizations.weekno),0) as WeeklyAccumReceived, 
 					FT.POReceiptTotals.lastreceivedDT as lastRecDate, 
 					vendor.phone,
 					vendor.contact,
 					vendor.address_1,
 					vendor.address_2,
 					vendor.address_3,
 					WeekNoPrior,
 					(select max(FABAuthDays)
 						from	part_vendor
 						where	part_vendor.vendor = vendor.code and
 									part_vendor.part = Authorizations.part) as FirmDays,
		eeivw_ars_exception_noorderstatus.non_order_note,
	eeivw_ars_exception_noorderstatus.total_Net_demand,
	eeivw_ars_exception_noorderstatus.total_on_DefaultPO,
	eeivw_ars_exception_noorderstatus.total_not_on_DefaultPO,
	eeivw_ars_exception_noorderstatus.stdpack,
	dateadd(wk,Authorizations.WeekNo, '1999/01/03' )
	
 					
 FROM   		eeivw_ars_exception_noorderstatus
 					JOIN		#Authorizations Authorizations on eeivw_ars_exception_noorderstatus.part = Authorizations.part
 					LEFT OUTER JOIN dbo.eei_weekly_receipts ON Authorizations.PONumber=eei_weekly_receipts.ponumber and Authorizations.part=eei_weekly_receipts.part and Authorizations.Weekno = eei_weekly_receipts.weekno
 					JOIN dbo.po_header po_header ON Authorizations.PONumber=po_header.po_number 
 					JOIN dbo.vendor vendor ON po_header.vendor_code=vendor.code
					LEFT OUTER JOIN 	 FT.POReceiptTotals on Authorizations.PONumber =FT.POReceiptTotals.PONumber and Authorizations.Part=FT.POReceiptTotals.Part
					WHERE Authorizations.WeekNo >= @currentWeekno and po_header.type = 'B'
 ORDER BY vendor.code, Authorizations.PONumber, Authorizations.WeekNo

End
GO
