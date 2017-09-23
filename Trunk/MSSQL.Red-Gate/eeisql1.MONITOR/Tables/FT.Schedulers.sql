CREATE TABLE [FT].[Schedulers]
(
[OperatorCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[Schedulers] ADD CONSTRAINT [PK__Schedulers__2C146396] PRIMARY KEY CLUSTERED  ([OperatorCode]) ON [PRIMARY]
GO
ALTER TABLE [FT].[Schedulers] ADD CONSTRAINT [FK__Scheduler__Opera__2D0887CF] FOREIGN KEY ([OperatorCode]) REFERENCES [dbo].[employee] ([operator_code]) ON DELETE CASCADE ON UPDATE CASCADE
GO
