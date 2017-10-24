CREATE TABLE [dbo].[part_class_type_cross_ref]
(
[class] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[type] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[part_class_type_cross_ref] ADD CONSTRAINT [PK__part_class_type___78F3E6EC] PRIMARY KEY CLUSTERED  ([class], [type]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[part_class_type_cross_ref] ADD CONSTRAINT [FK__part_clas__class__66361833] FOREIGN KEY ([class]) REFERENCES [dbo].[part_class_definition] ([class])
GO
ALTER TABLE [dbo].[part_class_type_cross_ref] ADD CONSTRAINT [FK__part_clas__class__6541F3FA] FOREIGN KEY ([class]) REFERENCES [dbo].[part_class_definition] ([class])
GO
ALTER TABLE [dbo].[part_class_type_cross_ref] ADD CONSTRAINT [FK__part_class__type__681E60A5] FOREIGN KEY ([type]) REFERENCES [dbo].[part_type_definition] ([type])
GO
ALTER TABLE [dbo].[part_class_type_cross_ref] ADD CONSTRAINT [FK__part_class__type__672A3C6C] FOREIGN KEY ([type]) REFERENCES [dbo].[part_type_definition] ([type])
GO
