-- ================================
-- CONSULTAS - CLÍNICA VETERINÁRIA
-- Cada consulta contém: Pergunta em linguagem natural + Comando SQL + Descrição do retorno
-- ================================

-- Pergunta 1: Quantos pacientes estão cadastrados na clínica?
SELECT COUNT(*) AS pacientes_cadastrados
FROM animais;
-- Descrição do que a consulta retorna: Retorna um valor inteiro a partir da contagem do número de registros (linhas), representando o total de animais cadastrados.
-- Requisitos Abordados: COUNT

-- Pergunta 2: Quais veterinários realizaram mais de 2 atendimentos?
SELECT nome, COUNT(id_atendimento) AS total_atendimentos
FROM veterinarios v
JOIN atendimentos a ON v.id_veterinario = a.id_veterinario
GROUP BY v.id_veterinario, nome
HAVING COUNT(id_atendimento) > 2
ORDER BY total_atendimentos DESC;
-- Descrição do que a consulta retorna: Lista os veterinários que realizaram mais de 2 atendimentos, mostrando quantos cada um fez, ordenado do maior para o menor.
-- Requisitos Abordados: JOIN (2 tabelas), COUNT, GROUP BY, HAVING, ORDER BY

-- Pergunta 3: Qual é o valor médio dos atendimentos realizados por cada veterinário?
SELECT v.nome, ROUND(AVG(s.quantidade * s.valor_unitario)) AS media_valor
FROM veterinarios v
JOIN atendimentos a ON v.id_veterinario = a.id_veterinario
JOIN atendimento_servicos s ON a.id_atendimento = s.id_atendimento
GROUP BY v.id_veterinario, v.nome
ORDER BY media_valor DESC;
-- Descrição do que a consulta retorna: Retorna o nome do veterinário e uma média arredondada do valor cobrado por atendimento,  exibidos em ordem decrescente.
-- Requisitos Abordados: JOIN (3 tabelas), AVG, GROUP BY, ORDER BY

-- Pergunta 4: Quais veterinários já realizaram atendimentos que somaram mais de R$ 500 em serviços? Ordene do maior valor para o menor.
SELECT v.nome, SUM(s.quantidade * s.valor_unitario) AS total_servicos
FROM veterinarios v
JOIN atendimentos a ON v.id_veterinario = a.id_veterinario
JOIN atendimento_servicos s ON a.id_atendimento = s.id_atendimento
GROUP BY v.id_veterinario, v.nome
HAVING SUM(s.quantidade * s.valor_unitario) > 500
ORDER BY total_servicos DESC;
-- Descrição do que a consulta retorna: Retorna nome do veterinário e valor total de serviços prestados cuja soma ultrapassa 500, exibidos em ordem decrescente.
-- Requisitos Abordados: JOIN (3 tabelas), SUM, GROUP BY, HAVING, ORDER BY

-- Pergunta 5: Qual foi o menor e o maior valor de atendimento realizado em cada espécie de paciente?
SELECT e.nome AS especie,
       MIN(s.quantidade * s.valor_unitario) AS menor_valor,
       MAX(s.quantidade * s.valor_unitario) AS maior_valor
FROM especies e
LEFT JOIN racas r ON e.id_especie = r.id_especie
LEFT JOIN animais a ON r.id_raca = a.id_raca
LEFT JOIN atendimentos at ON a.id_animal = at.id_animal
LEFT JOIN atendimento_servicos s ON at.id_atendimento = s.id_atendimento
GROUP BY e.id_especie, e.nome
ORDER BY e.nome;
-- Descrição do que a consulta retorna: Retorna cada espécie com seu valor mínimo e máximo de serviços (NULL para sem atendimentos) e exibidos em ordem alfabética.
-- Requisitos Abordados: LEFT JOIN (5 tabelas), MIN/MAX, GROUP BY, ORDER BY

-- Pergunta 6: Quais pacientes receberam prescrição do medicamento Dipirona Sódica e em qual atendimento isso ocorreu?
SELECT a.nome AS paciente, at.id_atendimento, at.data_atendimento
FROM animais a
JOIN atendimentos at ON a.id_animal = at.id_animal
JOIN prescricoes p ON at.id_atendimento = p.id_atendimento
JOIN medicamentos m ON p.id_medicamento = m.id_medicamento
WHERE m.nome = 'Dipirona Sódica'
ORDER BY at.data_atendimento;
-- Descrição do que a consulta retorna:Retorna o nome dos pacientes, ID e a data dos atendimentos em que houve prescrição de Dipirona Sódica. Os resultados são exibidos pela data do atendimento.
-- Requisitos Abordados: JOIN (4 tabelas), ORDER BY

-- Pergunta 7: Qual medicamento foi mais prescrito para cães da raça Labrador?
SELECT m.nome AS medicamento, COUNT(*) AS total_prescricoes
FROM animais a
JOIN racas r ON a.id_raca = r.id_raca
JOIN atendimentos at ON a.id_animal = at.id_animal
JOIN prescricoes p ON at.id_atendimento = p.id_atendimento
JOIN medicamentos m ON p.id_medicamento = m.id_medicamento
WHERE r.nome = 'Labrador'
GROUP BY m.nome
ORDER BY total_prescricoes DESC
LIMIT 1;
-- Descrição do que a consulta retorna: Retorna apenas o medicamento com maior número de prescrições para Labradores, exibindo o nome e a quantidade de vezes em que foi indicado, mostrando o de maior ocorrência.
-- Requisitos Abordados: JOIN (5 tabelas), COUNT, GROUP BY, ORDER BY, LIMIT

-- Pergunta 8: Quais tutores têm mais de 3 pets cadastrados e quantos atendimentos cada um realizou?
SELECT c.nome AS tutor, COUNT(DISTINCT a.id_animal) AS total_pets, COUNT(at.id_atendimento) AS total_atendimentos
FROM clientes c
JOIN animais a ON c.id_cliente = a.id_cliente
JOIN atendimentos at ON a.id_animal = at.id_animal
GROUP BY c.id_cliente, c.nome
HAVING COUNT(DISTINCT a.id_animal) > 3
ORDER BY total_atendimentos DESC;
-- Descrição do que a consulta retorna: Retorna tutores que possuem mais de três animais cadastrados, mostrando também quantos pets cada um tem e exibidos pelo total de atendimentos realizados.
-- Requisitos Abordados: JOIN (3 tabelas), COUNT, GROUP BY, HAVING, ORDER BY

-- Pergunta 9: Quais raças têm mais de 2 animais cadastrados e qual é o peso total desses animais?
SELECT r.nome AS raca, COUNT(a.id_animal) AS total_animais, SUM(a.peso) AS peso_total
FROM racas r
JOIN animais a ON r.id_raca = a.id_raca
GROUP BY r.id_raca, r.nome
HAVING COUNT(a.id_animal) > 2
ORDER BY total_animais DESC;
-- Descrição do que a consulta retorna: Retorna cada raça que possui mais de dois animais cadastrados, indicando tanto a quantidade de registros quanto a soma dos pesos desses animais, em ordem decrescente.
-- Requisitos Abordados: JOIN (2 tabelas), COUNT, SUM, GROUP BY, HAVING, ORDER BY