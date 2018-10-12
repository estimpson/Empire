SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create view [HN].[PCB_ESDSensitivity_Level]  as select * from EEH.hn.PCB_ESDSensitivity_Level 

GO
GRANT SELECT ON  [HN].[PCB_ESDSensitivity_Level] TO [public]
GO
GRANT VIEW DEFINITION ON  [HN].[PCB_ESDSensitivity_Level] TO [public]
GO
