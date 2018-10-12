SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [HN].[BF_FirstPiece_HeatCut] as
	select	*
	from	EEH.HN.BF_FirstPiece_HeatCut with (ReadunCommitted)
GO
