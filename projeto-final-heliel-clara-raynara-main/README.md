# Projeto Final de Bancos de Dados - Clínica Veterinária
## Membros do Grupo
- Raynara Gustavo da Costa
- Maria Clara Nunes Linhares
- Heliel William Da Silva
## Contexto e Descrição do Sistema

O sistema de banco de dados desenvolvido tem como objetivo gerenciar as operações de uma clínica veterinária. Ele resolve o problema de organização e controle de informações relacionadas a pacientes (animais), seus tutores (clientes), veterinários, atendimentos médicos, serviços prestados, medicamentos prescritos e histórico de consultas.

O contexto do sistema é uma clínica veterinária que atende animais de diversas espécies, oferecendo serviços como consultas, vacinas, cirurgias, exames e prescrição de medicamentos. Os usuários do sistema incluem veterinários (para registrar atendimentos e prescrições), recepcionistas (para cadastrar clientes e animais) e eventualmente os tutores (para consultar histórico de seus pets).

O banco armazena informações sobre:
- Espécies e raças de animais
- Dados dos clientes (tutores)
- Cadastro dos animais (pacientes)
- Veterinários e suas especialidades
- Atendimentos realizados, com data, hora, motivo e peso do dia
- Serviços prestados e seus valores
- Medicamentos disponíveis e prescrições
- Relacionamentos entre atendimentos e serviços/medicamentos

Isso permite um controle eficiente dos registros médicos, faturamento e histórico de saúde dos animais.
## Instalação e Uso com Docker

### Pré-requisitos
- Docker e Docker Compose instalados no sistema.

### Passos para Executar o Projeto
1. Clone ou baixe o repositório.
2. Navegue até a pasta do projeto.
3. Execute o comando para subir o container MySQL:
   ```
   docker-compose up -d
   ```
   Isso criará o container MySQL com o banco `dbclinica_vet` e executará o script `clinica.sql` para criar as tabelas e inserir dados.

4. Para acessar o MySQL dentro do container:
   ```
   docker exec -it mysql_clinica2 mysql -u root -proot
   ```
  

5. Dentro do MySQL, selecione o banco:
   ```
   USE dbclinica_vet;
   ```

6. Para visualizar as tabelas:
   ```
   SHOW TABLES;
   ```

7. Para executar consultas, copie e cole os comandos do arquivo `Consultas.sql` ou do README.

8. Para parar o container:
   ```
   docker-compose down
   ```

**Nota:** O script SQL completo está em `clinica.sql`, e as consultas em `Consultas.sql`.


## Consultas SQL

As consultas estão organizadas com pergunta em linguagem natural, comando SQL e descrição do retorno. Elas atendem aos requisitos de mínimo 8 consultas, pelo menos 3 com JOIN envolvendo 3 ou mais tabelas, e uso de funções de agregação (MIN, MAX, AVG, SUM, COUNT), ORDER BY, GROUP BY e HAVING.

### Pergunta 1: Quantos pacientes estão cadastrados na clínica?
```sql
SELECT COUNT(*) AS pacientes_cadastrados
FROM animais;
```
**Descrição:** Retorna um valor inteiro representando o total de animais cadastrados.  
**Requisitos:** COUNT

### Pergunta 2: Quais veterinários realizaram mais de 2 atendimentos?
```sql
SELECT nome, COUNT(id_atendimento) AS total_atendimentos
FROM veterinarios v
JOIN atendimentos a ON v.id_veterinario = a.id_veterinario
GROUP BY v.id_veterinario, nome
HAVING COUNT(id_atendimento) > 2
ORDER BY total_atendimentos DESC;
```
**Descrição:** Lista os veterinários que realizaram mais de 2 atendimentos, mostrando quantos cada um fez, ordenado do maior para o menor.  
**Requisitos:** JOIN (2 tabelas), COUNT, GROUP BY, HAVING, ORDER BY

### Pergunta 3: Qual é o valor médio dos atendimentos realizados por cada veterinário?
```sql
SELECT v.nome, ROUND(AVG(s.quantidade * s.valor_unitario)) AS media_valor
FROM veterinarios v
JOIN atendimentos a ON v.id_veterinario = a.id_veterinario
JOIN atendimento_servicos s ON a.id_atendimento = s.id_atendimento
GROUP BY v.id_veterinario, v.nome
ORDER BY media_valor DESC;
```
**Descrição:** Retorna o nome do veterinário e uma média arredondada do valor cobrado por atendimento, exibidos em ordem decrescente.  
**Requisitos:** JOIN (3 tabelas), AVG, GROUP BY, ORDER BY

