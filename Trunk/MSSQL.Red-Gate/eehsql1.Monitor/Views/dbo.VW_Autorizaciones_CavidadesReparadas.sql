SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[VW_Autorizaciones_CavidadesReparadas] as
SELECT        VW_AL_MD_AsociacionesPMM.Parte, VW_AL_MD_AsociacionesPMM.Molde, VW_AL_MD_AsociacionesPMM.Maquina, MD_EntradaSalida_Moldes.Cavidad, 
                         MD_EntradaSalida_Moldes.Fecha, MD_EntradaSalida_Moldes.AutorizadaPor
FROM            sistema.dbo.MD_EntradaSalida_Moldes INNER JOIN
                         sistema.dbo.VW_AL_MD_AsociacionesPMM ON MD_EntradaSalida_Moldes.PMMID = VW_AL_MD_AsociacionesPMM.PMM_ID
WHERE        (MD_EntradaSalida_Moldes.AutorizadaPor IS NOT NULL) AND (MD_EntradaSalida_Moldes.AutorizadaPor <> '0') AND 
                         (MD_EntradaSalida_Moldes.AutorizadaPor <> 'NA') AND (MD_EntradaSalida_Moldes.AutorizadaPor <> 'N/A') AND 
                         (MD_EntradaSalida_Moldes.Fecha >= CONVERT(DATETIME, '2014-01-01 00:00:00', 102)) AND (MD_EntradaSalida_Moldes.Transaccion = 'S')
GO
