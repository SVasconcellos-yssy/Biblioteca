-- Criação do banco de dados para Sistema de Biblioteca
CREATE DATABASE biblioteca;
USE biblioteca;

-- Tabela Autores
CREATE TABLE IF NOT EXISTS Autores (
    idAutor INT AUTO_INCREMENT PRIMARY KEY,
    NomeAutor VARCHAR(50) NOT NULL
);

-- Tabela Livros
CREATE TABLE IF NOT EXISTS Livros (
    idLivro INT AUTO_INCREMENT PRIMARY KEY,
    Titulo VARCHAR(100) NOT NULL,
    idAutor INT,
    AnoPublicacao INT,
    CONSTRAINT fk_livros_autores FOREIGN KEY (idAutor) REFERENCES Autores(idAutor)
);

-- Tabela Leitores
CREATE TABLE IF NOT EXISTS Leitores (
    idLeitor INT AUTO_INCREMENT PRIMARY KEY,
    NomeLeitor VARCHAR(50) NOT NULL,
    DataNascimento DATE,
    Email VARCHAR(100)
);

-- Tabela Empréstimos
CREATE TABLE IF NOT EXISTS Emprestimos (
    idEmprestimo INT AUTO_INCREMENT PRIMARY KEY,
    idLivro INT,
    idLeitor INT,
    DataEmprestimo DATE,
    DataDevolucao DATE,
    Status ENUM('Empréstimo', 'Devolvido') DEFAULT 'Empréstimo',
    CONSTRAINT fk_emprestimos_livros FOREIGN KEY (idLivro) REFERENCES Livros(idLivro),
    CONSTRAINT fk_emprestimos_leitores FOREIGN KEY (idLeitor) REFERENCES Leitores(idLeitor)
);

-- Tabela Editoras
CREATE TABLE IF NOT EXISTS Editoras (
    idEditora INT AUTO_INCREMENT PRIMARY KEY,
    NomeEditora VARCHAR(100) NOT NULL,
    Localizacao VARCHAR(50)
);

-- Tabela Gêneros
CREATE TABLE IF NOT EXISTS Generos (
    idGenero INT AUTO_INCREMENT PRIMARY KEY,
    NomeGenero VARCHAR(50) NOT NULL
);

-- Tabela Exemplares
CREATE TABLE IF NOT EXISTS Exemplares (
    idExemplar INT AUTO_INCREMENT PRIMARY KEY,
    idLivro INT,
    NumeroExemplar INT NOT NULL,
    Situacao ENUM('Disponível', 'Emprestado') DEFAULT 'Disponível',
    CONSTRAINT fk_exemplares_livros FOREIGN KEY (idLivro) REFERENCES Livros(idLivro)
);

-- Tabela Reservas
CREATE TABLE IF NOT EXISTS Reservas (
    idReserva INT AUTO_INCREMENT PRIMARY KEY,
    idLeitor INT,
    idExemplar INT,
    DataReserva DATE,
    Status ENUM('Ativa', 'Cancelada') DEFAULT 'Ativa',
    CONSTRAINT fk_reservas_leitores FOREIGN KEY (idLeitor) REFERENCES Leitores(idLeitor),
    CONSTRAINT fk_reservas_exemplares FOREIGN KEY (idExemplar) REFERENCES Exemplares(idExemplar)
);

-- Preenchimento da tabela Autores
INSERT INTO Autores (NomeAutor) VALUES
    ('J.K. Rowling'),
    ('George Orwell'),
    ('Jane Austen'),
    ('Stephen King'),
    ('Harper Lee');

-- Preenchimento da tabela Editoras
INSERT INTO Editoras (NomeEditora, Localizacao) VALUES
    ('Editora A', 'Cidade A'),
    ('Editora B', 'Cidade B'),
    ('Editora C', 'Cidade C'),
    ('Editora D', 'Cidade D');

-- Preenchimento da tabela Generos
INSERT INTO Generos (NomeGenero) VALUES
    ('Ficção'),
    ('Fantasia'),
    ('Suspense'),
    ('Romance'),
    ('Não-Ficção');

-- Preenchimento da tabela Livros
INSERT INTO Livros (Titulo, idAutor, AnoPublicacao) VALUES
    ('Harry Potter e a Pedra Filosofal', 1, 1997),
    ('1984', 2, 1949),
    ('Orgulho e Preconceito', 3, 1813),
    ('O Iluminado', 4, 1977),
    ('O Sol é para Todos', 5, 1960);

-- Preenchimento da tabela Leitores
INSERT INTO Leitores (NomeLeitor, DataNascimento, Email) VALUES
    ('Ana Silva', '1990-05-15', 'ana@example.com'),
    ('Carlos Santos', '1985-09-22', 'carlos@example.com'),
    ('Mariana Souza', '2000-01-10', 'mariana@example.com');

-- Preenchimento da tabela Exemplares
INSERT INTO Exemplares (idLivro, NumeroExemplar, Situacao) VALUES
    (1, 101, 'Disponível'),
    (1, 102, 'Emprestado'),
    (2, 201, 'Disponível'),
    (3, 301, 'Disponível'),
    (4, 401, 'Disponível');

-- Preenchimento da tabela Reservas
INSERT INTO Reservas (idLeitor, idExemplar, DataReserva) VALUES
    (1, 3, '2023-07-20'),
    (2, 1, '2023-08-05'),
    (3, 2, '2023-08-10');
    
-- Consultas para o Sistema de Biblioteca

-- Listar todos os livros
SELECT * FROM Livros;

-- Listar todos os autores
SELECT * FROM Autores;

-- Listar os livros de um autor específico
SELECT Titulo FROM Livros WHERE idAutor = 1; -- Substitua 1 pelo ID do autor desejado

-- Listar leitores que fizeram reservas ativas
SELECT L.NomeLeitor, R.DataReserva
FROM Leitores L
INNER JOIN Reservas R ON L.idLeitor = R.idLeitor
WHERE R.Status = 'Ativa';

-- Contar quantos exemplares de um livro estão disponíveis
SELECT L.Titulo, COUNT(E.idExemplar) AS ExemplaresDisponiveis
FROM Livros L
LEFT JOIN Exemplares E ON L.idLivro = E.idLivro AND E.Situacao = 'Disponível'
GROUP BY L.idLivro;

-- Mostrar os leitores que fizeram reservas e seus detalhes
SELECT L.NomeLeitor, R.DataReserva, L.Email, LR.NumeroExemplar, Livros.Titulo
FROM Leitores L
INNER JOIN Reservas R ON L.idLeitor = R.idLeitor
INNER JOIN Exemplares LR ON R.idExemplar = LR.idExemplar
INNER JOIN Livros ON LR.idLivro = Livros.idLivro;

-- Verificar exemplares de um livro e seus status
SELECT E.NumeroExemplar, E.Situacao
FROM Exemplares E
INNER JOIN Livros L ON E.idLivro = L.idLivro
WHERE L.Titulo = 'Harry Potter e a Pedra Filosofal'; -- Substitua pelo título do livro desejado
