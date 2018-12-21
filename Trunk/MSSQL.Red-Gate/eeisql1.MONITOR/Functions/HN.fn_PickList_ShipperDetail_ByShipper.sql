SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [HN].[fn_PickList_ShipperDetail_ByShipper]
(	@ShipperID int
,	@Plant varchar(10) = 'EEI'
,	@IsFullStandardPack int = 1
,	@Part varchar(25) = null
)
returns @Objects table
(	Prioridad int
,	ShipperID int
,	CrossRef varchar(50)
,	Part varchar(25)
,	WeekOnStock int
,	QtyRequired int
,	StandardPack int 
,	BoxesAvailable int
,	BoxesToPickUp int
,	BoxesPending int
,	BoxesPicked int
)
as 
begin


	Declare @TempoObject_SumPart table (
	ID int identity(1,1) Primary key,
	CrossRef varchar(150),
	Part varchar(150),
	weeks_on_stock int,
	Available numeric(18,6),
	StandardPack int,
	Picked int,
	QtyRequired int,
	QtyPicked int )


	Insert into @TempoObject_SumPart
	SELECT	distinct o.crossRef,
			o.part, 
			weeks_on_stock=weeks_on_stock,
			Available =sum( CASE WHEN ISNULL(SHIPPER,-1) = @ShipperID THEN 0 ELSE quantity END),
			StandardPack = avg(PartOnShipper.StandardPack),
			Picked =sum( CASE WHEN ISNULL(SHIPPER,-1) = @ShipperID THEN 1 ELSE 0 END),
			QtyRequired = avg(PartOnShipper.QtyRequired),
			QtyPicked =avg( PartOnShipper.QtyPicked)
	FROM HN.vw_Picklist_Object o with (readuncommitted)				
		inner join [HN].[fn_PickList_ShipperSummary_ByShipper](@ShipperID, @Plant, @IsFullStandardPack,@Part) PartOnShipper 
			on PartOnShipper.Part= o.part and PartOnShipper.Status ='Incomplete'
	where	o.plant=@Plant and o.[IsFullStdPack] >= @IsFullStandardPack and isnull(o.shipper,-1) in (-1, @ShipperID)
	group by o.crossref, weeks_on_stock, o.part
	order by o.crossref, weeks_on_stock desc

	
	insert
		@Objects
	(	
		Prioridad
	,	ShipperID
	,	CrossRef
	,	Part
	,	WeekOnStock
	,	QtyRequired
	,	StandardPack
	,	BoxesAvailable
	,	BoxesToPickUp
	,	BoxesPending
	,	BoxesPicked
	
	)
	Select distinct
		Prioridad = row_number() over (Partition by  CrossRef, part, StandardPack order by weeks_on_stock desc),
		@ShipperID,
		CrossRef, 
		Part,
		weeks_on_stock,
		QtyRequired,
		StandardPack,
		BoxesAvailable =Boxes,
BoxesToPickUp= (CASE WHEN (PreAvailableAcum + Available )-(QtyRequired - QtyPicked) <=0 
					THEN  case 
							when Boxes > ceiling((QtyRequired - QtyPicked) / (StandardPack*1.0)) 
								then ceiling((QtyRequired - QtyPicked) / (StandardPack*1.0))  
							else boxes  end
					ELSE ceiling(abs(PreAvailableAcum  -QtyRequired) / StandardPack) END)*1000,	
		--BoxesToPickUp= CASE WHEN (PreAvailableAcum + Available )-QtyRequired <=0 
		--			THEN ceiling((QtyRequired - QtyPicked) / (StandardPack*1.0))
		--			ELSE ceiling(abs(PreAvailableAcum  -QtyRequired) / StandardPack) END,	
		BoxesPending=(CASE WHEN (PreAvailableAcum + Available )-(QtyRequired - QtyPicked) <=0 
					THEN case 
							when Boxes > ceiling((QtyRequired - QtyPicked) / (StandardPack*1.0)) 
								then ceiling((QtyRequired - QtyPicked) / (StandardPack*1.0)) 
							else Boxes  end
					ELSE ceiling(abs(PreAvailableAcum  -QtyRequired) / StandardPack) - (QtyPicked / (StandardPack*1.0)) END) ,
		--BoxesPending=(CASE WHEN (PreAvailableAcum + Available )-QtyRequired <=0 
		--			THEN  ceiling((QtyRequired - QtyPicked) / (StandardPack*1.0))
		--			ELSE ceiling(abs(PreAvailableAcum  -QtyRequired) / StandardPack) - BoxesPicked END) ,
		BoxesPicked
	from (
	Select	ValorOriginal.CrossRef,
			Part=ValorOriginal.Part,
			ValorOriginal.weeks_on_stock,
			ValorOriginal.Available,
			Boxes = ceiling(ValorOriginal.Available / ValorOriginal.StandardPack),
			PreAvailableAcum = isnull(sum(valoracum.Available),0),
			BoxesAcum = ISNULL(sum(valoracum.Available) / ValorOriginal.StandardPack,0),
			ValorOriginal.StandardPack	,		
			BoxesPicked = ValorOriginal.Picked,
			QtyRequired = avg(ValorOriginal.QtyRequired),
			QtyPicked = avg(ValorOriginal.QtyPicked)
	from	@TempoObject_SumPart as ValorOriginal
			left join @TempoObject_SumPart as ValorAcum
				 on ValorAcum.Part = ValorOriginal.part
					and ValorAcum.ID < ValorOriginal.ID
	group by
			ValorOriginal.CrossRef,
			ValorOriginal.Part,
			ValorOriginal.weeks_on_stock,
			ValorOriginal.Available,
			ValorOriginal.StandardPack,
			ValorOriginal.Picked )	 Object
where PreAvailableAcum <= ( QtyRequired -QtyPicked)
		and (CASE WHEN (PreAvailableAcum + Available )-( QtyRequired -QtyPicked) <=0 
					THEN Boxes
					ELSE ceiling(abs(PreAvailableAcum  -( QtyRequired -QtyPicked)) / StandardPack) END)>0

	return
end

GO
