CREATE TABLE [FT].[SchedulerCustomer]
(
[CustomerCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OperatorCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[SchedulerCustomer] ADD CONSTRAINT [PK__CustomerSchedule__2EF0D041] PRIMARY KEY CLUSTERED  ([CustomerCode]) ON [PRIMARY]
GO
ALTER TABLE [FT].[SchedulerCustomer] ADD CONSTRAINT [FK__CustomerS__Custo__2FE4F47A] FOREIGN KEY ([CustomerCode]) REFERENCES [dbo].[customer] ([customer]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [FT].[SchedulerCustomer] ADD CONSTRAINT [FK__CustomerS__Opera__30D918B3] FOREIGN KEY ([OperatorCode]) REFERENCES [FT].[Schedulers] ([OperatorCode]) ON DELETE CASCADE ON UPDATE CASCADE
GO
