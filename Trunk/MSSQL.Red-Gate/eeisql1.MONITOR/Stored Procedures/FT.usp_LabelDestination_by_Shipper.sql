SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [FT].[usp_LabelDestination_by_Shipper]

(	@shipperID INT )
AS
SET NOCOUNT ON
SET ANSI_WARNINGS OFF

--- <Body>
	 --[FT].[usp_LabelDestination_by_Shipper] 115172
	--Get Data for Label

	DECLARE @LabelData TABLE
(
		
		DestName varchar(100),
		DestAdd1 varchar(100),
		DestAdd2 varchar(100),
		DestAdd3 varchar(100),
		DestAdd4 varchar(100),
		FromPlantLocation VARCHAR(100),
		FromPlantAdd1 varchar(100),
		FromPlantAdd2 varchar(100),
		FromPlantAdd3 varchar(100),
		CarrierSCAC VARCHAR(15),
		CarrierName VARCHAR(50),
		ShipperID int
)



INSERT @LabelData
	SELECT 
		DestName = d.name
		,DestAdd1 = d.address_1
		,DestAdd2 = d.address_2
		,DestAdd3 = d.address_3
		,DestAdd4 = d.address_4
		,FromPlantLocation = CASE WHEN fromplant.name LIKE '%Empire%' THEN fromPlant.name ELSE 'Empire Electronics  '+fromplant.name END
		,FromPlantAdd1 = COALESCE(FromPlant.address_1, parms.address_1)
		,FromPlantAdd2 =  COALESCE(FromPlant.address_2, parms.address_2)
		,FromPlantAdd3 =  COALESCE(FromPlant.address_3, parms.address_3)
		,CarrierSCAC = carrier.scac
		,CarrierName = carrier.name
		,ShipperID = S.id
				
	From
		shipper s 
	JOIN
	destination d on d.destination = s.destination
	LEFT JOIN
	destination fromPlant ON FromPlant.plant = s.plant
  OUTER APPLY  ( SELECT TOP 1 * FROM dbo.carrier WHERE carrier.scac = s.ship_via ) AS Carrier
CROSS JOIN parameters parms
		WHERE 
		s.id = @ShipperID
	

SELECT * FROM @LabelData LabelData

	

--- </Body>



/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go

declare
	@Shipper int

set	@Shipper = 59613

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = [FT].[usp_LabelPallet_ADAC_by_Shipper]
	@Shipper = @Shipper
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult


go

if	@@trancount > 0 begin
	rollback
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/








GO
