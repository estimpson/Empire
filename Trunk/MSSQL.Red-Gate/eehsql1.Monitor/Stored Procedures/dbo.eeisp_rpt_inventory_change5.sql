SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure
[dbo].[eeisp_rpt_inventory_change5](@BeginningDate datetime,@EndingDate datetime)
as
begin
  create table #A1(
    Serial varchar(25) null,
    DateStamp datetime null,
    HourofDay decimal(30,6) null,
    DayofMonth decimal(30,6) null,
    Vendor varchar(25) null,
    Po_number varchar(25) null,
    Part varchar(25) null,
    Quantity decimal(30,6) null,
    StdCost decimal(30,6) null,
    ExtCost decimal(30,6) null,
    Shipper varchar(25) null,
    FromLocation varchar(25) null,
    ToLocation varchar(25) null,
    Operator varchar(25) null,
    Remarks varchar(25) null,
    type varchar(25) null,
    )
  create index #idxA1 on #A1(Shipper asc)
  insert into #A1
    select serial,
      date_stamp,
      datepart(hh,date_stamp),
      day(date_stamp),
      vendor,
      po_number,
      part,
      quantity,
      std_cost,
      quantity*std_cost,
      shipper,
      from_loc,
      to_loc,
      operator,
      remarks,
      type
      from audit_trail
      where type='R' and date_stamp>=(@BeginningDate) and date_stamp<dateadd(day,1,(@EndingDate))
  create table #B1(
    BillofLading varchar(25) null,
    ShortShipper varchar(25) null,
    Invoice varchar(25) null,
    )
  create index #idxB1 on #B1(ShortShipper asc)
  insert into #B1
    select bill_of_lading,
      substring(bill_of_lading,1,patindex('%_%',bill_of_lading))
		
      invoice
      from po_receiver_items
  select #B1.BillofLading,
    #B1.ShortShipper,
    #B1.Invoice,
    #A1.Serial,
    #A1.DateStamp,
    #A1.HourofDay,
    #A1.DayofMonth,
    #A1.Vendor,
    #A1.Po_number,
    #A1.Part,
    #A1.Quantity,
    #A1.StdCost,
    #A1.ExtCost,
    #A1.Shipper,
    #A1.FromLocation,
    #A1.ToLocation,
    #A1.Operator,#A1.Remarks,#A1.type
    from #A1 left outer join
    #B1 on #A1.Shipper=#B1.ShortShipper
end
GO
