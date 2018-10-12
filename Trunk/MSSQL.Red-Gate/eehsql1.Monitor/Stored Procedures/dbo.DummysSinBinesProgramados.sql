SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
/*
	EXEC monitor.dbo.DummysSinBinesProgramados 732
*/

CREATE PROCEDURE [dbo].[DummysSinBinesProgramados]
	@contenedorID int
AS
BEGIN
	SELECT DISTINCT Dummy.parent_part, Dummy.Part, Dummy.BIN
FROM   (
              SELECT xrt.parent_part ,xrt.Part ,EBP  ,BIN 
             FROM (      SELECT partsubensamble=xrt.childpart, EBP= p.PartSubEnsamble ,p.BIN 
                                  FROM   eeh.HN.PCB_ProductionControl P
                                                      INNER JOIN  FT.XRT  XRT  ON  P.partsubEnsamble=xrt.toppart
                                  WHERE  contenedorID = @contenedorID and partsubensamble like'SMT-EBP%' and xrt.BOMLevel =1  and BIN <>'N/A'
						union all   
                         SELECT Partsubensamble,EBP='',BIN 
                                  FROM   eeh.HN.PCB_ProductionControl

                                  WHERE  contenedorID = (SELECT	ContenedorID 
														FROM	eeh.dbo.cp_contenedores
														WHERE	activo = 1) and partsubensamble not like'SMT-EBP%' and BIN <>'N/A'
						UNION ALL
                        select Partsubensamble=XRT.ChildPart ,EBP='',BIN 
                                  from   eeh.HN.PCB_ProductionControl  p inner join ft.XRt  xrt on  xrt .TopPart =p.PartSubEnsamble 

                                  where  contenedorID = @CONTENEDORid and partsubensamble not like'SMT-EBP%' and BIN <>'N/A' and xrt .ChildPart like 'THT%'


                     ) controlproduccion
                           join eeh.HN.vw_BF_BOMInformation xrt on controlproduccion.PartSubEnsamble = xrt.parent_part 
                           join eeh.dbo.part part on part.part=xrt.Part and part.name like '%DUMMY%' 
             ) Dummy
             left join eeh.hn.vw_PCB_Part_BIN bin on Dummy.Part = Bin.BOMPart and Dummy.parent_part  = Bin.ProductionPart and Dummy.BIN = bin.BIN
WHERE  Bin.ProductionPart is null
END
GO
