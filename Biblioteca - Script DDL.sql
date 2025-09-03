CREATE TABLE Tab_Unidade_Atendimento (
    codigo_UniAtend       INTEGER NOT NULL CHECK (codigo_UniAtend >= 1),
    nome_UniAtend         VARCHAR(50) NOT NULL,
    endereco_UniAtend     VARCHAR(200) NOT NULL,
    matricula_Bibliotecario INTEGER NOT NULL,

    -- Chave primária
    PRIMARY KEY (codigo_UniAtend),

    -- Chave alternativa / única
    UNIQUE (nome_UniAtend),
    UNIQUE (matricula_Bibliotecario)
);

CREATE TABLE Tab_Telefones_UniAtend (
    codigo_UniAtend       INTEGER NOT NULL,
    telefone_UniAtend     VARCHAR(10) NOT NULL,

    -- Chave primária composta
    PRIMARY KEY (codigo_UniAtend, telefone_UniAtend),

    -- Chave estrangeira
    FOREIGN KEY (codigo_UniAtend) REFERENCES Tab_Unidade_Atendimento(codigo_UniAtend)
);

CREATE TABLE Tab_Unidade_Academica (
    codigo_UniAcad       INTEGER NOT NULL,
    nome_UniAcad         VARCHAR(50) NOT NULL,

    PRIMARY KEY (codigo_UniAcad),
    UNIQUE (nome_UniAcad)
);

CREATE TABLE Tab_Curso (
    codigo_Curso    INTEGER NOT NULL CHECK (codigo_Curso >= 1),
    nome_Curso      VARCHAR(50) NOT NULL,
    codigo_UniAcad INTEGER NOT NULL,

    PRIMARY KEY (codigo_Curso),
    UNIQUE (nome_Curso),
    FOREIGN KEY (codigo_UniAcad) REFERENCES Tab_Unidade_Academica (codigo_UniAcad) --R17
);

CREATE TABLE Tab_Disciplina (
    codigo_Disciplina    INTEGER NOT NULL CHECK (codigo_Disciplina >= 1),
    nome_Disciplina      VARCHAR(50) NOT NULL,

    PRIMARY KEY (codigo_Disciplina)
);

-- Disjunto Total - Sem atributos nas sub entidades - conversão A
CREATE TABLE Tab_Funcionario_Biblioteca (
    matricula_Funcionario INTEGER NOT NULL CHECK (matricula_Funcionario >= 1),
    nome_Funcionario VARCHAR(50) NOT NULL,
    tipo_Funcionario VARCHAR(15) NOT NULL CHECK (tipo_Funcionario IN ('Atendente', 'Bibliotecario')),
    codigo_UniAtend       INTEGER NULL,
    
    PRIMARY KEY (matricula_Funcionario),
    FOREIGN KEY (codigo_UniAtend) REFERENCES Tab_Unidade_Atendimento (codigo_UniAtend) -- R3
); 

ALTER TABLE Tab_Unidade_Atendimento
    ADD CONSTRAINT fk_bibliotecario_responsavel
    FOREIGN KEY (matricula_Bibliotecario) REFERENCES Tab_Funcionario_Biblioteca (matricula_Funcionario);  --R4

CREATE TABLE Tab_Titulo (
    ISBN INTEGER NOT NULL CHECK (ISBN >= 1),
    nome_Titulo VARCHAR(100) NOT NULL,
    area_Principal VARCHAR(100) NOT NULL,
    assunto VARCHAR(100) NOT NULL,
    ano_Publicacao INTEGER NOT NULL,
    editora VARCHAR(50) NOT NULL,
    idioma CHAR(1) NOT NULL,
    prazo_Emprestimo_Professor INTEGER NOT NULL CHECK (prazo_Emprestimo_Professor >= 1),
    prazo_Emprestimo_Aluno INTEGER NOT NULL CHECK (prazo_Emprestimo_Aluno >= 1),
    numero_Max_Renovacao INTEGER NOT NULL CHECK (numero_Max_Renovacao >= 0),
    PRIMARY KEY (ISBN)
);

CREATE TABLE Tab_Areas_Secundarias (
    ISBN INTEGER NOT NULL,
    area_Secundaria VARCHAR(100) NOT NULL,
    PRIMARY KEY (ISBN, area_Secundaria),
    FOREIGN KEY (ISBN) REFERENCES Tab_Titulo (ISBN)
);

CREATE TABLE Tab_Titulo_Livro (
    ISBN INTEGER NOT NULL,
    edicao INTEGER NOT NULL,
    PRIMARY KEY (ISBN),
    FOREIGN KEY (ISBN) REFERENCES Tab_Titulo (ISBN)
);

