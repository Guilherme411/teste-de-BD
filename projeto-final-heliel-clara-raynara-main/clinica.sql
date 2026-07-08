-- ============================
-- Criação do Banco
-- ============================
Create DATABASE if not exists dbclinica_vet;

-- ============================
-- Criação das Tabelas
-- ============================
-- TABELA: Especies
CREATE TABLE dbclinica_vet.especies (
id_especie INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(50) NOT NULL UNIQUE
);
-- TABELA: Racas
CREATE TABLE dbclinica_vet.racas (
id_raca INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(60) NOT NULL,
id_especie INT NOT NULL,
FOREIGN KEY (id_especie) REFERENCES especies(id_especie)
);
-- TABELA: Clientes (Tutores)
CREATE TABLE dbclinica_vet.clientes (
id_cliente INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
cpf CHAR(11) NOT NULL UNIQUE,
telefone VARCHAR(20),
endereco VARCHAR(150)
);
-- TABELA: Animais (Pacientes)
CREATE TABLE dbclinica_vet.animais (
id_animal INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(50) NOT NULL,
data_nascimento DATE,
sexo CHAR(1),
peso DECIMAL(5,2),
id_cliente INT NOT NULL,
id_raca INT NOT NULL,
FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
FOREIGN KEY (id_raca) REFERENCES racas(id_raca)
);
-- TABELA: Veterinarios
CREATE TABLE dbclinica_vet.veterinarios (
id_veterinario INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
crmv VARCHAR(20) NOT NULL UNIQUE,
especialidade VARCHAR(60)
);
-- TABELA: Atendimentos
CREATE TABLE dbclinica_vet.atendimentos (
id_atendimento INT AUTO_INCREMENT PRIMARY KEY,
data_atendimento DATE NOT NULL,
hora_atendimento TIME NOT NULL,
motivo VARCHAR(150),
peso_dia DECIMAL(5,2),
id_animal INT NOT NULL,
id_veterinario INT NOT NULL,
FOREIGN KEY (id_animal) REFERENCES animais(id_animal),
FOREIGN KEY (id_veterinario) REFERENCES veterinarios(id_veterinario)
);
-- TABELA: Servicos
CREATE TABLE dbclinica_vet.servicos (
id_servico INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
preco DECIMAL(8,2) NOT NULL
);
-- TABELA: Medicamentos
CREATE TABLE dbclinica_vet.medicamentos (
id_medicamento INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
descricao VARCHAR(150)
);
-- TABELA: Prescricoes (N:M)
CREATE TABLE dbclinica_vet.prescricoes (
id_atendimento INT NOT NULL,
id_medicamento INT NOT NULL,
instrucoes_uso VARCHAR(200),
PRIMARY KEY (id_atendimento, id_medicamento),
FOREIGN KEY (id_atendimento) REFERENCES atendimentos(id_atendimento),
FOREIGN KEY (id_medicamento) REFERENCES medicamentos(id_medicamento)
);
CREATE TABLE dbclinica_vet.atendimento_servicos (
id_atendimento INT NOT NULL,
id_servico INT NOT NULL,
quantidade INT DEFAULT 1,
valor_unitario DECIMAL(8,2) NOT NULL,
PRIMARY KEY (id_atendimento, id_servico),
FOREIGN KEY (id_atendimento) REFERENCES atendimentos(id_atendimento),
FOREIGN KEY (id_servico) REFERENCES servicos(id_servico)
);

-- ============================
-- Inserindo dados na Clínica Veterinária
-- ============================
INSERT INTO dbclinica_vet.especies (nome) VALUES 
('Canina'),
('Felina'),
('Ave'),
('Roedor'),
('Réptil'),
('Peixe'),
('Outro');

INSERT INTO dbclinica_vet.veterinarios (nome, crmv, especialidade) VALUES 
('Dr. Roberto Mendes', 'SP-12345', 'Clínica Geral'),
('Dra. Fernanda Oliveira', 'SP-67890', 'Cirurgia'),
('Dr. Lucas Silva', 'SP-11223', 'Dermatologia'),
('Dra. Amanda Souza', 'SP-44556', 'Exóticos');

INSERT INTO dbclinica_vet.servicos (nome, preco) VALUES 
('Consulta Clínica', 150.00),
('Vacina V10', 85.00),
('Vacina Antirrábica', 60.00),
('Castração (Cão P)', 450.00),
('Castração (Gato)', 350.00),
('Exame de Sangue (Hemograma)', 70.00),
('Limpeza de Tártaro', 250.00);

