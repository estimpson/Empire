SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
Select * 
from MONITOR.HN.DashBoardCycle_LocationData
*/
CREATE VIEW [HN].[DashBoardCycle_LocationData] as 

SELECT *, 
	  Cycle_Done = CASE WHEN LastCycleDTDone = '2016-11-29' or LastCycleDTDone = '2016-8-29' 
						THEN 'NO'
						ELSE 'YES'
					END 
FROM (
		Select	Location= code,
				LastycleDT,
				SerialOnLocation.TotalSerial,
				MinDateSerialOnLocation=ISNULL(SerialOnLocation.MinDateSerialOnLocation,( CASE WHEN plant = 'EEI' THEN '2016-11-29' 
																							   WHEN plant = 'EEA' THEN '2016-08-29'
																						END)),
				SerialOnLocation.MaxDateSerialOnLocation, plant,group_no
				,Last_Date_CC_Visit = CASE WHEN plant = 'EEI' THEN '2016-11-29' 
										   WHEN plant = 'EEA' THEN '2016-08-29'
										   ELSE '' END 
				,LastCycleDTDone = CASE WHEN LastycleDT < (	CASE WHEN plant = 'EEI' THEN '2016-11-29' 
															 WHEN plant = 'EEA' THEN '2016-08-29'
															 ELSE '' END) or LastycleDT is null 
												THEN 
														(	CASE WHEN plant = 'EEI' THEN '2016-11-29' 
															 WHEN plant = 'EEA' THEN '2016-08-29'
															 ELSE '' END)
												ELSE 
													LastycleDT
												END 
				, Date_to_Cycle = Datediff(Day,(	CASE WHEN LastycleDT < (	CASE WHEN plant = 'EEI' THEN '2016-11-29' 
															 WHEN plant = 'EEA' THEN '2016-08-29'
															 ELSE '' END) or LastycleDT is null 
													THEN 
															(	CASE WHEN plant = 'EEI' THEN '2016-11-29' 
																 WHEN plant = 'EEA' THEN '2016-08-29'
																 ELSE '' END)
													ELSE 
														LastycleDT
													END ),GETDATE())
		 from	location
			left join (Select	Location = replace(from_loc,'F',''), LastycleDT =  max(date_stamp)
						from	audit_trail
						where	from_loc like '%f'
							and remarks='Phys Scan'
						group by from_loc) LastCycle
					on location.code = LastCycle.Location
			left join (Select Location, 
								TotalSerial = count(serial), 
								MinDateSerialOnLocation = min( last_date),
								MaxDateSerialOnLocation = max(last_date)
						from object
						where	part <> 'PALLET'
						group by location) SerialOnLocation
					on location.code = SerialOnLocation.location
		where location.code not like '%f' and group_no like '%LOST WAREHOUSE'
	) Data 



GO
