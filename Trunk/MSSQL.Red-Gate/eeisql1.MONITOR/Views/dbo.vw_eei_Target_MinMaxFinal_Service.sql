SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vw_eei_Target_MinMaxFinal_Service]
as
Select	*,
		substring(BasePart,1,3 ) as CustomerID, 
		(CASE WHEN isNULL((Select sum(quantity) from object where  part like '%-%' and substring(object.part, 1, (PATINDEX( '%-%',object.part))-1) = BasePart),0) BETWEEN MinTarget and MAxTarget THEN 1 ELSE 0 END) as TargetStatus
from	vw_eei_target_MinMax_Service
GO
