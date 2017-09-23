CREATE TABLE [dbo].[Manual_ADD_To_Floor]
(
[Serial] [int] NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Date_stamp] [datetime] NULL,
[LOCATION] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quantity] [numeric] (20, 2) NOT NULL,
[Custom2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Manual_ADD_To_Floor_Custom2] ON [dbo].[Manual_ADD_To_Floor] ([Custom2]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Manual_ADD_To_Floor_DateStamp] ON [dbo].[Manual_ADD_To_Floor] ([Date_stamp]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Manual_ADD_To_Floor_Location] ON [dbo].[Manual_ADD_To_Floor] ([LOCATION]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Manual_ADD_To_Floor_Part] ON [dbo].[Manual_ADD_To_Floor] ([Part]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Manual_ADD_To_Floor_serial] ON [dbo].[Manual_ADD_To_Floor] ([Serial]) ON [PRIMARY]
GO
