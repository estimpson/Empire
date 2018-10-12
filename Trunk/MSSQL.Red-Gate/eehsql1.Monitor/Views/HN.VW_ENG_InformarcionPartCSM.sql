SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [HN].[VW_ENG_InformarcionPartCSM]
AS
	SELECT DISTINCT  study.Part,study.PartRev,Program,parte.name
					,EAU= CASE WHEN ISNULL(study.EAU,0) = 0 THEN part_eecustom.eau ELSE study.EAU END 
					,Req = Revision.Revision / 48, APQP.SOPDate,EOPDate
	FROM eeh.dbo.ENG_Part_CapacityStudy study INNER JOIN 
			( SELECT part=left(part,7),Name = MAX(Name)
			   FROM eeh.dbo.part
			   GROUP BY  left(part,7)		
			) parte on study.Part = parte.part
			LEFT JOIN 
			(	SELECT Revision.Revision,Revision.Part
				FROM 	Sistema.dbo.CP_Revisiones_Produccion_Asignacion Revision INNER JOIN 
									Sistema.dbo.CP_Contenedores Contenedor on Revision.ContenedorID = Contenedor.ContenedorID AND Contenedor.Activo = 1 
			) Revision ON LEFT(Revision.Part,7) = LEFT(study.Part,7)
			INNER JOIN 
			( SELECT SOPDate=MIN(EEHShipDate),Part=LEFT(Part,7)
			  FROM eeh.dbo.VW_ProgramAPQP 
			  GROUP BY LEFT(Part,7)
			) APQP ON LEFT(APQP.Part,7) = LEFT(study.Part,7)
			INNER JOIN part_eecustom part_eecustom ON part_eecustom.part = study.Part+ '-' + study.PartRev   

GO
