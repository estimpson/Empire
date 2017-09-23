SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure
[dbo].[eeisp_FabAuthperpart_test]
as
begin
  /*	Declarations:*/
  declare @FirmDays tinyint, /*	Firm days in schedule.*/
  @VendorDeliveryDay tinyint, /*	Vendor's delivery day.*/
  @FirstDayofWeek datetime, /*	Sunday of the current week.*/
  @WeekNo tinyint, /*	Week No (0) is current week.*/
  @FirmWeeks tinyint, /*	Number of firm weeks.*/
  @PlanWeeks tinyint, /*	Number of planning weeks.*/
  @ReleasePlanID integer,
  @MaxReleasePlanID integer,
  @LastWeekGenerated integer,
  @currentWeek integer,
  @ReceiptPeriodID integer,
  @PeriodEndDT datetime
  /*Select @MaxReleasePlanID = max(ID) 
  from 	FT.ReleasePlans

  Select @LastWeekGenerated = GeneratedWeekNo 
  from 	FT.ReleasePlans where ID = @MaxReleasePlanID

  Select @currentWeek = DateDiff ( week, Value, getdate() )

  If	(@lastweekGenerated<>@currentWeek )
  Begin


  Create table #UnauthReceipts(
  poNumber 	integer,
  Part				varchar(25),
  Qty				numeric(20,6))

  Create index  idxunauthreceipts on #Unauthreceipts (poNumber, part)

  Insert #Unauthreceipts
  Select	poNumber,
  part,
  sum(quantity)
  from		nonauthorizedmaterial
  group by ponumber,part



  Begin Transaction
  execute	FT.csp_RecordVendorReleasePlan
  @ReleasePlanID = @ReleasePlanID output
  Commit Transaction*/
  create table #UnauthReceipts(
    poNumber integer null,
    Part varchar(25) null,
    Qty decimal(20,6) null,
    )
  create index idxunauthreceipts on #Unauthreceipts(poNumber asc,part asc)
  insert into #Unauthreceipts
    select poNumber,
      part,
      sum(quantity)
      from nonauthorizedmaterial
      group by ponumber,part
  select distinct po_header.vendor_code,
    FabAuthorizations.POnumber,
    FabAuthorizations.Part,
    FabAuthorizations.WeekNo,
    HighFAB=HighFabAuthorizations.AuthorizedAccum,
    FABAUTH=(select max(FABAuth2.AuthorizedAccum)
      from FT.FabAuthorizations as FABAuth2
      where FABAuth2.POnumber=FabAuthorizations.PONumber
      and FABAuth2.Part=FabAuthorizations.part
      and FABAuth2.WeekNo=FabAuthorizations.WeekNO),
    firm_days=(case when isnull(lead_time,0)>0 then lead_time else 14 end),
    VENDDELDAY=isnull((case when custom4 like '[0-7]' then convert(integer,custom4) end),2),
    firm_weeks=ceiling((case when firm_days%7+1<=VENDDELDAY then firm_days/7 else 1+firm_days/7 end)),
    MAXCUM=(select max(releasePlanRaw.PostAccum)
      from FT.releasePlanRaw
      where releasePlanRaw.PONumber=FabAuthorizations.PONumber
      and releasePlanRaw.Part=FabAuthorizations.Part
      and releasePlanRaw.ReleasePlanID=any(select ID from FT.ReleasePlans where ReleasePlans.GeneratedWeekNo>=(FabAuthorizations.WeekNo-firm_weeks) and ReleasePlans.GeneratedWeekNo<=FabAuthorizations.WeekNo)),
    CURWK=DateDiff(week,Value,getdate()),
    HFABRID=HighFABAuthorizations.ReleasePlanID,
    HFABWK=(select ReleasePlans.GeneratedWeekNo from FT.ReleasePlans where ID=HFABRID),
    AccumReceived=isNULL(POReceiptTotals.StdQty,0),
    CUMAdjustment=isNULL(POReceiptTotals.AccumAdjust,0),
    adjustedAccumReceived=(AccumReceived+CUMAdjustment),
    WeekMAXGenerated=(select max(GeneratedWeekNo)
      from FT.ReleasePlans
      where ReleasePlans.ID=(select max(RPR2.ReleasePlanID)
        from FT.releasePlanRaw as RPR2
        where RPR2.PONumber=FabAuthorizations.PONumber
        and RPR2.Part=FabAuthorizations.Part
        and RPR2.WeekNO=FabAuthorizations.WeekNo
        and RPR2.PostAccum=MAXCUM
        and RPR2.ReleasePlanID=any(select ID from FT.ReleasePlans where ReleasePlans.GeneratedWeekNo>=(FabAuthorizations.WeekNo-firm_weeks) and ReleasePlans.GeneratedWeekNo<=FabAuthorizations.WeekNo))),
    CURRENTACCUMREQ=(select max(releasePlanRaw.PostAccum)
      from FT.releasePlanRaw
      where releasePlanRaw.PONumber=FabAuthorizations.PONumber
      and releasePlanRaw.Part=FabAuthorizations.Part
      and releasePlanRaw.WeekNo=FabAuthorizations.WeekNo
      and releasePlanRaw.ReleasePlanID=(select max(ID) from FT.ReleasePlans)),
    WEEKFORHFAB=HighFABAuthorizations.WeekNO,
    Vendor.contact,
    Vendor.phone,
    Vendor.address_6,
    CURRENTNetReq=(select max(releasePlanRaw.StdQty)
      from FT.releasePlanRaw
      where releasePlanRaw.PONumber=FabAuthorizations.PONumber
      and releasePlanRaw.Part=FabAuthorizations.Part
      and releasePlanRaw.WeekNo=FabAuthorizations.WeekNo
      and releasePlanRaw.ReleasePlanID=(select max(ID) from FT.ReleasePlans)),
    po_header.blanket_part,
    #Unauthreceipts.qty,
    LASTFABWEEK=(select max(FABAuth3.WeekNo)
      from FT.FabAuthorizations as FABAuth3
      where FABAuth3.POnumber=FabAuthorizations.PONumber
      and FABAuth3.Part=FabAuthorizations.part
      and FABAuth3.WeekNo<=CURWK)
    from FT.HighFabAuthorizations cross join
    FT.DTGlobals left outer join
    po_header on HighFabAuthorizations.ponumber=po_header.po_number join
    vendor on po_header.vendor_Code=vendor.code join
    #Unauthreceipts on po_header.po_number=#Unauthreceipts.POnumber and po_header.blanket_part=#Unauthreceipts.part left outer join
    FT.FabAuthorizations on HighFabAuthorizations.PONumber=FabAuthorizations.PONumber and HighFabAuthorizations.part=FabAuthorizations.part left outer join
    part_vendor on po_header.vendor_code=part_vendor.vendor and po_header.blanket_part=part_vendor.part left outer join
    vendor_custom on po_header.vendor_code=vendor_custom.code left outer join
    FT.POReceiptTotals on HighFabAuthorizations.PONumber=POReceiptTotals.POnumber
    where po_header.type='B'
    and DTGlobals.name='BaseWeek' /*and
    FT.FabAuthorizations.WeekNo >= LASTFABWEEK and FT.FabAuthorizations.WeekNo< CURWK+2*/
    and HighFabAuthorizations.PONumber=20487
    and HighFabAuthorizations.Part='04707333' order by
    1 asc,2 asc,4 asc
