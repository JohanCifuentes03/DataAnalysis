CREATE TABLE [pais] (
  [id] integer PRIMARY KEY,
  [nombre] nvarchar(255)
)
GO

CREATE TABLE [ciudad] (
  [id] integer PRIMARY KEY,
  [id_pais] integer,
  [nombre] nvarchar(255)
)
GO

CREATE TABLE [genero] (
  [id] integer PRIMARY KEY,
  [tipo] nvarchar(255)
)
GO

CREATE TABLE [artGenero] (
  [id_genero] integer,
  [id_artista] integer
)
GO

CREATE TABLE [artista] (
  [id] integer PRIMARY KEY,
  [id_ciudad] integer,
  [nombre] nvarchar(255),
  [fecha_nacimiento] date
)
GO

CREATE TABLE [artAlbum] (
  [id_artista] integer,
  [id_album] integer
)
GO

CREATE TABLE [album] (
  [id] integer PRIMARY KEY,
  [nombre] nvarchar(255)
)
GO

CREATE TABLE [cancion] (
  [id] integer PRIMARY KEY,
  [id_album] integer,
  [titulo] nvarchar(255),
  [duracion] time
)
GO

CREATE TABLE [usuario] (
  [id] integer PRIMARY KEY,
  [id_ciudad] integer,
  [nombre] nvarchar(255),
  [email] nvarchar(255),
  [fecha_nacimiento] date
)
GO

CREATE TABLE [compra] (
  [id] integer,
  [id_cancion] integer,
  [id_usuario] integer,
  [fecha] timestamp
)
GO

ALTER TABLE [artGenero] ADD FOREIGN KEY ([id_genero]) REFERENCES [genero] ([id])
GO

ALTER TABLE [artGenero] ADD FOREIGN KEY ([id_artista]) REFERENCES [artista] ([id])
GO

ALTER TABLE [ciudad] ADD FOREIGN KEY ([id_pais]) REFERENCES [pais] ([id])
GO

ALTER TABLE [artista] ADD FOREIGN KEY ([id_ciudad]) REFERENCES [ciudad] ([id])
GO

ALTER TABLE [usuario] ADD FOREIGN KEY ([id_ciudad]) REFERENCES [ciudad] ([id])
GO

ALTER TABLE [artAlbum] ADD FOREIGN KEY ([id_artista]) REFERENCES [artista] ([id])
GO

ALTER TABLE [artAlbum] ADD FOREIGN KEY ([id_album]) REFERENCES [album] ([id])
GO

ALTER TABLE [cancion] ADD FOREIGN KEY ([id_album]) REFERENCES [album] ([id])
GO

ALTER TABLE [compra] ADD FOREIGN KEY ([id_cancion]) REFERENCES [cancion] ([id])
GO

ALTER TABLE [compra] ADD FOREIGN KEY ([id_usuario]) REFERENCES [usuario] ([id])
GO
