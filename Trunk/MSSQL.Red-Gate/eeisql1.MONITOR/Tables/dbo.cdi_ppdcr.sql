CREATE TABLE [dbo].[cdi_ppdcr]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[p_age] [int] NULL,
[pointsd] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cdi_ppdcr] ADD CONSTRAINT [PK__cdi_ppdcr__7F80E8EA] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
