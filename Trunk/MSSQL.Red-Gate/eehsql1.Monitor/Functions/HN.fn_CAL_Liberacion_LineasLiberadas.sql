SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [HN].[fn_CAL_Liberacion_LineasLiberadas] (
	@FechaContenedor_ARevisar date  )
returns @Liberaciones table (
	Contenedor		DATE,
	Part			VARCHAR(25),
	Linea			VARCHAR(10),
	LMAsociado		VARCHAR(15),
	LMLiberado		VARCHAR(15),
	LiberacionID	INT,
	TransDT			DATETIME, 
	Operator_code	VARCHAR(15),
	Coordinador		VARCHAR(35)
	)
AS
BEGIN

Insert into @Liberaciones 	

SELECT Datos.*, parts.CoordinadorProduccion FROM 
(
Select	Contenedor, 
		CuadroResumen.Part, 
		Linea= CuadroResumen.machine, 
		LMAsociado = PruebaElectricaActivas.Machine, 
		LMLiberado = Liberaciones.PruebaElectNo,
		Liberaciones.LiberacionID,
		Liberaciones.TransDT, Liberaciones.Operator_code
from	hn.fn_CAL_Liberacion_CuadroResumen(@FechaContenedor_ARevisar) CuadroResumen
	left join sistema.dbo.vw_Cal_Liberacion_PruebaElectricaActivas PruebaElectricaActivas
		 on left(CuadroResumen.machine,7) = PruebaElectricaActivas.Line

	left join (
Select	Liberaciones.Part,
		Machine = left(PartMachine.machine,7),
		LiberacionID = max(Liberaciones.LiberacionID),
		TransDT = max(Liberaciones.TransDT),		
		PruebaElectNo, 
		--DEM Added May 2nd-2017. Req. by Sindy A.
		Operator_code  = MAX(Operator_code) 
FROM	Sistema.dbo.Cal_Liberaciones Liberaciones
	inner join eeh.dbo.part_machine PartMachine
			on Liberaciones.Part = PartMachine.part
WHERE	Tipo = 'PE'
		and TransDT >= dateadd(day,-13,@FechaContenedor_ARevisar)
		and TransDT <= dateadd(day,-7,@FechaContenedor_ARevisar)
GROUP BY Liberaciones.Part, left(PartMachine.machine,7), PruebaElectNo) Liberaciones
	on CuadroResumen.Part = Liberaciones.Part
		and PruebaElectricaActivas.Machine = Liberaciones.PruebaElectNo
where	Comentario='Liberarse'
--and PruebaElectricaActivas.Machine = Liberaciones.PruebaElectNo 
) AS Datos
	LEFT JOIN Sistema.dbo.SA_Partes parts
		ON Datos.Part = parts.Part
order by 1

return
end
GO
