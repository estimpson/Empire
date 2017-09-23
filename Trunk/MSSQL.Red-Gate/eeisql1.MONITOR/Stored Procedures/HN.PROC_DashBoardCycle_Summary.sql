SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*

	EXEC MONITOR.HN.PROC_DashBoardCycle_Summary  7,'EEI',2017
	EXEC MONITOR.HN.PROC_DashBoardCycle_Summary  2,'EEI',2017,25

*/
CREATE PROCEDURE [HN].[PROC_DashBoardCycle_Summary]
			 @Type	INT 
			,@Plant	VARCHAR(20)		=  NULL
			,@Year	INT				=  NULL
			,@Week	INT				=  NULL 
			,@Loc   VARCHAR(50)		=  NULL 
WITH RECOMPILE		
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	
	SET nocount ON
	
	--<MAIN CODE>

	IF (@Type = 1 ) -- LOAD RECORDS DISPLAYED FOR PLANT EEI 
		BEGIN 
			
		Select	Week = WeekInYear,
				LocationS = count(distinct to_loc),
				Boxes = count(distinct serial),
				Total_Cycled= sum(isnull(total,0)),
				Fis_Amoun = sum(isnull(Fis_amount,0)),
				Scrapped_amount=sum(isnull(Scrap_Amount,0)),
				Total_Lost =SUM(isnull(Lost_Amount ,0)),
				Good_Cycle= sum(isnull(Good_Amount,0)),
				Rate = case when sum(isnull(total,0))=0 then 0 else  (sum(isnull(Good_Amount,0))/sum(isnull(total,0)))*100 end
		from hn.DashBoardCycle_GeneralData
		where plant=@Plant
		group by WeekInYear
		order by 1 desc
		/*
			SELECT  week
				   ,Locations = loc_qty
				   ,Boxes  = COUNT(WEEK)
				   ,Total_Cycled = SUM(ISNULL(Cycle_amount_Good,0)) + SUM(ISNULL(Fis_amount,0))
				   ,Fis_Amoun = SUM(ISNULL(Fis_amount,0)) 
				   ,Scrapped_amount = SUM(ISNULL(Scrap_lost,0)) 
				   ,Total_Lost = SUM(ISNULL(Total_Lost_amount,0))
				   ,Good_Cycle =  (SUM(ISNULL(Cycle_amount_Good,0)) + SUM(ISNULL(Fis_amount,0))) -  SUM(ISNULL(Total_Lost_amount,0))
				   ,Rate =   (((SUM(ISNULL(Cycle_amount_Good,0)) + SUM(ISNULL(Fis_amount,0))) -  SUM(ISNULL(Total_Lost_amount,0))) / (SUM(ISNULL(Cycle_amount_Good,0)) + SUM(ISNULL(Fis_amount,0))))*100
			FROM MONITOR.HN.DashBoardCycle_GeneralData 
			WHERE	   year = @Year
				  AND  destination = @Plant
			GROUP BY week,loc_qty
			ORDER BY 1 DE	SC
			*/
		END 
		
	IF (@Type = 2 ) -- LOAD RECORDS DISPLAYED FOR WEEK 
		BEGIN 
			
			SELECT	Week=WeekInYear,
					Locations=to_loc,
					Boxes = count(distinct serial),
				Total_Cycled= sum(isnull(total,0)),
				Fis_Amoun = sum(isnull(Fis_amount,0)),
				Scrapped_amount=sum(isnull(Scrap_Amount,0)),
				Total_Lost =SUM(isnull(Lost_Amount ,0)),
				Good_Cycle= sum(isnull(Good_Amount,0)),
				Rate = case when sum(isnull(total,0)) = 0  then 0 else (sum(isnull(Good_Amount,0))/sum(isnull(total,0)))*100 end				
			from hn.DashBoardCycle_GeneralData
			where	WeekInYear = @Week and plant=@Plant
			group by WeekInYear, to_loc
			order by 5 desc
			/*
			SELECT	Location,Boxes = sum (Boxes) 
					, Total_Cycled = SUM (Total_Cycled) 
					, Fis_Amoun = SUM (Fis_Amoun) 
					, Scrapped_amount = SUM (Scrapped_amount) 
					, Total_Lost = SUM(Total_Lost) 
					, Good_Cycle = SUM(Good_Cycle) 
					, Rate = SUM(Rate) 
			FROM (	SELECT  Location = from_loc 
						   ,Boxes  = COUNT(WEEK)
						   ,Total_Cycled = SUM(ISNULL(Cycle_amount_Good,0)) + SUM(ISNULL(Fis_amount,0))
						   ,Fis_Amoun = SUM(ISNULL(Fis_amount,0)) 
						   ,Scrapped_amount = SUM(ISNULL(Scrap_lost,0)) 
						   ,Total_Lost = SUM(ISNULL(Total_Lost_amount,0))
						   ,Good_Cycle =  (SUM(ISNULL(Cycle_amount_Good,0)) + SUM(ISNULL(Fis_amount,0))) -  SUM(ISNULL(Total_Lost_amount,0))
						   ,Rate =   CASE WHEN  Part <> 'PALLET' 
											THEN (((SUM(ISNULL(Cycle_amount_Good,0)) + SUM(ISNULL(Fis_amount,0))) -  SUM(ISNULL(Total_Lost_amount,0))) / (SUM(ISNULL(Cycle_amount_Good,0)) + SUM(ISNULL(Fis_amount,0))))*100
										   ELSE 100 END 
					FROM MONITOR.HN.DashBoardCycle_GeneralData 
					WHERE	   year = @Year
						  AND  destination = @Plant
						  AND  week  = @Week			 
					GROUP BY from_loc,Part
				 ) xData 
			GROUP BY Location
			*/
		END 

	IF (@Type = 3)	-- LOAD RECORDS DISPLAYED FOR SERIAL
		BEGIN 
			SELECT  Serial = Serial
				   ,part=part
				   ,Qty  = SUM(Quantity)
				   ,Qty_Dol =sum(isnull(Good_Amount,0))
			from hn.DashBoardCycle_GeneralData
			where	WeekInYear = @Week and plant=@Plant
				and to_loc= @Loc

			group by serial, part
			having sum(isnull(Good_Amount,0)) >0
			--SELECT  Serial = Serial
			--	   ,part 
			--	   ,Qty  = SUM(Quantity)
			--	   ,Qty_Dol = SUM(ISNULL(Cycle_amount_Good,0)) + SUM(ISNULL(Fis_amount,0))
			--FROM MONITOR.HN.DashBoardCycle_GeneralData 
			--WHERE	   year = @Year
			--	  AND  destination = @Plant
			--	  AND  week  = @Week
			--	  AND from_loc  like '%' +  @Loc +  '%' 
			--	  AND Class = 'CYCLE OK'
			--GROUP BY Serial,part 
		END

		IF (@Type = 4)	-- LOAD RECORDS DISPLAYED FOR SERIAL REPORTED 
		BEGIN 
			SELECT  Serial = 0
				   ,part =''
				   ,Qty  = 0
				   ,Fis_Amoun = 0
				   ,Scrap_Total=0
			/*
			SELECT  Serial = Serial
				   ,part 
				   ,Qty  = SUM(Quantity)
				   ,Fis_Amoun = SUM(ISNULL(Fis_Amount,0))
				   ,Scrap_Total = SUM(ISNULL(Total_Lost_Amount,0))
			FROM MONITOR.HN.DashBoardCycle_GeneralData 
			WHERE	   year = @Year
				  AND  destination = @Plant
				  AND  week  = @Week
				  AND from_loc like '%' +  @Loc +  '%' 
				  AND Class = 'FIS-SCRAP'
			GROUP BY Serial,part
			 */
		END

		---PROCESS TO LOCATION 
		IF (@Type = 5)			--Cycle Count Done, Yes
			BEGIN 
			Select  Location =''
					  , Box_In_Location = 0
					  , Min_Of_LastCycleDTDone = '2017-01-01'
					  , Days_Without_Cycle =0
			/*
				Select  Location 
					  , Box_In_Location = TotalSerial 
					  , Min_Of_LastCycleDTDone = MinDateSerialOnLocation
					  , Days_Without_Cycle = Date_to_Cycle   
				from MONITOR.HN.DashBoardCycle_LocationData
				WHERE Plant = @Plant
					  and Cycle_Done = 'YES'			
			*/
			END 

		IF (@Type = 6)		-- Cycle Count Done, No
			BEGIN 
			Select  Location =''
					  , Box_In_Location = 0 
					  , Min_Of_LastCycleDTDone = '2017-01-01'
					  , Days_Without_Cycle =0
			/*
				Select  Location 
					  , Box_In_Location = TotalSerial 
					  , Min_Of_LastCycleDTDone = MinDateSerialOnLocation
					  , Days_Without_Cycle = Date_to_Cycle   
				from MONITOR.HN.DashBoardCycle_LocationData
				WHERE Plant = @Plant
					  and Cycle_Done = 'NO'			
			*/
			END 

	--</MAIN CODE>
	
END
GO