CREATE TABLE Tab_Autor (
    ISBN INTEGER NOT NULL,
    autor VARCHAR(100) NOT NULL,
    PRIMARY KEY (ISBN, autor),
    FOREIGN KEY (ISBN) REFERENCES Tab_Titulo_Livro (ISBN)
);

-- Tabela para títulos do tipo Periódico
CREATE TABLE Tab_Titulo_Periodico (
    ISBN INTEGER NOT NULL,
    periodicidade VARCHAR(15) NOT NULL CHECK (periodicidade IN (
        'semanal', 'quinzenal', 'mensal', 'trimestral', 
        'quadrimestral', 'semestral', 'anual'
    )),
    tipo CHAR(1) NOT NULL CHECK (tipo IN ('J', 'R', 'B')),
    PRIMARY KEY (ISBN),
    FOREIGN KEY (ISBN) REFERENCES Tab_Titulo (ISBN)
);

-- Tabela principal: Usuários da Biblioteca
CREATE TABLE Tab_Usuario_Biblioteca (
    codigo_Usuario NUMERIC(5) NOT NULL,
    nome_Usuario VARCHAR(50) NOT NULL,
    identidade VARCHAR(12) NULL,
    CPF VARCHAR(14) NULL,
    endereco_Usuario VARCHAR(100) NOT NULL,
    sexo CHAR(1) NOT NULL,
    data_Nascimento DATE NOT NULL,
    estado_Civil CHAR(1) NOT NULL,

    CHECK (codigo_Usuario >= 1),
    CHECK (identidade IS NOT NULL OR CPF IS NOT NULL),
    CHECK (sexo IN ('M', 'F')),
    CHECK (estado_Civil IN ('C', 'S', 'D', 'V')),

    PRIMARY KEY (codigo_Usuario)
);

-- Telefones do usuário (multivalorado)
CREATE TABLE Tab_Telefones_Usuario (
    codigo_Usuario NUMERIC(5) NOT NULL,
    telefone_Usuario NUMERIC(10) NOT NULL,

    PRIMARY KEY (codigo_Usuario, telefone_Usuario),
    FOREIGN KEY (codigo_Usuario) REFERENCES Tab_Usuario_Biblioteca (codigo_Usuario)
);


CREATE TABLE Tab_Usuario_Professor (
    codigo_Usuario NUMERIC(5) NOT NULL,
    matricula_Professor NUMERIC(5) NOT NULL,
    codigo_UniAcad INTEGER NOT NULL,

    CHECK (matricula_Professor >= 1),

    PRIMARY KEY (codigo_Usuario),
    UNIQUE (matricula_Professor),
    FOREIGN KEY (codigo_Usuario) REFERENCES Tab_Usuario_Biblioteca(codigo_Usuario),
    FOREIGN KEY (codigo_UniAcad) REFERENCES Tab_Unidade_Academica (codigo_UniAcad) --R15
);


CREATE TABLE Tab_Usuario_Aluno (
    codigo_Usuario NUMERIC(5) NOT NULL,

    PRIMARY KEY (codigo_Usuario),
    FOREIGN KEY (codigo_Usuario) REFERENCES Tab_Usuario_Biblioteca (codigo_Usuario)
);


CREATE TABLE Tab_Transacao (
    numero_Transacao INTEGER NOT NULL CHECK (numero_Transacao >= 1),
    data_Transacao DATE NOT NULL,
    horario_Transacao TIME NOT NULL,
    matricula_Atendente INTEGER NOT NULL,
    
    PRIMARY KEY (numero_Transacao),
    FOREIGN KEY (matricula_Atendente) REFERENCES Tab_Funcionario_Biblioteca(matricula_Funcionario) --R5
);


-- Emprestimo
CREATE TABLE Tab_Emprestimo (
    numero_Transacao INTEGER NOT NULL,
    codigo_Usuario INTEGER NOT NULL,
    PRIMARY KEY (numero_Transacao),
    FOREIGN KEY (numero_Transacao) REFERENCES Tab_Transacao(numero_Transacao),
    FOREIGN KEY (codigo_Usuario) REFERENCES Tab_Usuario_Biblioteca(codigo_Usuario) --R11
);

-- Devolucao
CREATE TABLE Tab_Devolucao (
    numero_Transacao INTEGER NOT NULL,
    codigo_Usuario INTEGER NOT NULL,
    PRIMARY KEY (numero_Transacao),
    FOREIGN KEY (numero_Transacao) REFERENCES Tab_Transacao(numero_Transacao),
    FOREIGN KEY (codigo_Usuario) REFERENCES Tab_Usuario_Biblioteca(codigo_Usuario) --R12
);

