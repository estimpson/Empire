SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE VIEW [HN].[VW_Inv_Object]
AS
SELECT	object.serial, object.part, p.name, object.location, object.operator, On_Hand=object.std_quantity, Lot=lot,Field1, Notes=object.note, 
		object.last_date, object.status, object.user_defined_status, standard_unit=unit_measure,object.parent_serial, 
		unit_weight=-1,Grommets = 0, 
		object.start_date, object.custom2  
FROM object with (readuncommitted) left JOIN part p with (readuncommitted) ON p.part = object.part 
WHERE isnull(object.std_quantity,1)>0




GO
