SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE	view [HN].[VW_BF_Audit_trail_NoBF] as
SELECT	*
FROM	EEH.HN.VW_BF_Audit_trail_NoBF WITH (READUNCOMMITTED)
GO
