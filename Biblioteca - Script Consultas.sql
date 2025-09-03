
-- 1. Obter relação de títulos do acervo da biblioteca.
-- A relação deve conter o ISBN, o nome do título, a editora e o tipo do título.
-- A relação deve ser ordenada por tipo e nome do título.

SELECT isbn, nome_titulo, editora, tipo_titulo
FROM Tab_Titulos
ORDER BY tipo_titulo, nome_titulo;


-- 2. Obter relação de periódicos quinzenais da biblioteca.A relação deve conter o tipo do
-- periódico, o nome do periódico e a editora e deve ser ordenada por tipo e nome.


SELECT tipo_periodico, nome_titulo, editora
FROM Tab_Titulos
WHERE periodicidade = 'quinzenal'
ORDER BY tipo_periodico, nome_titulo;

-- 3. Obter relação de usuários que já fizeram mais de vinte empréstimos
-- contendo o código do usuário, o nome do usuário e a quantidade de empréstimos feitos
-- A relação deve ser mostrada em ordem decrescente de quantidade de empréstimos feitos
-- por ordem crescente de nome do usuário.

SELECT u.codigo, u.nome, COUNT(e.numero_emprestimo) AS qtd_emprestimos
FROM Tab_Usuarios u
JOIN Tab_Emprestimos e ON u.codigo = e.usuario
GROUP BY u.codigo, u.nome
HAVING COUNT(e.numero_emprestimo) > 20
ORDER BY qtd_emprestimos DESC, u.nome ASC;

-- 4. Obter relação de alunos que devolveram itens de acervo com atraso ou com defeito.
-- A relação deve conter o nome do aluno, a unidade da biblioteca em que empréstimo foi feito,
-- o número do empréstimo, a data do empréstimo, o nome do atendente que registrou o empréstimo,
-- o código da cópia, a data em que a devolução aconteceu e o valor da multa paga.

SELECT
    usr.nome AS nome_aluno,
    ua.nome AS unidade_biblioteca,
    emp.numero_emprestimo,
    trans_emp.data_transacao AS data_emprestimo,
    atd.nome AS nome_atendente,
    ie.isbn_copia || '-' || ie.numero_copia AS codigo_copia,
    trans_dev.data_transacao AS data_devolucao,
    (ie.multa_atraso_devolucao + ie.multa_dano_devolucao) AS multa_paga
FROM
    Tab_Itens_Emprestimos AS ie
JOIN
    Tab_Emprestimos AS emp ON ie.numero_emprestimo = emp.numero_emprestimo
JOIN
    Tab_Usuarios AS usr ON emp.usuario = usr.codigo
JOIN
    Tab_Usuarios_Alunos AS alu ON usr.codigo = alu.codigo_usuario
JOIN
    Tab_Transacoes AS trans_emp ON emp.numero_emprestimo = trans_emp.numero_transacao
JOIN
    Tab_Atendentes AS atd ON trans_emp.atendente = atd.matricula
JOIN
    Tab_Copias_Titulos AS ct ON ie.isbn_copia = ct.isbn_copia AND ie.numero_copia = ct.numero_copia
JOIN
    Tab_Unidades_Atendimento AS ua ON ct.unidade_atendimento = ua.codigo
JOIN
    Tab_Transacoes AS trans_dev ON ie.numero_devolucao = trans_dev.numero_transacao
WHERE
    ie.multa_atraso_devolucao > 0 OR ie.situacao_devolucao = 'D';

-- 5. Obter relação de alunos do curso de “Ciência da Computação” que nunca fizeram empréstimos.
-- A relação deve conter a matrícula do aluno, o nome do aluno e seu(s) telefone(s) de contato.
-- Ordenar a relação por nome do aluno.

SELECT AC.matricula, U.nome, TU.telefone
FROM Tab_Usuarios U
INNER JOIN Tab_Usuarios_Alunos UA ON U.codigo = UA.codigo_usuario
INNER JOIN Tab_Alunos_Cursos AC ON UA.codigo_usuario = AC.codigo_usuario
INNER JOIN Tab_Cursos C ON AC.codigo_curso = C.codigo
LEFT JOIN Tab_Telefones_Usuarios TU ON U.codigo = TU.codigo_usuario
LEFT JOIN Tab_Emprestimos E ON U.codigo = E.usuario
WHERE C.nome = 'Ciência da Computação' AND E.numero_emprestimo IS NULL
ORDER BY U.nome ASC;
