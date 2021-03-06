CREATE TABLE IF NOT EXISTS Loja (
    Id    INTEGER		PRIMARY KEY AUTOINCREMENT,
    nome  STRING (50) 	NOT NULL,
    email STRING (50) 	UNIQUE NOT NULL,
    senha STRING (255) 	NOT NULL
);

CREATE TABLE IF NOT EXISTS Caixa (
    Id    		INTEGER 		PRIMARY KEY AUTOINCREMENT,
    saldoTotal  DECIMAL(9, 2) 	NOT NULL,
	IdLoja 		INTEGER 		NOT NULL,
	FOREIGN KEY (IdLoja)
	REFERENCES Loja (Id)
);

CREATE TABLE IF NOT EXISTS Categoria (
	Id 		INTEGER 	PRIMARY KEY AUTOINCREMENT,
	nome 	STRING (50) NOT NULL,
	IdLoja 	INTEGER 	NOT NULL,
	FOREIGN KEY (IdLoja)
	REFERENCES Loja (Id)
);

CREATE TABLE IF NOT EXISTS Movimento (
    Id 			INTEGER 		PRIMARY KEY AUTOINCREMENT,
    IdCategoria INTEGER 		NOT NULL,
	Data 		DATE 			NOT NULL,
	valor 		DECIMAL(9, 2) 	NOT NULL,
	tipo 		STRING (20) 	NOT NULL,
	DESCRICAO 	STRING (200)	NOT NULL,
	IdCaixa 	INTEGER 		NOT NULL,
	FOREIGN KEY (IdCaixa)
	REFERENCES Caixa (Id)
);

