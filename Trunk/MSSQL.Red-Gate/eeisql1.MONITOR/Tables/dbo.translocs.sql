CREATE TABLE [dbo].[translocs]
(
[serial] [int] NOT NULL,
[location] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[parent_serial] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[translocs] ADD CONSTRAINT [translocskey] PRIMARY KEY CLUSTERED  ([serial]) ON [PRIMARY]
GO
