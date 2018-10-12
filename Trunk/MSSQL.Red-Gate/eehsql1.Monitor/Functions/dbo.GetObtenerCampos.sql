SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- =============================================
-- Author:		<Elvis Alas>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================


/*

Select * from sistema.dbo.[GetObtenerCampos]('RH_Puesto_Salario')

*/

CREATE FUNCTION [dbo].[GetObtenerCampos]( @tabla VARCHAR(50) )
returns @Informacion table
	(
		Campo   VARCHAR(300) 
	)
as 
begin			

insert into @Informacion

SELECT
        COL.name AS columna  
    FROM dbo.syscolumns COL
    JOIN dbo.sysobjects OBJ ON OBJ.id = COL.id
    JOIN dbo.systypes TYP ON TYP.xusertype = COL.xtype
    --left join dbo.sysconstraints CON on CON.colid = COL.colid
    LEFT JOIN dbo.sysforeignkeys FK ON FK.fkey = COL.colid AND FK.fkeyid=OBJ.id
    LEFT JOIN dbo.sysobjects OBJ2 ON OBJ2.id = FK.rkeyid
    LEFT JOIN dbo.syscolumns COL2 ON COL2.colid = FK.rkey AND COL2.id = OBJ2.id
    WHERE OBJ.name = @tabla AND (OBJ.xtype='U' OR OBJ.xtype='V')

	return
end


/*

Select * from sistema.dbo.GetLiberacion_Plan_Accion('HEL0237-HH00')

*/

GO
