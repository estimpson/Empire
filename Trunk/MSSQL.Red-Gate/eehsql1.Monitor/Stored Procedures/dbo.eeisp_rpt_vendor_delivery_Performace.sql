SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure	[dbo].[eeisp_rpt_vendor_delivery_Performace] (@startdate datetime)
 
 as
Begin
 	
 	declare 			@currentweekno integer,
 					@startweekno integer
 					
 			select @currentweekno = 	datediff(wk,'1999/01/03', getdate() ) 	
 			select @startweekno = 		datediff(wk,'1999/01/03', @startdate ) 	
 			
 			delete	eei_weekly_receipts
 			where	weekno >=(@currentweekno-10)
 			
 			delete	eei_weekly_accumreceipts
 			
 			
 			
 
 Insert 	eei_weekly_receipts
																
	
 Select	sum(quantity), 
			audit_trail.part,
			convert(int, po_number) as i_poNumber,
			datediff(wk,'1999/01/03', date_stamp ) as weekNo
from		audit_trail
join		FT.HighFABAuthorizations on audit_trail.part = FT.HighFABAuthorizations.part and audit_trail.po_number = convert(varchar(20), FT.HighFABAuthorizations.PONumber)
where	type = 'R'  and datediff(wk,'1999/01/03', date_stamp ) >=(@currentweekno-10)
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


select	releaseplanID, 
			PONumber, 
			Part, 
			WeekNo, 
			AuthorizedAccum, 
			(Select generatedweekno from FT.ReleasePlans where id =  ReleaseplanID )  as GeneratedWeek
into		#Auths
from		FT.FABAuthorizations where
			releaseplanID in (select min(id) from FT.ReleasePlans group by generatedweekno) and
			Weekno >= 	@startweekno 

select  FT.Releaseplans.id,
			FT.releaseplans.GeneratedDT,
			FT.releaseplans.GeneratedWeekNo,
			FT.ReleaseplanRaw.weekNo,
			FT.ReleaseplanRaw.PONumber,
			FT.ReleaseplanRaw.Part,
			FT.ReleaseplanRaw.PostAccum

into #rawreleases			
			 
from	FT.ReleasePlans
						