-- Reserva
CREATE TABLE Tab_Reserva (
    numero_Transacao INTEGER NOT NULL,
    codigo_Usuario INTEGER NOT NULL,
    PRIMARY KEY (numero_Transacao),
    FOREIGN KEY (numero_Transacao) REFERENCES Tab_Transacao(numero_Transacao),
    FOREIGN KEY (codigo_Usuario) REFERENCES Tab_Usuario_Biblioteca(codigo_Usuario) --R13
);

-- Renovacao
CREATE TABLE Tab_Renovacao (
    numero_Transacao INTEGER NOT NULL,
    codigo_Professor INTEGER NOT NULL,
    PRIMARY KEY (numero_Transacao),
    FOREIGN KEY (numero_Transacao) REFERENCES Tab_Transacao(numero_Transacao),
    FOREIGN KEY (codigo_Professor) REFERENCES Tab_Usuario_Professor(codigo_Usuario) --R14

);

CREATE TABLE Tab_Copia_Titulo (
    ISBN INTEGER NOT NULL,
    numero_Copia INTEGER NOT NULL,
    secao_copia INTEGER NOT NULL CHECK (secao_copia >= 1),
    estante_copia INTEGER NOT NULL,
    codigo_UniAtend INTEGER NOT NULL,   
    PRIMARY KEY (ISBN, numero_Copia),
    FOREIGN KEY (ISBN) REFERENCES Tab_Titulo(ISBN), --R1 (já tinha pq é entidade fraca)
    FOREIGN KEY (codigo_UniAtend) REFERENCES Tab_Unidade_Atendimento (codigo_UniAtend) --R2
);

CREATE TABLE Tab_Item_Emprestimo (
    numero_Transacao INTEGER NOT NULL,
    numero_Item INTEGER NOT NULL,
    data_LimiteDev DATE NOT NULL,
    multa_Atraso NUMERIC(7,2) NULL,
    multa_Dano NUMERIC(7,2) NULL,
    ISBN               INTEGER      NOT NULL,
    numero_Copia       INTEGER      NOT NULL,
    numero_Transacao_Devolucao INTEGER NULL,

    PRIMARY KEY (numero_Transacao, numero_Item),
    FOREIGN KEY (numero_Transacao) REFERENCES Tab_Emprestimo(numero_Transacao), --R6 (já tinha pq é entidade fraca)
    FOREIGN KEY (ISBN, numero_Copia) REFERENCES Tab_Copia_Titulo (ISBN, numero_Copia), --R7
    FOREIGN KEY (numero_Transacao_Devolucao) REFERENCES Tab_Devolucao(numero_Transacao) --R8
);

--R9
CREATE TABLE Tab_Renovacao_Item ( 
    numero_TransRenov INTEGER NOT NULL,
    numero_TransEmpres INTEGER NOT NULL,
    numero_Item INTEGER NOT NULL,
    data_DevRenov DATE NOT NULL,
    
    PRIMARY KEY (numero_TransRenov, numero_TransEmpres, numero_Item),
    FOREIGN KEY (numero_TransRenov) REFERENCES Tab_Renovacao(numero_Transacao),
    FOREIGN KEY (numero_TransEmpres, numero_Item) REFERENCES Tab_Item_Emprestimo(numero_Transacao, numero_Item)
);

--R10
CREATE TABLE Tab_Reserva_Item ( 
    numero_TransReserva INTEGER NOT NULL,
    ISBN INTEGER NOT NULL,
    numero_Copia INTEGER NOT NULL,
    data_Reserva DATE NOT NULL,
    
    PRIMARY KEY (numero_TransReserva, ISBN, numero_Copia),
    FOREIGN KEY (numero_TransReserva) REFERENCES Tab_Reserva(numero_Transacao),
    FOREIGN KEY (ISBN, numero_Copia) REFERENCES Tab_Copia_Titulo(ISBN, numero_Copia)
);

--R16
CREATE TABLE Tab_Aluno_Curso (
    codigo_Aluno INTEGER NOT NULL,
    codigo_Curso INTEGER NOT NULL,
    matricula_Aluno INTEGER NOT NULL,
    
    UNIQUE (matricula_Aluno),
    PRIMARY KEY (codigo_Aluno, codigo_Curso),
    FOREIGN KEY (codigo_Aluno) REFERENCES Tab_Usuario_Aluno (codigo_Usuario),
    FOREIGN KEY (codigo_Curso) REFERENCES Tab_Curso (codigo_Curso)
);

--R18
CREATE TABLE Tab_Professor_Disciplina (
    codigo_Professor INTEGER NOT NULL,
    codigo_Disciplina INTEGER NOT NULL,
    
    PRIMARY KEY (codigo_Professor, codigo_Disciplina),
    FOREIGN KEY (codigo_Professor) REFERENCES Tab_Usuario_Professor (codigo_Usuario),
    FOREIGN KEY (codigo_Disciplina) REFERENCES Tab_Disciplina (codigo_Disciplina)
);

