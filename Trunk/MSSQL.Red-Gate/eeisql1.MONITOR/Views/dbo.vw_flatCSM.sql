SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vw_flatCSM] as
Select basepart, oem, program, vehicle, partname from FlatCSM
left join	( Select left(part.part,7) as BasepartPart,
			max(name) as PartName
		from part
		group by left(part.part,7)) Part on FlatCSM.basepart = PArt.BASEPArtPart
GO
