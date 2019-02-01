SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [HN].[fn_PickList_SerialDetail_ByShipper]
(	@ShipperID int
,	@Plant varchar(10) = 'EEI'
,	@IsFullStandardPack int = 1
,	@Part varchar(25) = null
)	
returns @Objects table
(	Serial int
,	CrossRef varchar(50)
,	Quantity int
,	Part varchar(25)
,	Location varchar(25)
,	ParentSerial int
,	Lot int
,	ObjectBirthday datetime
)
as 
begin


	Insert into @Objects
	Select distinct	Object.serial,
			Object.CrossRef, 
			Object.Quantity,
			Object.Part,
			Object.location,
			Object.Parent_Serial,
			Object.weeks_on_stock,
			Object.ObjectBirthday
	from	[HN].[fn_PickList_LocationDetail_ByShipper](@ShipperID, @Plant, @IsFullStandardPack, @Part) LocationDetail
		inner join hn.vw_picklist_object Object
			 on LocationDetail.Part = object.part
				and LocationDetail.weekonstock = object.weeks_on_stock
				and LocationDetail.CrossRef = Object.CrossRef
				and LocationDetail.Location = Object.Location
				and locationdetail.part = object.part
				and object.plant=@Plant and object.location not like '%stage%'  and IsFullStdPack >= @IsFullStandardPack
	order by Object.CrossRef, Object.serial

	return
end
GO
