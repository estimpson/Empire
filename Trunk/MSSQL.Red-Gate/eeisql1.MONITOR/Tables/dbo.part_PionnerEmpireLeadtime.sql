CREATE TABLE [dbo].[part_PionnerEmpireLeadtime]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[vendor] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EmpireLeadTime] [numeric] (20, 6) NULL,
[PioneerLeadTime] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[part_PionnerEmpireLeadtime] ADD CONSTRAINT [PK_part_PionnerEMPLead] PRIMARY KEY CLUSTERED  ([part], [vendor]) ON [PRIMARY]
GO
