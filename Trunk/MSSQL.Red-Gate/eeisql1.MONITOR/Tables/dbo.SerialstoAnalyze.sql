CREATE TABLE [dbo].[SerialstoAnalyze]
(
[serial] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SerialstoAnalyze] ADD CONSTRAINT [PK_SerialstoAnalyze_1] PRIMARY KEY CLUSTERED  ([serial]) ON [PRIMARY]
GO
