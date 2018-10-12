SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [HN].[BF_Splice_Label]( @NKID int )
as

select	Serials.NKID,
		WODID = WorkOrderKit.newWODID,
		WOQty = WODetails.QtyRequired,
		WOPart = WODetails.Part,
		WOMachine = WOHeaders.Machine,
		Serials.SerialBreak,
		Serial = convert(int, Object.Serial),
		Object.Part,
		Object.Quantity,
		Object.Operator,
		Object.location
from	ft.NewKitSerials Serials
		join ft.NewKitHeaders WorkOrderKit on Serials.NKID =  WorkOrderKit.NKID
		join WODetails on WODetails.ID = WorkOrderKit.newWODID
		join WOHeaders on WOHeaders.ID = WODetails.WOID
		join Object on Object.serial = Serials.Serial
where	Serials.NKID = @NKID 
union all
select	Serials.NKID,
		WODID = WorkOrderKit.newWODID,
		WOQty = WODetails.QtyRequired,
		WOPart = WODetails.Part,
		WOMachine = WOHeaders.Machine,
		Serials.SerialBreak,
		Serial = convert(int, Object.Serial),
		Object.Part,
		Object.Quantity,
		Object.Operator,
		Object.location
from	ft.NewKitSerials Serials
		join ft.NewKitHeaders WorkOrderKit on Serials.NKID =  WorkOrderKit.NKID
		join WODetails on WODetails.ID = WorkOrderKit.newWODID
		join WOHeaders on WOHeaders.ID = WODetails.WOID
		join Object on Object.serial = Serials.SerialBreak
where	Serials.NKID = @NKID 

GO
