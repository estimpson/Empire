CREATE TABLE [dbo].[protransorders]
(
[customerpart] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[licenseplate] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[qty] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dateshipped] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[timeshipped] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customerid] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[protransordernumber] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[protransorders] ADD CONSTRAINT [pk_ProtransShipments] PRIMARY KEY CLUSTERED  ([licenseplate], [dateshipped]) ON [PRIMARY]
GO
