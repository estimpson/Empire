SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE	procedure	[dbo].[eeisp_flatten_BOM]

as
begin

truncate table	dbo.RawPartFinishedParts


insert	dbo.RawPartFinishedParts

SELECT	RawPart,
		'( '+ FinishedPart + ' Qty: '+ CONVERT(VARCHAR(20),CONVERT(DECIMAL(10,2),Quantity))+
		' Dmd: '+(CONVERT(VARCHAR(20),CONVERT(DECIMAL(10,0),ISNULL((SELECT SUM(quantity) FROM order_detail WHERE part_number = FinishedPart),0) ))) + ' )',
		Quantity
FROM	[dbo].[vweeiBOM]


declare	@RawPart varchar(25),
		@FinishedPartList varchar(1000)

declare @FlatFinishedGoods table (
		
	RawPart	varchar(25),
	FinishedParts	varchar(1000))

declare	Rawpartlist cursor local for
select distinct RawPart 
from	dbo.RawPartFinishedParts
open		Rawpartlist 
fetch	Rawpartlist into	@RawPart

While		 @@fetch_status = 0
Begin	
Select	@FinishedPartList  = ''


Select		@FinishedPartList = @FinishedPartList + FinishedPart +', '
from		dbo.RawPartFinishedParts where RawPart = @RawPart
group by	FinishedPart



insert	@FlatFinishedGoods
Select	@Rawpart,
		@FinishedPartList
		
		

fetch	Rawpartlist into	@RawPart

END

truncate table FlatFinishedPart
insert	FlatFinishedPart
Select	RawPart,
		left(FinishedParts,datalength(FinishedParts)-2)
	
from		@FlatFinishedGoods

Select	* 
FROM	FlatFinishedPart

end

GO