/*ELSE
Begin
Create table #UnauthReceipts(
poNumber 	integer,
Part				varchar(25),
Qty				numeric(20,6))

Create index  idxunauthreceipts on #Unauthreceipts (poNumber, part)

Insert #Unauthreceipts
Select	poNumber,
part,
sum(quantity)
from		nonauthorizedmaterial
group by ponumber,part



Begin Transaction
exec FT.csp_RecordReceipts @ReceiptPeriodID output,@PeriodEndDT output, 0
Commit Transaction

select 		distinct 	po_header.vendor_code,
FT.FabAuthorizations.POnumber,
FT.FabAuthorizations.Part,
FT.FabAuthorizations.WeekNo,
FT.HighFabAuthorizations.AuthorizedAccum as HighFAB,
(Select max(FABAuth2.AuthorizedAccum) 
from			 FT.FabAuthorizations as FABAuth2
where		FABAuth2.POnumber = FT.FabAuthorizations.PONumber and
FABAuth2.Part = FT.FabAuthorizations.part and
FABAuth2.WeekNo=FT.FabAuthorizations.WeekNO) as FABAUTH,
( case when isnull ( lead_time, 0 ) > 0 then lead_time else 14 end ) as firm_days,
isnull (	(	case when custom4 like '[0-7]' then convert ( integer, custom4 ) end ), 2 )  as VENDDELDAY,
ceiling(( case when mod ( firm_days, 7 ) + 1 <= VENDDELDAY then firm_days / 7 else 1 + firm_days / 7 end )) as firm_weeks,
(select 	max(FT.releasePlanRaw.PostAccum) 
from 	FT.releasePlanRaw
where	FT.releasePlanRaw.PONumber = FT.FabAuthorizations.PONumber and
FT.releasePlanRaw.Part = FT.FabAuthorizations.Part and
FT.releasePlanRaw.WeekNo = FT.FabAuthorizations.WeekNo and
FT.releasePlanRaw.ReleasePlanID in (select ID from FT.ReleasePlans where FT.ReleasePlans.GeneratedWeekNo>= (FT.FabAuthorizations.WeekNo-firm_weeks) and FT.ReleasePlans.GeneratedWeekNo<= FT.FabAuthorizations.WeekNo)) as MAXCUM,
DateDiff ( week, Value, getdate() ) as CURWK,
FT.HighFABAuthorizations.ReleasePlanID as HFABRID,
(Select FT.ReleasePlans.GeneratedWeekNo from FT.ReleasePlans where ID =  HFABRID) as HFABWK,
isNULL(FT.POReceiptTotals.StdQty,0) as AccumReceived,
isNULL(FT.POReceiptTotals.AccumAdjust,0) as CUMAdjustment,
(AccumReceived+CUMAdjustment) as adjustedAccumReceived,
(Select 	GeneratedWeekNo 
from 	FT.ReleasePlans
Where	FT.ReleasePlans.ID = (Select 	max(RPR2.ReleasePlanID) 
from		FT.releasePlanRaw RPR2
Where	RPR2.PONumber = FT.FabAuthorizations.PONumber and
RPR2.Part = FT.FabAuthorizations.Part and
RPR2.WeekNO =  FT.FabAuthorizations.WeekNo and
RPR2.PostAccum = MAXCUM and
RPR2.ReleasePlanID in (select ID from FT.ReleasePlans where FT.ReleasePlans.GeneratedWeekNo>= (FT.FabAuthorizations.WeekNo-firm_weeks) and FT.ReleasePlans.GeneratedWeekNo<= FT.FabAuthorizations.WeekNo))) as WeekMAXGenerated,
(select 	max(FT.releasePlanRaw.PostAccum) 
from 	FT.releasePlanRaw
where	FT.releasePlanRaw.PONumber = FT.FabAuthorizations.PONumber and
FT.releasePlanRaw.Part = FT.FabAuthorizations.Part and
FT.releasePlanRaw.WeekNo = FT.FabAuthorizations.WeekNo and
FT.releasePlanRaw.ReleasePlanID = (select max(ID) from FT.ReleasePlans)) as CURRENTACCUMREQ,
FT.HighFABAuthorizations.WeekNO as WEEKFORHFAB,
Vendor.contact,
Vendor.phone,
Vendor.address_6,
(select 	max(FT.releasePlanRaw.StdQty) 
from 	FT.releasePlanRaw
where	FT.releasePlanRaw.PONumber = FT.FabAuthorizations.PONumber and
FT.releasePlanRaw.Part = FT.FabAuthorizations.Part and
FT.releasePlanRaw.WeekNo = FT.FabAuthorizations.WeekNo and
FT.releasePlanRaw.ReleasePlanID = (select max(ID) from FT.ReleasePlans)) as CURRENTNetReq,
po_header.blanket_part,
#Unauthreceipts.qty,
(Select max(FABAuth3.WeekNo) 
from			 FT.FabAuthorizations as FABAuth3
where		FABAuth3.POnumber = FT.FabAuthorizations.PONumber and
FABAuth3.Part = FT.FabAuthorizations.part and
FABAuth3.WeekNo<=CURWK) as LASTFABWEEK


from 						FT.HighFabAuthorizations
CROSS JOIN				FT.DTGlobals
LEFT OUTER JOIN 	po_header on FT.HighFabAuthorizations.ponumber = po_header.po_number
JOIN							vendor on po_header.vendor_Code = vendor.code
JOIN							#Unauthreceipts on po_header.po_number = #Unauthreceipts.POnumber and po_header.blanket_part = #Unauthreceipts.part
LEFT OUTER JOIN		FT.FabAuthorizations on FT.HighFabAuthorizations.PONumber = FT.FabAuthorizations.PONumber and FT.HighFabAuthorizations.part = FT.FabAuthorizations.part
LEFT OUTER JOIN		part_vendor on po_header.vendor_code = part_vendor.vendor and po_header.blanket_part = part_vendor.part
LEFT OUTER JOIN		vendor_custom on po_header.vendor_code = vendor_custom.code
LEFT OUTER JOIN		FT.POReceiptTotals on FT.HighFabAuthorizations.PONumber = FT.POReceiptTotals.POnumber 
Where						po_header.type = 'B' 		and											 
FT.DTGlobals.name = 'BaseWeek'  and
FT.FabAuthorizations.WeekNo >= LASTFABWEEK and FT.FabAuthorizations.WeekNo< CURWK+2

order by 1,2,4 ASC

End*/
end
GO
