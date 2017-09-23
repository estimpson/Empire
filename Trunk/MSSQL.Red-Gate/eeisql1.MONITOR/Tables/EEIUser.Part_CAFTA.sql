CREATE TABLE [EEIUser].[Part_CAFTA]
(
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CustomsDescription] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HTSUSNumber] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PreferenceCriteria] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherCriteria] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Producer] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[Part_CAFTA] ADD CONSTRAINT [PK_Part_CAFTA] PRIMARY KEY CLUSTERED  ([Part]) ON [PRIMARY]
GO
