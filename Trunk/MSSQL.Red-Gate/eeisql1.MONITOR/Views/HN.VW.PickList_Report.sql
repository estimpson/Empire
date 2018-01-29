SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE view [HN].[VW.PickList_Report]
as 
	select	Picklist.* ,
			Summary.*,
			Shipper.*,
			SerialDetails.Serial
	from (select	ShipperID as ShipperID_Detail, 
					Part as Part_Detail, 
					CrossRef as CrossRef_Detail, 
					LOT as LOT_Detail, 
					LotReq as locReq_Detail,
					LocQty as LocQty_Detail, 
					BestOption as BestOption_Detail, 
					Boxtype as Boxtype_Detail, 
					Location as Location_Detail, StandardPack as StandardPack_Detail , Operator as Operator_Detail 
			from MONITOR.HN.Picklist_RF_DataExcel with (readuncommitted)
			where TAB='PicklistDetail') as Picklist 
				inner join   (select	Operator as Operator_Summary,
										ShipperID as ShipperID_Summary, 
										CrossRef as CrossRef_Summary, 
										Part as Part_Summary, 
										QtyRequired as QtyRequired_Summary, 
										StandardPack as StandardPack_Summary, 
										BoxesAvailable as BoxesAvailable_Summary, 
										BoxesRequired as BoxesRequired_Summary, 
										BoxesPicked as BoxesPicked_Summary, 
										Status as Status_Summary, 
										QtyPicked as QtyPicked_Summary 
							from MONITOR.HN.Picklist_RF_DataExcel with (readuncommitted)
							where TAB='ShipperSummary') as Summary 
					on Summary.crossRef_Summary= Picklist.CrossRef_Detail 
						and Summary.ShipperID_Summary=Picklist.ShipperID_Detail
						and Summary.Operator_Summary=Picklist.Operator_detail
						and Summary.Part_Summary=Picklist.Part_Detail
				inner join (Select	id,
									Customer, 
									destination, 
									location as Shipper_location, 
									ship_via 
							from Shipper) as Shipper 
					on Shipper.id =Summary.ShipperID_Summary 
				left join (Select	Serial, Operator, ShipperID, CrossRef, Part, Lot, Location
						   from	[HN].[Picklist_RF_DataExcel_SerialDetails]) SerialDetails
						   on Picklist.CrossRef_Detail= SerialDetails.CrossRef
						and Picklist.ShipperID_Detail=SerialDetails.ShipperID
						and Picklist.Operator_Detail =SerialDetails.Operator
						and Picklist.Part_Detail=SerialDetails.Part
						and Picklist.LOT_Detail =SerialDetails.lot
						and Picklist.Location_Detail=SerialDetails.location
						   



GO