### Pergunta 4: Quais veterinários já realizaram atendimentos que somaram mais de R$ 500 em serviços? Ordene do maior valor para o menor.
```sql
SELECT v.nome, SUM(s.quantidade * s.valor_unitario) AS total_servicos
FROM veterinarios v
JOIN atendimentos a ON v.id_veterinario = a.id_veterinario
JOIN atendimento_servicos s ON a.id_atendimento = s.id_atendimento
GROUP BY v.id_veterinario, v.nome
HAVING SUM(s.quantidade * s.valor_unitario) > 500
ORDER BY total_servicos DESC;
```
**Descrição:** Retorna nome do veterinário e valor total de serviços prestados cuja soma ultrapassa 500, exibidos em ordem decrescente.  
**Requisitos:** JOIN (3 tabelas), SUM, GROUP BY, HAVING, ORDER BY

### Pergunta 5: Qual foi o menor e o maior valor de atendimento realizado em cada espécie de paciente?
```sql
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
```
**Descrição:** Retorna cada espécie com seu valor mínimo e máximo de serviços (NULL para sem atendimentos) e exibidos em ordem alfabética.  
**Requisitos:** LEFT JOIN (5 tabelas), MIN/MAX, GROUP BY, ORDER BY

### Pergunta 6: Quais pacientes receberam prescrição do medicamento Dipirona Sódica e em qual atendimento isso ocorreu?
```sql
SELECT a.nome AS paciente, at.id_atendimento, at.data_atendimento
FROM animais a
JOIN atendimentos at ON a.id_animal = at.id_animal
JOIN prescricoes p ON at.id_atendimento = p.id_atendimento
JOIN medicamentos m ON p.id_medicamento = m.id_medicamento
WHERE m.nome = 'Dipirona Sódica'
ORDER BY at.data_atendimento;
```
**Descrição:** Retorna o nome dos pacientes, ID e a data dos atendimentos em que houve prescrição de Dipirona Sódica. Os resultados são exibidos pela data do atendimento.  
**Requisitos:** JOIN (4 tabelas), ORDER BY

### Pergunta 7: Qual medicamento foi mais prescrito para cães da raça Labrador?
```sql
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
```
**Descrição:** Retorna apenas o medicamento com maior número de prescrições para Labradores, exibindo o nome e a quantidade de vezes em que foi indicado, mostrando o de maior ocorrência.  
**Requisitos:** JOIN (5 tabelas), COUNT, GROUP BY, ORDER BY, LIMIT

### Pergunta 8: Quais tutores têm mais de 3 pets cadastrados e quantos atendimentos cada um realizou?
```sql
SELECT c.nome AS tutor, COUNT(DISTINCT a.id_animal) AS total_pets, COUNT(at.id_atendimento) AS total_atendimentos
FROM clientes c
JOIN animais a ON c.id_cliente = a.id_cliente
JOIN atendimentos at ON a.id_animal = at.id_animal
GROUP BY c.id_cliente, c.nome
HAVING COUNT(DISTINCT a.id_animal) > 3
ORDER BY total_atendimentos DESC;
```
**Descrição:** Retorna tutores que possuem mais de três animais cadastrados, mostrando também quantos pets cada um tem e exibidos pelo total de atendimentos realizados.  
**Requisitos:** JOIN (3 tabelas), COUNT, GROUP BY, HAVING, ORDER BY

### Pergunta 9: Quais raças têm mais de 2 animais cadastrados e qual é o peso total desses animais?
```sql
SELECT r.nome AS raca, COUNT(a.id_animal) AS total_animais, SUM(a.peso) AS peso_total
FROM racas r
JOIN animais a ON r.id_raca = a.id_raca
GROUP BY r.id_raca, r.nome
HAVING COUNT(a.id_animal) > 2
ORDER BY total_animais DESC;
```
**Descrição:** Retorna cada raça que possui mais de dois animais cadastrados, indicando tanto a quantidade de registros quanto a soma dos pesos desses animais, em ordem decrescente.  
**Requisitos:** JOIN (2 tabelas), COUNT, SUM, GROUP BY, HAVING, ORDER BY