JOIN		FT.ReleaseplanRaw on FT.ReleasePlans.ID = FT.ReleaseplanRaw.ReleaseplanID
where	FT.releaseplans.GeneratedWeekNo>= (select min(generatedweek) from #auths) and
			FT.ReleasePlans.id in (select min(id) from FT.ReleasePlans group by generatedweekno)



select		authorizations.PONumber,
				vendor.code,
				authorizations.part,
				authorizations.weekno,
				vendor.name,
				(select		max(PostAccum) 
					from		#rawreleases
					where	#rawreleases.GeneratedWeekNo Between Authorizations.GeneratedWeek and Authorizations.WeekNo and
								#rawreleases.Part = Authorizations.part and
								#rawreleases.POnumber = Authorizations.PONumber and
								#rawreleases.WeekNo = (select		max(WeekNo) 
																			from		#rawreleases
																			where	#rawreleases.GeneratedWeekNo Between Authorizations.GeneratedWeek and Authorizations.WeekNo and
																						#rawreleases.Part = Authorizations.part and
																						#rawreleases.POnumber = Authorizations.PONumber and
																						#rawreleases.WeekNo <= Authorizations.WeekNo and
																						#rawreleases.GeneratedWeekNo <=(Select	max(GeneratedWeekNo) 
																																								from		#rawreleases
																																								where	#rawreleases.GeneratedWeekNo Between Authorizations.GeneratedWeek and Authorizations.WeekNo and
																																											#rawreleases.Part = Authorizations.part and
																																											#rawreleases.POnumber = Authorizations.PONumber ) )) as lastAccumoninsidelead,
				authorizations.AuthorizedAccum,
				authorizations.releaseplanID,
				FT.HighFABauthorizations.AuthorizedAccum as HighFAB,
				isNULL(eei_weekly_receipts.Qty,0) as WeeklyReceived,
				isNULL((Select sum(qty)
									from 		eei_weekly_receipts eeiwr
									where		eeiwr.ponumber = Authorizations.ponumber and
													eeiwr.part = Authorizations.part and
													eeiwr.weekno<=Authorizations.weekno),0) as weeklyaccumReceived,
					FT.POReceiptTotals.lastreceivedDT as lastRecDate,
					vendor.phone,
 					vendor.contact,
 					vendor.address_1,
 					vendor.address_2,
 					vendor.address_3,
					(select	max(WeekNo) 
						from		#rawreleases
						where	#rawreleases.GeneratedWeekNo Between Authorizations.GeneratedWeek and Authorizations.WeekNo and
									#rawreleases.Part = Authorizations.part and
									#rawreleases.POnumber = Authorizations.PONumber and
									#rawreleases.WeekNo <= Authorizations.WeekNo and
									#rawreleases.GeneratedWeekNo <=(Select	max(GeneratedWeekNo) 
																							from		#rawreleases 
																							where	#rawreleases.GeneratedWeekNo Between Authorizations.GeneratedWeek and Authorizations.WeekNo and
																										#rawreleases.Part = Authorizations.part and
																										#rawreleases.POnumber = Authorizations.PONumber ) ) as lastweekGenAccum,
				(Authorizations.weekno - Authorizations.generatedweek) as firmWeeks,
				
				
				(select		max(PostAccum) 
					from		#rawreleases
					where	#rawreleases.GeneratedWeekNo Between Authorizations.GeneratedWeek and Authorizations.WeekNo and
								#rawreleases.Part = Authorizations.part and
								#rawreleases.POnumber = Authorizations.PONumber and
								#rawreleases.WeekNo <= Authorizations.WeekNo) as highestAccumoninsidelead,

				(select		min(PostAccum) 
					from		#rawreleases
					where	#rawreleases.GeneratedWeekNo Between Authorizations.GeneratedWeek and Authorizations.WeekNo and
								#rawreleases.Part = Authorizations.part and
								#rawreleases.POnumber = Authorizations.PONumber and
								#rawreleases.WeekNo <= Authorizations.WeekNo and
								#rawreleases.WeekNo = (select	max(WeekNo) 
																			from		#rawreleases
																			where	#rawreleases.GeneratedWeekNo Between Authorizations.GeneratedWeek and Authorizations.WeekNo and
																						#rawreleases.Part = Authorizations.part and
																						#rawreleases.POnumber = Authorizations.PONumber and
																						#rawreleases.WeekNo <= Authorizations.WeekNo )) as lowestAccumoninsidelead,
				
					 (CASE WHEN (select		count(1) 
										from		#rawreleases
										where	#rawreleases.GeneratedWeekNo Between Authorizations.GeneratedWeek and Authorizations.WeekNo and
													#rawreleases.Part = Authorizations.part and
													#rawreleases.POnumber = Authorizations.PONumber and
													#rawreleases.WeekNo <= Authorizations.WeekNo)>0 THEN 1 ELSE 0 END) as evaluate

from		#Auths  Authorizations
			JOIN FT.HighFabauthorizations on Authorizations.PONumber = FT.HighFabauthorizations.PoNumber and Authorizations.Part = FT.HighFabauthorizations.Part
			LEFT OUTER JOIN dbo.eei_weekly_receipts ON Authorizations.PONumber=eei_weekly_receipts.ponumber and Authorizations.part=eei_weekly_receipts.part and Authorizations.Weekno = eei_weekly_receipts.weekno
 			JOIN dbo.po_header po_header ON Authorizations.PONumber=po_header.po_number 
 			JOIN dbo.vendor vendor ON po_header.vendor_code=vendor.code
			LEFT OUTER JOIN 	 FT.POReceiptTotals on Authorizations.PONumber =FT.POReceiptTotals.PONumber and Authorizations.Part=FT.POReceiptTotals.Part
			WHERE  po_header.type = 'B' and   Authorizations.AuthorizedAccum > 0 and
						Authorizations.Weekno < @currentweekno

End
GO