INSERT INTO dbclinica_vet.medicamentos (nome, descricao) VALUES 
('Apoquel 5.4mg', 'Antipruriginoso para dermatite'),
('Simparic 20mg', 'Antipulgas e carrapatos'),
('Enrofloxacina 50mg', 'Antibiótico de amplo espectro'),
('Meloxicam 2mg', 'Anti-inflamatório não esteroide'),
('Dipirona Sódica', 'Analgésico e antitérmico'),
('Vermífugo Drontal', 'Combate vermes intestinais');

INSERT INTO dbclinica_vet.clientes (nome, cpf, telefone, endereco) VALUES 
('Mariana Costa', '12345678901', '(11) 98765-4321', 'Rua das Flores, 123 - Centro'),
('João Pedro Alves', '23456789012', '(11) 91234-5678', 'Av. Paulista, 1000 - Bela Vista'),
('Beatriz Lima', '34567890123', '(11) 99888-7777', 'Rua do Bosque, 45 - Jardins'),
('Carlos Pereira', '45678901234', '(11) 95555-4444', 'Alameda Santos, 500 - Cerqueira César');

INSERT INTO dbclinica_vet.racas (nome, id_especie) VALUES 
('Golden Retriever', 1),
('SRD (Vira-lata)', 1),
('Bulldog Francês', 1),
('Siamês', 2),
('Persa', 2),
('Maine Coon', 2),
('Calopsita', 3),
('Hamster Sírio', 4),
('Labrador', 1),
('Pastor Alemão', 1),
('Shih Tzu', 1),
('Angorá', 2),
('Papagaio', 3),
('Porquinho-da-Índia', 4),
('Iguana', 5),
('Betta', 6),
('Outro', 7);

INSERT INTO dbclinica_vet.animais (nome, data_nascimento, sexo, peso, id_cliente, id_raca) VALUES 
('Thor', '2020-05-10', 'M', 32.50, 1, 1),
('Mel', '2019-08-15', 'F', 12.00, 2, 2),
('Luna', '2021-01-20', 'F', 4.50, 2, 4),
('Paçoca', '2022-03-10', 'M', 0.09, 3, 7),
('Simba', '2018-11-05', 'M', 6.00, 4, 5),
('Bob', '2022-07-12', 'M', 25.00, 1, 9),
('Nina', '2021-03-05', 'F', 18.00, 2, 10),
('Toby', '2020-11-22', 'M', 6.50, 3, 9),
('Mimi', '2019-09-10', 'F', 4.00, 1, 12),
('Kiko', '2020-01-15', 'M', 0.80, 2, 9),
('Pingo', '2021-06-01', 'M', 1.20, 3, 14);

INSERT INTO dbclinica_vet.atendimentos (data_atendimento, hora_atendimento, motivo, peso_dia, id_animal, id_veterinario) VALUES 
('2023-10-01', '09:00:00', 'Vacinação anual', 32.50, 1, 1),
('2023-10-02', '14:30:00', 'Coceira intensa e vermelhidão', 12.20, 2, 3),
('2023-10-03', '10:00:00', 'Castração eletiva', 4.50, 3, 2),
('2023-10-05', '16:00:00', 'Aparecimento de penas falhadas', 0.09, 4, 4),
('2023-11-01', '10:00:00', 'Consulta de rotina', 25.00, 6, 1),
('2023-11-02', '11:30:00', 'Vacinação anual', 18.20, 7, 2),
('2023-11-03', '15:00:00', 'Exame odontológico', 6.40, 8, 3),
('2023-11-04', '09:45:00', 'Check-up geral', 4.10, 9, 2),
('2023-11-05', '14:20:00', 'Problema respiratório', 0.85, 10, 4);

INSERT INTO dbclinica_vet.prescricoes (id_atendimento, id_medicamento, instrucoes_uso) VALUES 
(1, 1, '1 comprimido a cada 24h por 7 dias'),
(2, 3, '1 comprimido a cada 12h por 5 dias'),
(3, 4, '0.5ml via oral a cada 24h por 3 dias'),
(3, 5, '0.5ml se houver dor'),
(5, 2, '1 comprimido mensal'),
(6, 3, '1 comprimido a cada 12h por 10 dias'),
(7, 5, '10 gotas se houver febre'),
(8, 4, '0.3ml via oral a cada 24h por 5 dias'),
(9, 6, '1 comprimido a cada 15 dias');

INSERT INTO dbclinica_vet.atendimento_servicos (id_atendimento, id_servico, quantidade, valor_unitario) VALUES 
(1, 1, 1, 150.00),
(1, 2, 1, 85.00),
(2, 1, 1, 150.00),
(2, 6, 1, 70.00),
(3, 5, 1, 350.00),
(3, 1, 1, 0.00),
(4, 1, 1, 150.00),
(5, 1, 1, 150.00),
(6, 2, 1, 85.00),
(7, 7, 1, 250.00),
(8, 6, 1, 70.00),
(9, 1, 1, 150.00);