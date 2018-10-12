SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[VW_PiezasSPC_RecibidasLaboratorio] as
SELECT        SPC_PiezasLaboratorio.Parte, SPC_PiezasLaboratorio.Cavidad, SPC_PiezasLaboratorio.WOID, SPC_PiezasLaboratorio.Piezas, 
                         SPC_PiezasLaboratorio.Date_Entrega, SPC_PiezasLaboratorio.UsuarioPP, SPC_PiezasLaboratorio.Orden_Prueba, 
                         SPC_PiezasLaboratorio.Date_Recibido, SPC_PiezasLaboratorio.RecibidoPor, SPC_PiezasLaboratorio.Tipo, 
                         Sistema.dbo.ATM_Pruebas_Laboratorio.Estado AS EstadoLab
FROM            EEH.HN.SPC_PiezasLaboratorio INNER JOIN
                         Sistema.dbo.ATM_Pruebas_Laboratorio ON SPC_PiezasLaboratorio.Orden_Prueba = Sistema.dbo.ATM_Pruebas_Laboratorio.Orden_Prueba
WHERE        (SPC_PiezasLaboratorio.Orden_Prueba IS NOT NULL)
GO
