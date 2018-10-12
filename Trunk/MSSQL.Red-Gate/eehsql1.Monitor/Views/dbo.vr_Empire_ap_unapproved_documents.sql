SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[vr_Empire_ap_unapproved_documents] as
SELECT	*
from	EEH_Empower.dbo.vr_ap_unapproved_documents
GO
