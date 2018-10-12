SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure
[dbo].[eeisp_rpt_HighestAuthforNonAuthMaterial2] (@FABGeneratedDate datetime)
as
begin
  --declare @ReleasePlanID integer
  
  --execute FT.csp_RecordVendorReleasePlan @ReleasePlanID=
  --@ReleasePlanID
  
  create table #RawRelease(
    ReleasePlanID smallint null,
    PONumber smallint null,
    Part varchar(50) null,
    WeekNo smallint null,
    PostAccum numeric(20,6) null,
    )
  create index idx_rawRelease1 on #RawRelease(WeekNo asc)
  create index idx_rawRelease2 on #RawRelease(ReleasePlanID asc)
  create index idx_rawRelease3 on #RawRelease(Part asc,PONumber asc)
  create table #UnauthReceipts(
    poNumber integer null,
    Part varchar(25) null,
    Qty numeric(20,6) null,
    )
  create index idxunauthreceipts on #Unauthreceipts(Part asc,PONumber asc)
  insert into #Unauthreceipts
    select poNumber,
      part,
      sum(quantity)
      from nonauthorizedmaterial
      group by ponumber,part
	order by 1
  insert into #RawRelease
    select FT.ReleaseplanRaw.ReleasePlanID,
      FT.ReleaseplanRaw.PONumber,
      FT.ReleaseplanRaw.Part,
      Ft.ReleaseplanRaw.WeekNo,
      FT.ReleaseplanRaw.PostAccum
      from FT.ReleaseplanRaw join
      #Unauthreceipts on FT.ReleasePlanRaw.Part=#Unauthreceipts.part and FT.ReleasePlanRaw.PONumber=#Unauthreceipts.PONumber
      where ReleaseplanID in (select max(id) from FT.ReleasePlans group by GeneratedWeekNo)
      
     
    truncate table ReceiptAuthResults


insert ReceiptAuthResults

select 	FABAuthorizations.WeekNo,

    		Dateadd(wk,FABAuthorizations.WeekNo,'1999/01/03'),
    
    (		select RP2.GeneratedWeekNo 
    		from FT.ReleasePlans as RP2 
    		where RP2.ID=ReleasePlanID),
    	
    Dateadd(wk,(select RP2.GeneratedWeekNo 
    				from FT.ReleasePlans as RP2 
    					where RP2.ID=ReleasePlanID),'1999/01/03'),
    					
    		FABAuthorizations.PONumber,
    		
    		FABAuthorizations.Part,
    		
    		FABAuthorizations.AuthorizedAccum,
    		
    (		select 	max(postAccum) 
    		from 		FT.releasePlanRaw as RPR 
    		where 	RPR.WeekNo<=FABAuthorizations.weekNo and 
    						RPR.ReleasePlanID>=FABAuthorizations.ReleasePlanID and 
    						RPR.PONumber=FABAuthorizations.PONumber and 
    						RPR.part=FABAuthorizations.Part),
    						
    (		select 	max(FT.HighFABAuthorizations.AuthorizedAccum) 
    		from 		FT.HighFABAuthorizations 
    		where 	FT.HighFabAuthorizations.POnumber=FABAuthorizations.POnumber and 
    						FT.HighFabAuthorizations.Part=FABAuthorizations.Part),
    						
    		vendor.code,
    		
    		vendor.name,
    		
    		vendor.contact,
    		
    		vendor.phone,
    		
    		
    (		select max(FT.POReceiptTotals.STDQty) 
    		from 	FT.POReceiptTotals 
    		where FT.POReceiptTotals.POnumber=FABAuthorizations.POnumber and 
    					FT.POReceiptTotals.Part=FABAuthorizations.Part),
    					
    #UnauthReceipts.Qty,
    
    
    (		select 	max(FT.POReceiptTotals.LastReceivedDT) 
    		from 		FT.POReceiptTotals 
    		where 	FT.POReceiptTotals.POnumber=FABAuthorizations.POnumber and 
    						FT.POReceiptTotals.Part=FABAuthorizations.Part),
    						
    						
    isNULL((select 	sum(quantity) 
    				from 		po_detail 
    				where 	po_number=FABAuthorizations.POnumber and 
    								part_number=FABAuthorizations.Part),0),
    								
    (		select 	min(date_due) 
    		from 		po_detail 
    		where 	po_number=FABAuthorizations.POnumber and 
    						part_number=FABAuthorizations.Part),
    						
    (		select 	max(date_due) 
    		from 		po_detail 
    		where 	po_number=FABAuthorizations.POnumber and 
    						part_number=FABAuthorizations.Part),
    						
    (		Select 	FABAuthDays 
    		from 		part_vendor 
    		where 	part = po_header.blanket_part and 
    						vendor = po_header.vendor_code),
    						
    FABAuthorizations.ReleaseplanID,
    
    
    datediff(wk,'1999/01/03',getdate())
    
    
    from FT.FABAuthorizations FABAuthorizations 
    
    join 	#UnauthReceipts on FABAUTHorizations.Part=#Unauthreceipts.part and FABAUTHorizations.PONumber=#Unauthreceipts.PONumber 
    	
    join  PO_header on Fabauthorizations.PONumber=po_header.po_number and Fabauthorizations.part=po_header.blanket_part 
    
    join  Vendor on po_header.vendor_code=vendor.code
    
    
    where ReleasePlanID in(select max(id) from FT.ReleasePlans group by GeneratedWeekNo)
  
  
  Select	* 
	from	ReceiptAuthResults
where		FABGeneratedDate >= @FABGeneratedDate
order by	FABAuthPONumber,
			FABDate

  
end
GO
