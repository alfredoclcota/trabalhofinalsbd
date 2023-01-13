DROP SCHEMA IF EXISTS imobiliaria CASCADE;
CREATE SCHEMA imobiliaria;
SET search_path TO imobiliaria;

-- CRIANDO TABELAS --

CREATE TABLE imovel(
	cod_id_imovel INT,
	CONSTRAINT pk_id_imovel PRIMARY KEY (cod_id_imovel),
	status_locacao VARCHAR(12) DEFAULT('DISPONÍVEL'),
	data_abertura_locacao DATE,
	status_venda VARCHAR(12) DEFAULT('DISPONÍVEL'),
	data_abertura_venda DATE,
	data_construcao DATE, 
	tipo_imovel VARCHAR(15)
);

CREATE TABLE fotos (
	id_foto INT,
	CONSTRAINT pk_id_foto PRIMARY KEY (id_foto),
	nome_arquivo VARCHAR(255),
	cod_id_imovel INT,
	CONSTRAINT fk_foto_imovel FOREIGN KEY (cod_id_imovel) REFERENCES imovel(cod_id_imovel)
);

CREATE TABLE endereco(
	id_endereco INT,
	CONSTRAINT pk_enderco PRIMARY KEY (id_endereco),
	logradouro VARCHAR(15),
	nome VARCHAR (30),
	bairro VARCHAR(30) NOT NULL,
	numero VARCHAR(15),
	CEP CHAR(8)	
);

CREATE TABLE terreno(
	cod_id_t INT, 
	CONSTRAINT pk_id_t PRIMARY KEY (cod_id_t),
	CONSTRAINT fk_cod_id_t FOREIGN KEY (cod_id_t) REFERENCES imovel(cod_id_imovel),
	area REAL,
	largura REAL,
	comprimento REAL,
	possui_aclive_declive VARCHAR(3) DEFAULT('NÃO'),
	id_endereco INT,
	CONSTRAINT fk_endereco_terreno FOREIGN KEY (id_endereco) REFERENCES endereco(id_endereco)
);

CREATE TABLE sala_comercial(
	cod_id_sc INT, 
	CONSTRAINT pk_id_sc PRIMARY KEY (cod_id_sc),
	CONSTRAINT fk_cod_id_sc FOREIGN KEY (cod_id_sc) REFERENCES imovel(cod_id_imovel),
	area REAL,
	n_banheiros INT,
	n_comodos INT,
	id_endereco INT,
	CONSTRAINT fk_endereco_sala_comercial FOREIGN KEY (id_endereco) REFERENCES endereco(id_endereco)
);

CREATE TABLE casa(
	cod_id_c INT, 
	CONSTRAINT pk_id_c PRIMARY KEY (cod_id_c),
	CONSTRAINT fk_cod_id_c FOREIGN KEY (cod_id_c) REFERENCES imovel(cod_id_imovel),
	area REAL,
	n_quartos INT,
	n_suites INT,
	n_sala_de_estar INT,
	n_sala_de_jantar INT,
	n_vagas_garagem INT,
	possui_armario CHAR(3) DEFAULT('SIM'),
	detalhes VARCHAR(255),
	id_endereco INT,
	CONSTRAINT fk_endereco_casa FOREIGN KEY (id_endereco) REFERENCES endereco(id_endereco)
);

CREATE TABLE apartamento(
	cod_id_ap INT, 
	CONSTRAINT pk_id_ap PRIMARY KEY (cod_id_ap),
	CONSTRAINT fk_cod_id_ap FOREIGN KEY (cod_id_ap) REFERENCES imovel(cod_id_imovel),
	area REAL,
	n_quartos INT,
	n_suites INT,
	n_sala_de_estar INT,
	n_sala_de_jantar INT,
	n_vagas_garagem INT,
	possui_armario CHAR(3) DEFAULT('SIM'),
	detalhes VARCHAR(255),
	andar INT,
	valor_condominio REAL,
	possui_portaria_24hrs CHAR(3) DEFAULT ('SIM'),
	id_endereco INT,
	CONSTRAINT fk_endereco_apartamento FOREIGN KEY (id_endereco) REFERENCES endereco(id_endereco)
);

CREATE TABLE reforma (
	id_reforma INT,
	CONSTRAINT pk_reforma PRIMARY KEY (id_reforma),
	valor_total REAL,
	n_operarios INT,
	cod_id_imovel INT,
	CONSTRAINT fk_cod_id_imovel FOREIGN KEY (cod_id_imovel) REFERENCES imovel(cod_id_imovel)
);

CREATE TABLE utensilios (
	id_uten INT,
	CONSTRAINT pk_uten PRIMARY KEY (id_uten),
	utensilio VARCHAR(30),
	id_reforma INT,
	CONSTRAINT fk_reforma FOREIGN KEY (id_reforma) REFERENCES reforma(id_reforma)
);

CREATE TABLE cliente_usuario (
	CPF CHAR(11),
	CONSTRAINT pk_cliente_usuario PRIMARY KEY (CPF),
	nome VARCHAR(255),
	sexo VARCHAR(10),
	email VARCHAR(30),
	estado_civil VARCHAR(15),
	endereco VARCHAR(50),
	profissao VARCHAR(20),
	cod_id_imovel INT,
	CONSTRAINT fk_cod_id_imovel FOREIGN KEY (cod_id_imovel) REFERENCES imovel(cod_id_imovel)
);

CREATE TABLE fiador(
	CPF CHAR(11),
	CONSTRAINT pk_fiador PRIMARY KEY (CPF),
	nome VARCHAR(255),
	cpf_cliente_usuario CHAR(11),
	CONSTRAINT fk_cpf_cliente_usuario FOREIGN KEY (cpf_cliente_usuario) REFERENCES cliente_usuario(CPF)
);

CREATE TABLE indicacao(
	CPF CHAR(11),
	CONSTRAINT pk_indicacao PRIMARY KEY (CPF),
	nome VARCHAR(255),
	cpf_cliente_usuario CHAR(11),
	CONSTRAINT fk_cpf_cliente_usuario FOREIGN KEY (cpf_cliente_usuario) REFERENCES cliente_usuario(CPF)
);

CREATE TABLE cliente_proprietario (
	CPF CHAR(11),
	CONSTRAINT pk_cliente_proprietario PRIMARY KEY (CPF),
	nome VARCHAR(255),
	sexo VARCHAR(10),
	email VARCHAR(30),
	estado_civil VARCHAR(15),
	endereco VARCHAR(50),
	profissao VARCHAR(20),
	cod_id_imovel INT,
	CONSTRAINT fk_cod_id_imovel FOREIGN KEY (cod_id_imovel) REFERENCES imovel(cod_id_imovel)
);

CREATE TABLE cargos(
	salario_base REAL,
	CONSTRAINT pk_cargos PRIMARY KEY (salario_base),
	nome VARCHAR(255)	
);

CREATE TABLE funcionario(
	CPF CHAR(11),
	CONSTRAINT pk_funcionario PRIMARY KEY (CPF),
	nome VARCHAR(255),
	sexo VARCHAR(10),
	endereco VARCHAR(50),
	data_ingresso DATE,
	comissao REAL,
	salario_base REAL, 
	CONSTRAINT fk_cargo FOREIGN KEY (salario_base) REFERENCES cargos(salario_base)	
);

CREATE TABLE login (
	CPF CHAR(11),
	CONSTRAINT pk_login PRIMARY KEY (CPF),
	CONSTRAINT fk_login FOREIGN KEY (CPF) REFERENCES funcionario(CPF),
	usuario CHAR(10),
	senha VARCHAR(255)
);

CREATE TABLE telefone_funcionario (
	id_telefone_funcionario INT,
	CONSTRAINT pk_telefone_funcionario PRIMARY KEY (id_telefone_funcionario),
	telefone VARCHAR(30),
	CPF CHAR(11),
	CONSTRAINT fk_telefone FOREIGN KEY (CPF) REFERENCES funcionario(CPF)
);

CREATE TABLE telefone_cliente_usuario (
	id_telefone_cliente_usuario INT,
	CONSTRAINT pk_telefone_cliente_usuario PRIMARY KEY (id_telefone_cliente_usuario),
	telefone VARCHAR(30),
	CPF CHAR(11),
	CONSTRAINT fk_telefone FOREIGN KEY (CPF) REFERENCES cliente_usuario(CPF)
);

CREATE TABLE telefone_cliente_proprietario (
	id_telefone_cliente_proprietario INT,
	CONSTRAINT pk_telefone_cliente_proprietario PRIMARY KEY (id_telefone_cliente_proprietario),
	telefone VARCHAR(30),
	CPF CHAR(11),
	CONSTRAINT fk_telefone FOREIGN KEY (CPF) REFERENCES cliente_proprietario(CPF)
);

CREATE TABLE registro(
	num_contrato VARCHAR(20),
	CONSTRAINT pk_registro PRIMARY KEY (num_contrato),
	pagamento VARCHAR(30) DEFAULT ('DINHEIRO'),
	data_transacao DATE,
	cod_id_imovel INT,
	CONSTRAINT fk_cod_id_imovel FOREIGN KEY (cod_id_imovel) REFERENCES imovel(cod_id_imovel),
	cpf_funcionario CHAR(11),
	CONSTRAINT fk_cpf_funcionario FOREIGN KEY (cpf_funcionario) REFERENCES funcionario(CPF),
	cpf_cliente_proprietario CHAR(11),
	CONSTRAINT fk_cpf_cliente_proprietario FOREIGN KEY (cpf_cliente_proprietario) REFERENCES cliente_proprietario(CPF),
	cpf_cliente_usuario CHAR(11),
	CONSTRAINT fk_cpf_cliente_usuario FOREIGN KEY (cpf_cliente_usuario) REFERENCES cliente_usuario(CPF)	
);

CREATE TABLE compra(
	id_compra INT,
	CONSTRAINT pk_compra PRIMARY KEY (id_compra),
	data_compra DATE NOT NULL,
	UNIQUE (data_compra),
	taxa_imobiliaria REAL, 
	valor REAL,
	cod_id_imovel INT,
	CONSTRAINT fk_cod_id_imovel FOREIGN KEY (cod_id_imovel) REFERENCES imovel(cod_id_imovel),
	cpf_funcionario CHAR(11),
	CONSTRAINT fk_cpf_funcionario FOREIGN KEY (cpf_funcionario) REFERENCES funcionario(CPF),
	cpf_cliente_proprietario CHAR(11),
	CONSTRAINT fk_cpf_cliente_proprietario FOREIGN KEY (cpf_cliente_proprietario) REFERENCES cliente_proprietario(CPF)
);

CREATE TABLE aluga(
	id_aluga INT,
	CONSTRAINT pk_aluga PRIMARY KEY (id_aluga),
	data_locacao DATE NOT NULL,
	UNIQUE (data_locacao),
	taxa_imobiliaria REAL, 
	taxa_incendio REAL, 
	valor REAL,
	cod_id_imovel INT,
	CONSTRAINT fk_cod_id_imovel FOREIGN KEY (cod_id_imovel) REFERENCES imovel(cod_id_imovel),
	cpf_funcionario CHAR(11),
	CONSTRAINT fk_cpf_funcionario FOREIGN KEY (cpf_funcionario) REFERENCES funcionario(CPF),
	cpf_cliente_usuario CHAR(11),
	CONSTRAINT fk_cpf_cliente_usuario FOREIGN KEY (cpf_cliente_usuario) REFERENCES cliente_usuario(CPF)
);

CREATE TABLE historico(
	id_historico INT,
	CONSTRAINT pk_historico PRIMARY KEY (id_historico),
	registro VARCHAR(20),
	CONSTRAINT fk_registro FOREIGN KEY (registro) REFERENCES registro(num_contrato),
	status_locacao VARCHAR(12) DEFAULT('DISPONÍVEL'),
	status_venda VARCHAR(12) DEFAULT('DISPONÍVEL'),
	cod_id_imovel INT,
	CONSTRAINT fk_cod_id_imovel FOREIGN KEY (cod_id_imovel) REFERENCES imovel(cod_id_imovel),
	data_compra DATE,
	CONSTRAINT fk_data_compra FOREIGN KEY (data_compra) REFERENCES compra(data_compra),
	data_locacao DATE,
	CONSTRAINT fk_data_locacao FOREIGN KEY (data_locacao) REFERENCES aluga(data_locacao)
	
);


--- INSERÇÃO DE DADOS --- 

--- TABELA IMOVEL ---

INSERT INTO imovel(cod_id_imovel, status_locacao, data_abertura_locacao, status_venda, data_abertura_venda, data_construcao, tipo_imovel)
	VALUES (1, 'DISPONÍVEL', '2022-09-25', 'INDISPONÍVEL', '2022-07-02', '2022-05-31', 'CASA');
INSERT INTO imovel(cod_id_imovel, status_locacao, data_abertura_locacao, status_venda, data_abertura_venda, data_construcao, tipo_imovel)
	VALUES (2, 'DISPONÍVEL', '2022-10-26', 'INDISPONÍVEL', '2022-08-05', '2022-05-07', 'CASA');
INSERT INTO imovel(cod_id_imovel, status_locacao, data_abertura_locacao, status_venda, data_abertura_venda, data_construcao, tipo_imovel)
	VALUES (3, 'INDISPONÍVEL', NULL, 'DISPONÍVEL', '2022-12-02', '2022-10-31', 'CASA');
INSERT INTO imovel(cod_id_imovel, status_locacao, data_abertura_locacao, status_venda, data_abertura_venda, data_construcao, tipo_imovel)
	VALUES (4, 'INDISPONÍVEL', '2023-01-03', 'INDISPONÍVEL', '2022-12-14', '2022-11-11', 'CASA');
INSERT INTO imovel(cod_id_imovel, status_locacao, data_abertura_locacao, status_venda, data_abertura_venda, data_construcao, tipo_imovel)
	VALUES (5, 'INDISPONÍVEL', '2022-11-25', 'INDISPONÍVEL', '2022-03-02', '2022-01-05', 'CASA');
	
INSERT INTO imovel(cod_id_imovel, status_locacao, data_abertura_locacao, status_venda, data_abertura_venda, data_construcao, tipo_imovel)
	VALUES (6, 'INDISPONÍVEL', NULL, 'DISPONÍVEL', '2022-03-02', '2021-12-13', 'TERRENO');
INSERT INTO imovel(cod_id_imovel, status_locacao, data_abertura_locacao, status_venda, data_abertura_venda, data_construcao, tipo_imovel)
	VALUES (7, 'INDISPONÍVEL', NULL, 'DISPONÍVEL', '2022-04-28', '2021-12-13', 'TERRENO');
INSERT INTO imovel(cod_id_imovel, status_locacao, data_abertura_locacao, status_venda, data_abertura_venda, data_construcao, tipo_imovel)
	VALUES (8, 'INDISPONÍVEL', NULL, 'DISPONÍVEL', '2022-09-07', '2021-12-13', 'TERRENO');
INSERT INTO imovel(cod_id_imovel, status_locacao, data_abertura_locacao, status_venda, data_abertura_venda, data_construcao, tipo_imovel)
	VALUES (9, 'DISPONÍVEL', '2022-09-24', 'INDISPONÍVEL', '2022-08-02', '2021-12-14', 'TERRENO');
INSERT INTO imovel(cod_id_imovel, status_locacao, data_abertura_locacao, status_venda, data_abertura_venda, data_construcao, tipo_imovel)
	VALUES (10, 'INDISPONÍVEL', NULL, 'DISPONÍVEL', '2022-11-13', '2020-09-13', 'TERRENO');
	
INSERT INTO imovel(cod_id_imovel, status_locacao, data_abertura_locacao, status_venda, data_abertura_venda, data_construcao, tipo_imovel)
	VALUES (11, 'INDISPONÍVEL', NULL, 'INDISPONÍVEL', NULL, '2023-05-01', 'SALA COMERCIAL');
INSERT INTO imovel(cod_id_imovel, status_locacao, data_abertura_locacao, status_venda, data_abertura_venda, data_construcao, tipo_imovel)
	VALUES (12, 'INDISPONÍVEL', NULL, 'DISPONÍVEL', '2021-01-03', '2020-03-12', 'SALA COMERCIAL');
INSERT INTO imovel(cod_id_imovel, status_locacao, data_abertura_locacao, status_venda, data_abertura_venda, data_construcao, tipo_imovel)
	VALUES (13, 'INDISPONÍVEL', '2022-03-21', 'INDISPONÍVEL', '2022-02-01', '2021-11-05', 'SALA COMERCIAL');
INSERT INTO imovel(cod_id_imovel, status_locacao, data_abertura_locacao, status_venda, data_abertura_venda, data_construcao, tipo_imovel)
	VALUES (14, 'DISPONÍVEL', '2022-05-15', 'INDISPONÍVEL', '2022-03-03', '2021-09-07', 'SALA COMERCIAL');
INSERT INTO imovel(cod_id_imovel, status_locacao, data_abertura_locacao, status_venda, data_abertura_venda, data_construcao, tipo_imovel)
	VALUES (15, 'INDISPONÍVEL', NULL, 'DISPONÍVEL', '2022-01-30', '2021-06-28', 'SALA COMERCIAL');
	
INSERT INTO imovel(cod_id_imovel, status_locacao, data_abertura_locacao, status_venda, data_abertura_venda, data_construcao, tipo_imovel)
	VALUES (16, 'INDISPONÍVEL', NULL, 'DISPONÍVEL', '2022-10-20', '2022-05-05', 'APARTAMENTO');
INSERT INTO imovel(cod_id_imovel, status_locacao, data_abertura_locacao, status_venda, data_abertura_venda, data_construcao, tipo_imovel)
	VALUES (17, 'INDISPONÍVEL', NULL, 'DISPONÍVEL', '2022-11-05', '2022-05-05', 'APARTAMENTO');
INSERT INTO imovel(cod_id_imovel, status_locacao, data_abertura_locacao, status_venda, data_abertura_venda, data_construcao, tipo_imovel)
	VALUES (18, 'INDISPONÍVEL', NULL, 'DISPONÍVEL', '2022-01-20', '2021-12-01', 'APARTAMENTO');
INSERT INTO imovel(cod_id_imovel, status_locacao, data_abertura_locacao, status_venda, data_abertura_venda, data_construcao, tipo_imovel)
	VALUES (19, 'INDISPONÍVEL', '2022-07-08', 'INDISPONÍVEL', '2022-04-20', '2022-02-06', 'APARTAMENTO');
INSERT INTO imovel(cod_id_imovel, status_locacao, data_abertura_locacao, status_venda, data_abertura_venda, data_construcao, tipo_imovel)
	VALUES (20, 'INDISPONÍVEL', '2022-12-21', 'INDISPONÍVEL', '2022-09-13', '2022-08-12', 'APARTAMENTO');

--- TABELA FOTOS ---

INSERT INTO fotos(id_foto, nome_arquivo, cod_id_imovel) VALUES (1, 'Casa, Santa Mônica', 3);
INSERT INTO fotos(id_foto, nome_arquivo, cod_id_imovel) VALUES (2, 'Terreno, Santa Mônica', 6);
INSERT INTO fotos(id_foto, nome_arquivo, cod_id_imovel) VALUES (3, 'Sala Comercial, Santa Mônica', 12);
INSERT INTO fotos(id_foto, nome_arquivo, cod_id_imovel) VALUES (4, 'Apartamento, Santa Mônica', 19);
INSERT INTO fotos(id_foto, nome_arquivo, cod_id_imovel) VALUES (5, 'Casa, Umuarama', 4);

--- TABELA ENDEREÇO ---
	
INSERT INTO endereco(id_endereco, logradouro, nome, bairro, numero, CEP) VALUES(1, 'RUA', 'MARIA DAS DORES DIAS', 'SANTA MONICA', 900, 38408206);
INSERT INTO endereco(id_endereco, logradouro, nome, bairro, numero, CEP) VALUES(2, 'AVENIDA', 'MIGUEL ROCHA DOS SANTOS', 'SANTA MONICA', 275, 38408190);
INSERT INTO endereco(id_endereco, logradouro, nome, bairro, numero, CEP) VALUES(3, 'RUA', 'HILDEBRANDO OLIVA', 'SANTA MONICA', 1071, 38408212);
INSERT INTO endereco(id_endereco, logradouro, nome, bairro, numero, CEP) VALUES(4, 'AVENIDA', 'ANA GODOY DE SOUSA', 'SANTA MONICA', 799, 38408290);
INSERT INTO endereco(id_endereco, logradouro, nome, bairro, numero, CEP) VALUES(5, 'RUA', 'BELARMINO COTTA PACHECO', 'SANTA MONICA', 730, 38408168);
INSERT INTO endereco(id_endereco, logradouro, nome, bairro, numero, CEP) VALUES(6, 'RUA', 'SALVADOR', 'NOSSA SENHORA APARECIDA', 1262, 38400757);
INSERT INTO endereco(id_endereco, logradouro, nome, bairro, numero, CEP) VALUES(7, 'RUA', 'MACHADO DE ASSIS', 'CENTRO', 121, 38400112);
INSERT INTO endereco(id_endereco, logradouro, nome, bairro, numero, CEP) VALUES(8, 'RUA', 'VASCONCELOS COSTA', 'OSVALDO REZENDE', 1646, 38400450);
INSERT INTO endereco(id_endereco, logradouro, nome, bairro, numero, CEP) VALUES(9, 'RUA', 'EURITA', 'DONA ZULMIRA', 14, 38414014);
INSERT INTO endereco(id_endereco, logradouro, nome, bairro, numero, CEP) VALUES(10, 'RUA', 'RIO MISSISSIPI', 'JARDIM EUROPA', 1380, 38414710);
INSERT INTO endereco(id_endereco, logradouro, nome, bairro, numero, CEP) VALUES(11, 'RUA', 'LICYDIO PAES', 'SANTA MONICA', 903, 38408254);
INSERT INTO endereco(id_endereco, logradouro, nome, bairro, numero, CEP) VALUES(12, 'RUA', 'OLIVEIRA LIMA', 'PAMPULHA', 459, 38408650);
INSERT INTO endereco(id_endereco, logradouro, nome, bairro, numero, CEP) VALUES(13, 'RUA', 'LUCAS GRCEZ', 'GRANADA', 155, 38410560);
INSERT INTO endereco(id_endereco, logradouro, nome, bairro, numero, CEP) VALUES(14, 'RUA', 'LOURDES DE CARVALHO', 'SEGISMUNDO PEREIRA', 885, 38408268);
INSERT INTO endereco(id_endereco, logradouro, nome, bairro, numero, CEP) VALUES(15, 'AVENIDA', 'FRANSCISCO RIBEIRO', 'SANTA MONICA', 111, 38408186);
INSERT INTO endereco(id_endereco, logradouro, nome, bairro, numero, CEP) VALUES(16, 'AVENIDA', 'BELARMINO COTTA PACHECO', 'SANTA MONICA', 1260, 38408168);
INSERT INTO endereco(id_endereco, logradouro, nome, bairro, numero, CEP) VALUES(17, 'AVENIDA', 'ORTIZIO BORGES', 'SANTA MONICA', 1255, 38408164);
INSERT INTO endereco(id_endereco, logradouro, nome, bairro, numero, CEP) VALUES(18, 'AVENIDA', 'SEGISMUNDO PEREIRA', 'SANTA MONICA', 1836, 38408170);
INSERT INTO endereco(id_endereco, logradouro, nome, bairro, numero, CEP) VALUES(19, 'RUA', 'ANTONIO SALVIANO DE REZENDE', 'SANTA MONICA', 639, 38408228);
INSERT INTO endereco(id_endereco, logradouro, nome, bairro, numero, CEP) VALUES(20, 'RUA', 'PROFA. MARIA ALVES CASTILHO', 'SANTA MONICA', 1480, 38408260);

--- TABELA CASA ---

INSERT INTO casa(cod_id_c, area, n_quartos, n_suites, n_sala_de_estar, n_sala_de_jantar, n_vagas_garagem, possui_armario, detalhes, id_endereco)
	VALUES (1, 120, 2, 1, 1, 0, 0, 'SIM', NULL, 1);
INSERT INTO casa(cod_id_c, area, n_quartos, n_suites, n_sala_de_estar, n_sala_de_jantar, n_vagas_garagem, possui_armario, detalhes, id_endereco)
	VALUES (2, 205, 2, 1, 1, 0, 1, 'SIM', NULL, 2);
INSERT INTO casa(cod_id_c, area, n_quartos, n_suites, n_sala_de_estar, n_sala_de_jantar, n_vagas_garagem, possui_armario, detalhes, id_endereco)
	VALUES (3, 300, 3, 1, 1, 0, 1, 'SIM', NULL, 3);
INSERT INTO casa(cod_id_c, area, n_quartos, n_suites, n_sala_de_estar, n_sala_de_jantar, n_vagas_garagem, possui_armario, detalhes, id_endereco)
	VALUES (4, 240, 2, 1, 1, 1, 1, 'NÃO', NULL, 4);
INSERT INTO casa(cod_id_c, area, n_quartos, n_suites, n_sala_de_estar, n_sala_de_jantar, n_vagas_garagem, possui_armario, detalhes, id_endereco)
	VALUES (5, 250, 2, 1, 1, 0, 1, 'SIM', NULL, 5);

--- TABELA TERRENO ---

INSERT INTO terreno(cod_id_t, area, largura, comprimento, possui_aclive_declive, id_endereco)
	VALUES(6, 300, 10, 30, 'SIM', 6);
INSERT INTO terreno(cod_id_t, area, largura, comprimento, possui_aclive_declive, id_endereco)
	VALUES(7, 429, 13, 33, 'SIM', 7);
INSERT INTO terreno(cod_id_t, area, largura, comprimento, possui_aclive_declive, id_endereco)
	VALUES(8, 600, 20, 30, 'NAO', 8);
INSERT INTO terreno(cod_id_t, area, largura, comprimento, possui_aclive_declive, id_endereco)
	VALUES(9, 1250, 50, 25, 'NAO', 9);
INSERT INTO terreno(cod_id_t, area, largura, comprimento, possui_aclive_declive, id_endereco)
	VALUES(10, 385, 11, 35, 'SIM', 10);

--- TABELA SALA COMERCIAL ---

INSERT INTO sala_comercial(cod_id_sc, area, n_banheiros, n_comodos, id_endereco)
	VALUES(11, 350, 3, 3, 11);
INSERT INTO sala_comercial(cod_id_sc, area, n_banheiros, n_comodos, id_endereco)
	VALUES(12, 390, 3, 3, 12);
INSERT INTO sala_comercial(cod_id_sc, area, n_banheiros, n_comodos, id_endereco)
	VALUES(13, 400, 4, 2, 13);
INSERT INTO sala_comercial(cod_id_sc, area, n_banheiros, n_comodos, id_endereco)
	VALUES(14, 420, 3, 4, 14);
INSERT INTO sala_comercial(cod_id_sc, area, n_banheiros, n_comodos, id_endereco)
	VALUES(15, 430, 4, 4, 15);
	
--- TABELA APARTAMENTO ---

INSERT INTO apartamento(cod_id_ap, area, n_quartos, n_suites, n_sala_de_estar, n_sala_de_jantar, n_vagas_garagem, possui_armario, detalhes, andar, valor_condominio, possui_portaria_24hrs, id_endereco)
	VALUES (16, 120, 2, 1, 1, 0, 1, 'SIM', NULL, 1, 125.77, 'NÃO', 16);
INSERT INTO apartamento(cod_id_ap, area, n_quartos, n_suites, n_sala_de_estar, n_sala_de_jantar, n_vagas_garagem, possui_armario, detalhes, andar, valor_condominio, possui_portaria_24hrs, id_endereco)
	VALUES (17, 87, 2, 1, 1, 0, 1, 'SIM', NULL, 1, 150.55, 'NÃO', 17);
INSERT INTO apartamento(cod_id_ap, area, n_quartos, n_suites, n_sala_de_estar, n_sala_de_jantar, n_vagas_garagem, possui_armario, detalhes, andar, valor_condominio, possui_portaria_24hrs, id_endereco)
	VALUES (18, 137, 2, 1, 1, 0, 2, 'SIM', NULL, 1, 300.00, 'SIM', 18);
INSERT INTO apartamento(cod_id_ap, area, n_quartos, n_suites, n_sala_de_estar, n_sala_de_jantar, n_vagas_garagem, possui_armario, detalhes, andar, valor_condominio, possui_portaria_24hrs, id_endereco)
	VALUES (19, 140, 3, 1, 1, 0, 1, 'NÃO', NULL, 1, 170.50, 'NÃO', 19);
INSERT INTO apartamento(cod_id_ap, area, n_quartos, n_suites, n_sala_de_estar, n_sala_de_jantar, n_vagas_garagem, possui_armario, detalhes, andar, valor_condominio, possui_portaria_24hrs, id_endereco)
	VALUES (20, 105, 2, 1, 1, 0, 1, 'NÃO', NULL, 1, 110.00, 'NÃO', 20);

--- TABELA REFORMA ---

INSERT INTO reforma(id_reforma, valor_total, n_operarios, cod_id_imovel)
	VALUES(1, 1205.33, 3, 17);
INSERT INTO reforma(id_reforma, valor_total, n_operarios, cod_id_imovel)
	VALUES(2, 2050.30, 5, 2);
INSERT INTO reforma(id_reforma, valor_total, n_operarios, cod_id_imovel)
	VALUES(3, 3000.00, 3, 19);
INSERT INTO reforma(id_reforma, valor_total, n_operarios, cod_id_imovel)
	VALUES(4, 1150.60, 2, 12);
INSERT INTO reforma(id_reforma, valor_total, n_operarios, cod_id_imovel)
	VALUES(5, 500.50, 1, 20);

--- TABELA UTENSILIOS ---

INSERT INTO utensilios(id_uten, utensilio, id_reforma)
	VALUES(1, 'tinta', 1);
INSERT INTO utensilios(id_uten, utensilio, id_reforma)
	VALUES(2, 'tinta', 2);
INSERT INTO utensilios(id_uten, utensilio, id_reforma)
	VALUES(3, 'tinta', 3);
INSERT INTO utensilios(id_uten, utensilio, id_reforma)
	VALUES(4, 'tinta', 4);
INSERT INTO utensilios(id_uten, utensilio, id_reforma)
	VALUES(5, 'tinta', 5);
INSERT INTO utensilios(id_uten, utensilio, id_reforma)
	VALUES(6, 'martelo', 1);
INSERT INTO utensilios(id_uten, utensilio, id_reforma)
	VALUES(7, 'chave de fenda', 2);
INSERT INTO utensilios(id_uten, utensilio, id_reforma)
	VALUES(8, 'furadeira', 3);
INSERT INTO utensilios(id_uten, utensilio, id_reforma)
	VALUES(9, 'martelo', 4);
INSERT INTO utensilios(id_uten, utensilio, id_reforma)
	VALUES(10, 'chave allen', 5);
INSERT INTO utensilios(id_uten, utensilio, id_reforma)
	VALUES(11, 'parafusos', 1);
INSERT INTO utensilios(id_uten, utensilio, id_reforma)
	VALUES(12, 'parafusos', 2);
INSERT INTO utensilios(id_uten, utensilio, id_reforma)
	VALUES(13, 'arruela', 2);
INSERT INTO utensilios(id_uten, utensilio, id_reforma)
	VALUES(14, 'alicate', 3);
INSERT INTO utensilios(id_uten, utensilio, id_reforma)
	VALUES(15, 'fita métrica', 3);
INSERT INTO utensilios(id_uten, utensilio, id_reforma)
	VALUES(16, 'chave de fenda', 3);
INSERT INTO utensilios(id_uten, utensilio, id_reforma)
	VALUES(17, 'chave estrela', 4);
INSERT INTO utensilios(id_uten, utensilio, id_reforma)
	VALUES(18, 'pincel', 4);
INSERT INTO utensilios(id_uten, utensilio, id_reforma)
	VALUES(19, 'fita métrica', 4);
INSERT INTO utensilios(id_uten, utensilio, id_reforma)
	VALUES(20, 'pincel', 5);
	
	
--- TABELA CLIENTE USUÁRIO ---

INSERT INTO cliente_usuario(cpf, nome, sexo, email, estado_civil, endereco, profissao, cod_id_imovel)
	VALUES('11111009988', 'MARCOS HENRIQUE CAMARGO', 'MASCULINO', 'marcoshenrique@gmail.com', 'SOLTEIRO', 'RUA JOÃO PESSOA, 255, PENTECOSTAL - PE', 'CONTADOR', 19);
INSERT INTO cliente_usuario(cpf, nome, sexo, email, estado_civil, endereco, profissao, cod_id_imovel)
	VALUES('22233300011', 'MILENA JOSELIDA ALMEIDA', 'FEMININO', 'milenajalmeida@gmail.com', 'SOLTEIRA', 'RUA FENOMENAL SANTOS, 111, ÁGORA - MG', 'ESTUDANTE', 20);
INSERT INTO cliente_usuario(cpf, nome, sexo, email, estado_civil, endereco, profissao, cod_id_imovel)
	VALUES('25265633322', 'ÁGATA MELANI PEREIRA', 'FEMININO', 'agatapereira@gmail.com', 'CASADA', 'AVENIDA NATAL, 977, GOIANINHA - RJ', 'ENGENHEIRA', 4);
INSERT INTO cliente_usuario(cpf, nome, sexo, email, estado_civil, endereco, profissao, cod_id_imovel)
	VALUES('88899956544', 'JOÃO VITOR TUBOLINI', 'MASCULINO', 'jvtubolini@gmail.com', 'CASADO', 'AVENIDA FREI INOCENCIO, 780, PETRA - PI', 'ENFERMEIR0', 5);
INSERT INTO cliente_usuario(cpf, nome, sexo, email, estado_civil, endereco, profissao, cod_id_imovel)
	VALUES('33385214775', 'GEORGE GONÇALVES DIAS', 'MASCULINO', 'ggdias@gmail.com', 'SOLTEIRO', 'RUA PADRE INACIO, 45, PINHEIROS - AM', 'ADMINISTRADOR', 13);

--- TABELA FIADOR ---

INSERT INTO fiador(cpf, nome, cpf_cliente_usuario)
	VALUES('11158588899', 'MAGDA MELATO', '11111009988');
INSERT INTO fiador(cpf, nome, cpf_cliente_usuario)
	VALUES('56644666899', 'TATIANA ALMEIDA SILVA', '22233300011');
INSERT INTO fiador(cpf, nome, cpf_cliente_usuario)
	VALUES('88859566622', 'SOL CAMARGO PEREIRA', '25265633322');
INSERT INTO fiador(cpf, nome, cpf_cliente_usuario)
	VALUES('11100078769', 'PEDRO PIETRO PEDRA', '88899956544');
INSERT INTO fiador(cpf, nome, cpf_cliente_usuario)
	VALUES('22258965433', 'FIGUEIREDO MAGALHÃES DIAS', '33385214775');
	
--- TABELA INDICAÇÃO ---

INSERT INTO indicacao(cpf, nome, cpf_cliente_usuario)
	VALUES('10158687866', 'REGINALDO MELATO', '11111009988');
INSERT INTO indicacao(cpf, nome, cpf_cliente_usuario)
	VALUES('21144599899', 'SILVA MELATO', '11111009988');
INSERT INTO indicacao(cpf, nome, cpf_cliente_usuario)
	VALUES('33645586888', 'TIANA ALMEIDA SILVA', '22233300011');
INSERT INTO indicacao(cpf, nome, cpf_cliente_usuario)
	VALUES('57743367855', 'TALITA ALMEIDA SILVA', '22233300011');
INSERT INTO indicacao(cpf, nome, cpf_cliente_usuario)
	VALUES('99999567612', 'ADAILTON CAMARGO PEREIRA', '25265633322');
INSERT INTO indicacao(cpf, nome, cpf_cliente_usuario)
	VALUES('55566533621', 'AVELINO CAMARGO PEREIRA', '25265633322');
INSERT INTO indicacao(cpf, nome, cpf_cliente_usuario)
	VALUES('13304499778', 'PATRICIA PIETRO PEDRA', '88899956544');
INSERT INTO indicacao(cpf, nome, cpf_cliente_usuario)
	VALUES('33305988869', 'PIRES PIETRO PEDRA', '88899956544');
INSERT INTO indicacao(cpf, nome, cpf_cliente_usuario)
	VALUES('15633365433', 'MATILDE MAGALHÃES DIAS', '33385214775');
INSERT INTO indicacao(cpf, nome, cpf_cliente_usuario)
	VALUES('98711135645', 'GABRIELA MAGALHÃES DIAS', '33385214775');
	
--- TABELA CLIENTE PROPRIETÁRIO ---

INSERT INTO cliente_proprietario(cpf, nome, sexo, email, estado_civil, endereco, profissao, cod_id_imovel)
	VALUES('64346900372', 'Vinicius Souza Carvalho', 'MASCULINO', 'viniciusSouza@armyspy.com', 'CASADO', 'RUA SARAMAGO, 717, LIMOEIRO - MT', 'ECONOMISTA', 1);
INSERT INTO cliente_proprietario(cpf, nome, sexo, email, estado_civil, endereco, profissao, cod_id_imovel)
	VALUES('43654179320', 'Tânia Cunha Lima', 'FEMININO', 'taniaCunhaLima@teleworm.us', 'SOLTEIRA', 'Quadra C, 662 - BA', 'PROFESSORA', 2);
INSERT INTO cliente_proprietario(cpf, nome, sexo, email, estado_civil, endereco, profissao, cod_id_imovel)
	VALUES('97551784063', 'Ana Fernandes Barbosa', 'FEMININO', 'AnaFernandes@teleworm.us', 'CASADA', 'Rua Ramiz Gattaz, 1161 - SP', 'DATA SCIENCE', 4);
INSERT INTO cliente_proprietario(cpf, nome, sexo, email, estado_civil, endereco, profissao, cod_id_imovel)
	VALUES('90937324205', 'Isabella Cardoso Lima', 'FEMININO', 'IsabellaCar@rhyta.com', 'CASADA', 'Rua da Pátria, 830 - GO', 'DIPLOMATA', 5);
	
INSERT INTO cliente_proprietario(cpf, nome, sexo, email, estado_civil, endereco, profissao, cod_id_imovel)
	VALUES('68153616838', 'Isabelle Silva Azevedo', 'FEMININO', 'isabelleSilva@rhyta.com', 'CASADA', 'Beco Dom Bosco, 862 - ES', 'ENGENHEIRA', 9);
	
INSERT INTO cliente_proprietario(cpf, nome, sexo, email, estado_civil, endereco, profissao, cod_id_imovel)
	VALUES('91303444500', 'Douglas Carvalho Martins', 'MASCULINO', 'DouglasCar@dayrep.com', 'CASADO', 'Rua Bernardino Basani, 1942 - PR', 'CONTADOR', 13);
INSERT INTO cliente_proprietario(cpf, nome, sexo, email, estado_civil, endereco, profissao, cod_id_imovel)
	VALUES('26417353184', 'Kauê Cardoso Ferreira', 'MASCULINO', 'kaueCard@jourrapide.com', 'CASADO', 'Rua Passos, 1555 - SP', 'ENGENHEIRO', 14);

INSERT INTO cliente_proprietario(cpf, nome, sexo, email, estado_civil, endereco, profissao, cod_id_imovel)
	VALUES('99755574492', 'Leonor Carvalho Sousa', 'FEMININO', 'LeonorCar@rhyta.com', 'SOLTEIRA', 'Rua Professor Chryso Fontes, 764 - RJ', 'COZINHEIRA', 19);
INSERT INTO cliente_proprietario(cpf, nome, sexo, email, estado_civil, endereco, profissao, cod_id_imovel)
	VALUES('61106372891', 'Alex Ferreira Silva', 'MASCULINO', 'alexFer@armyspy.com', 'SOLTEIRO', 'Rua A-24, 243 - MT', 'MARCENEIRO', 20);

--- TABELA CARGOS --- 

INSERT INTO cargos(salario_base, nome)
	VALUES(1500.00, 'ATENDENTE');
INSERT INTO cargos(salario_base, nome)
	VALUES(1700.00, 'ANALISTA 1');
INSERT INTO cargos(salario_base, nome)
	VALUES(2000.00, 'ANALISTA 2');
INSERT INTO cargos(salario_base, nome)
	VALUES(3000.00, 'ADMINISTRADOR');
INSERT INTO cargos(salario_base, nome)
	VALUES(2500.00, 'ANALISTA 3');
	
--- TABELA FUNCIONÁRIOS ---

INSERT INTO funcionario(cpf, nome, sexo, endereco, data_ingresso, comissao, salario_base)
	VALUES('33387550405', 'Diogo Goncalves Lima', 'MASCULINO', 'Rua Ernesto Gomes Correa, 205 - SP', '2019-03-15', 200.00, 2000.00);
INSERT INTO funcionario(cpf, nome, sexo, endereco, data_ingresso, comissao, salario_base)
	VALUES('36405012093', 'Cauã Cunha Dias', 'MASCULINO', 'Rua Dezenove, 1171 - PE', '2020-05-20', 200.00, 2000.00);
INSERT INTO funcionario(cpf, nome, sexo, endereco, data_ingresso, comissao, salario_base)
	VALUES('94899506880', 'Thaís Correia Carvalho', 'FEMININO', 'Praça Padre Giovanni Graceffa, 867 - PR', '2021-08-25', 170.00, 1700.00);
INSERT INTO funcionario(cpf, nome, sexo, endereco, data_ingresso, comissao, salario_base)
	VALUES('49353904250', 'Thaís Costa Ferreira', 'FEMININO', 'Travessa São Judas Tadeu, 359 - RJ', '2021-09-03', 170.00, 1700.00);
INSERT INTO funcionario(cpf, nome, sexo, endereco, data_ingresso, comissao, salario_base)
	VALUES('22018281135', 'Alice Araujo Melo', 'FEMININO', 'Rua Nossa Senhora da Ajuda, 1131 - ES', '2018-07-30', 300.00, 3000.00);

--- TABELA LOGIN --- 

INSERT INTO login(cpf, usuario, senha)
	VALUES('33387550405', 'Manch19', 'ieGh0oovo');
INSERT INTO login(cpf, usuario, senha)
	VALUES('36405012093', 'Utu1997', 'Phaithi6');
INSERT INTO login(cpf, usuario, senha)
	VALUES('94899506880', 'Haile1976', 'Quooph5ae');
INSERT INTO login(cpf, usuario, senha)
	VALUES('49353904250', 'Knitted', 'Ishig0eiqu');
INSERT INTO login(cpf, usuario, senha)
	VALUES('22018281135', 'Goic1968', 'Kaa4dee3i');
	
--- TABELA TELEFONE FUNCIONARIO ---

INSERT INTO telefone_funcionario(id_telefone_funcionario, telefone, cpf)
	VALUES(1, '(49) 3502-7344', '33387550405');
INSERT INTO telefone_funcionario(id_telefone_funcionario, telefone, cpf)
	VALUES(2, '(32) 4580-4246', '36405012093');
INSERT INTO telefone_funcionario(id_telefone_funcionario, telefone, cpf)
	VALUES(3, '(65) 9238-9308', '94899506880');
INSERT INTO telefone_funcionario(id_telefone_funcionario, telefone, cpf)
	VALUES(4, '(31) 2172-9623', '49353904250');
INSERT INTO telefone_funcionario(id_telefone_funcionario, telefone, cpf)
	VALUES(5, '(63) 7300-9929', '22018281135');
	
--- TABELA TELEFONE CLIENTE PROPRIETARIO ---

INSERT INTO telefone_cliente_proprietario(id_telefone_cliente_proprietario, telefone, cpf)
	VALUES(1, '(12) 8344-9473', '64346900372');
INSERT INTO telefone_cliente_proprietario(id_telefone_cliente_proprietario, telefone, cpf)
	VALUES(2, '(79) 3418-7512', '43654179320');
INSERT INTO telefone_cliente_proprietario(id_telefone_cliente_proprietario, telefone, cpf)
	VALUES(3, '(81) 6453-5675', '68153616838');
INSERT INTO telefone_cliente_proprietario(id_telefone_cliente_proprietario, telefone, cpf)
	VALUES(4, '(11) 7112-5972', '26417353184');
INSERT INTO telefone_cliente_proprietario(id_telefone_cliente_proprietario, telefone, cpf)
	VALUES(5, '(84) 2788-6113', '61106372891');

--- TABELA TELEFONE CLIENTE USUÁRIO ---

INSERT INTO telefone_cliente_usuario(id_telefone_cliente_usuario, telefone, cpf)
	VALUES(1, '(91) 7052-6831', '11111009988');
INSERT INTO telefone_cliente_usuario(id_telefone_cliente_usuario, telefone, cpf)
	VALUES(2, '(61) 7303-6246', '22233300011');
INSERT INTO telefone_cliente_usuario(id_telefone_cliente_usuario, telefone, cpf)
	VALUES(3, '(11) 2727-7508', '25265633322');
INSERT INTO telefone_cliente_usuario(id_telefone_cliente_usuario, telefone, cpf)
	VALUES(4, '(42) 7672-2715', '88899956544');
INSERT INTO telefone_cliente_usuario(id_telefone_cliente_usuario, telefone, cpf)
	VALUES(5, '(13) 4316-4981', '33385214775');

--- TABELA REGISTRO ---

INSERT INTO registro(num_contrato, pagamento, data_transacao, cod_id_imovel, cpf_funcionario, cpf_cliente_proprietario, cpf_cliente_usuario)
	VALUES('1', 'CARTÃO DE DÉBITO', '2022-07-25', 1, '33387550405', '64346900372', NULL);
INSERT INTO registro(num_contrato, pagamento, data_transacao, cod_id_imovel, cpf_funcionario, cpf_cliente_proprietario, cpf_cliente_usuario)
	VALUES('2', 'CARTÃO DE CRÉDITO', '2022-08-20', 2, '33387550405', '43654179320', NULL);
INSERT INTO registro(num_contrato, pagamento, data_transacao, cod_id_imovel, cpf_funcionario, cpf_cliente_proprietario, cpf_cliente_usuario)
	VALUES('3', 'DINHEIRO', '2022-12-20', 4, '36405012093', '97551784063', '25265633322');
INSERT INTO registro(num_contrato, pagamento, data_transacao, cod_id_imovel, cpf_funcionario, cpf_cliente_proprietario, cpf_cliente_usuario)
	VALUES('4', 'CARTÃO DE DÉBITO', '2022-04-05', 5, '36405012093', '90937324205', '88899956544');
	
INSERT INTO registro(num_contrato, pagamento, data_transacao, cod_id_imovel, cpf_funcionario, cpf_cliente_proprietario, cpf_cliente_usuario)
	VALUES('5', 'CARTÃO DE DÉBITO', '2022-08-30', 9, '94899506880', '68153616838', NULL);
	
INSERT INTO registro(num_contrato, pagamento, data_transacao, cod_id_imovel, cpf_funcionario, cpf_cliente_proprietario, cpf_cliente_usuario)
	VALUES('6', 'DINHEIRO', '2022-02-25', 13, '49353904250', '91303444500', '33385214775');
INSERT INTO registro(num_contrato, pagamento, data_transacao, cod_id_imovel, cpf_funcionario, cpf_cliente_proprietario, cpf_cliente_usuario)
	VALUES('7', 'CARTÃO DE CRÉDITO', '2022-04-19', 14, '49353904250', '26417353184', NULL);
	
INSERT INTO registro(num_contrato, pagamento, data_transacao, cod_id_imovel, cpf_funcionario, cpf_cliente_proprietario, cpf_cliente_usuario)
	VALUES('8', 'CARTÃO DE CRÉDITO', '2022-06-10', 19, '22018281135', '99755574492', '11111009988');
INSERT INTO registro(num_contrato, pagamento, data_transacao, cod_id_imovel, cpf_funcionario, cpf_cliente_proprietario, cpf_cliente_usuario)
	VALUES('9', 'DINHEIRO', '2022-11-01', 20, '22018281135', '61106372891', '22233300011');
	
--- TABELA ALUGA ---

INSERT INTO aluga(id_aluga, data_locacao, taxa_imobiliaria, taxa_incendio, valor, cod_id_imovel, cpf_funcionario, cpf_cliente_usuario)
	VALUES(1, '2023-01-07', 120.00, 165.00, 1200.00, 4, '36405012093', '25265633322');
INSERT INTO aluga(id_aluga, data_locacao, taxa_imobiliaria, taxa_incendio, valor, cod_id_imovel, cpf_funcionario, cpf_cliente_usuario)
	VALUES(2, '2022-12-07', 130.00, 180.00, 1300.00, 5, '36405012093', '88899956544');
	
INSERT INTO aluga(id_aluga, data_locacao, taxa_imobiliaria, taxa_incendio, valor, cod_id_imovel, cpf_funcionario, cpf_cliente_usuario)
	VALUES(3, '2022-04-25', 350.00, 270.00, 3500.00, 13, '36405012093', '25265633322');
	
INSERT INTO aluga(id_aluga, data_locacao, taxa_imobiliaria, taxa_incendio, valor, cod_id_imovel, cpf_funcionario, cpf_cliente_usuario)
	VALUES(4, '2022-08-12', 170.00, 135.00, 1700.00, 19, '22018281135', '11111009988');
INSERT INTO aluga(id_aluga, data_locacao, taxa_imobiliaria, taxa_incendio, valor, cod_id_imovel, cpf_funcionario, cpf_cliente_usuario)
	VALUES(5, '2023-01-02', 145.00, 120.00, 1450.00, 20, '22018281135', '22233300011');

--- TABELA COMPRA ---

INSERT INTO compra(id_compra, data_compra, taxa_imobiliaria, valor, cod_id_imovel, cpf_funcionario, cpf_cliente_proprietario)
	VALUES(1, '2022-07-25', 5000.00, 100000.00, 1, '33387550405', '64346900372');
INSERT INTO compra(id_compra, data_compra, taxa_imobiliaria, valor, cod_id_imovel, cpf_funcionario, cpf_cliente_proprietario)
	VALUES(2, '2022-08-20', 8250.00, 165000.00, 2, '33387550405', '43654179320');
INSERT INTO compra(id_compra, data_compra, taxa_imobiliaria, valor, cod_id_imovel, cpf_funcionario, cpf_cliente_proprietario)
	VALUES(3, '2022-12-20', 12500.00, 250000.00, 4, '36405012093', '97551784063');
INSERT INTO compra(id_compra, data_compra, taxa_imobiliaria, valor, cod_id_imovel, cpf_funcionario, cpf_cliente_proprietario)
	VALUES(4, '2022-04-05', 20000.00, 400000.00, 5, '36405012093', '90937324205');
	
INSERT INTO compra(id_compra, data_compra, taxa_imobiliaria, valor, cod_id_imovel, cpf_funcionario, cpf_cliente_proprietario)
	VALUES(5, '2022-08-30', 35000.00, 700000.00, 9, '94899506880', '68153616838');
	
INSERT INTO compra(id_compra, data_compra, taxa_imobiliaria, valor, cod_id_imovel, cpf_funcionario, cpf_cliente_proprietario)
	VALUES(6, '2022-02-25', 27500.00, 550000.00, 13, '49353904250', '91303444500');
INSERT INTO compra(id_compra, data_compra, taxa_imobiliaria, valor, cod_id_imovel, cpf_funcionario, cpf_cliente_proprietario)
	VALUES(7, '2022-04-19', 35500.00, 710000.00, 14, '49353904250', '26417353184');
	
INSERT INTO compra(id_compra, data_compra, taxa_imobiliaria, valor, cod_id_imovel, cpf_funcionario, cpf_cliente_proprietario)
	VALUES(8, '2022-06-10', 10000.00, 200000.00, 19, '22018281135', '99755574492');
INSERT INTO compra(id_compra, data_compra, taxa_imobiliaria, valor, cod_id_imovel, cpf_funcionario, cpf_cliente_proprietario)
	VALUES(9, '2022-11-01', 5250.00, 105000.00, 20, '22018281135', '61106372891');
	
--- TABELA HISTÓRICO ---

INSERT INTO historico(id_historico, registro, status_locacao, status_venda, cod_id_imovel, data_compra, data_locacao)
	VALUES(1, '1', 'DISPONÍVEL', 'INDISPONÍVEL', 1, '2022-07-25', NULL);
INSERT INTO historico(id_historico, registro, status_locacao, status_venda, cod_id_imovel, data_compra, data_locacao)
	VALUES(2, '2', 'DISPONÍVEL', 'INDISPONÍVEL', 2, '2022-08-20', NULL);
INSERT INTO historico(id_historico, registro, status_locacao, status_venda, cod_id_imovel, data_compra, data_locacao)
	VALUES(3, NULL, 'INDISPONÍVEL', 'DISPONÍVEL', 3, NULL, NULL);
INSERT INTO historico(id_historico, registro, status_locacao, status_venda, cod_id_imovel, data_compra, data_locacao)
	VALUES(4, '3', 'INDISPONÍVEL', 'INDISPONÍVEL', 4, '2022-12-20', '2023-01-07');
INSERT INTO historico(id_historico, registro, status_locacao, status_venda, cod_id_imovel, data_compra, data_locacao)
	VALUES(5, '4', 'INDISPONÍVEL', 'INDISPONÍVEL', 5, '2022-04-05', '2022-12-07');
	
INSERT INTO historico(id_historico, registro, status_locacao, status_venda, cod_id_imovel, data_compra, data_locacao)
	VALUES(6, NULL, 'INDISPONÍVEL', 'DISPONÍVEL', 6, NULL, NULL);
INSERT INTO historico(id_historico, registro, status_locacao, status_venda, cod_id_imovel, data_compra, data_locacao)
	VALUES(7, NULL, 'INDISPONÍVEL', 'DISPONÍVEL', 7, NULL, NULL);
INSERT INTO historico(id_historico, registro, status_locacao, status_venda, cod_id_imovel, data_compra, data_locacao)
	VALUES(8, NULL, 'INDISPONÍVEL', 'DISPONÍVEL', 8, NULL, NULL);
INSERT INTO historico(id_historico, registro, status_locacao, status_venda, cod_id_imovel, data_compra, data_locacao)
	VALUES(9, '5', 'INDISPONÍVEL', 'INDISPONÍVEL', 9, '2022-08-30', NULL);
INSERT INTO historico(id_historico, registro, status_locacao, status_venda, cod_id_imovel, data_compra, data_locacao)
	VALUES(10, NULL, 'DISPONÍVEL', 'DISPONÍVEL', 10, NULL, NULL);
	
INSERT INTO historico(id_historico, registro, status_locacao, status_venda, cod_id_imovel, data_compra, data_locacao)
	VALUES(11, NULL, 'INDISPONÍVEL', 'INDISPONÍVEL', 11, NULL, NULL);
INSERT INTO historico(id_historico, registro, status_locacao, status_venda, cod_id_imovel, data_compra, data_locacao)
	VALUES(12, NULL, 'INDISPONÍVEL', 'DISPONÍVEL', 12, NULL, NULL);
INSERT INTO historico(id_historico, registro, status_locacao, status_venda, cod_id_imovel, data_compra, data_locacao)
	VALUES(13, '6', 'INDISPONÍVEL', 'INDISPONÍVEL', 13, '2022-02-25', '2022-04-25');
INSERT INTO historico(id_historico, registro, status_locacao, status_venda, cod_id_imovel, data_compra, data_locacao)
	VALUES(14, '7', 'DISPONÍVEL', 'INDISPONÍVEL', 14, '2022-04-19', NULL);
INSERT INTO historico(id_historico, registro, status_locacao, status_venda, cod_id_imovel, data_compra, data_locacao)
	VALUES(15, NULL, 'INDISPONÍVEL', 'DISPONÍVEL', 15, NULL, NULL);

INSERT INTO historico(id_historico, registro, status_locacao, status_venda, cod_id_imovel, data_compra, data_locacao)
	VALUES(16, NULL, 'INDISPONÍVEL', 'DISPONÍVEL', 16, NULL, NULL);
INSERT INTO historico(id_historico, registro, status_locacao, status_venda, cod_id_imovel, data_compra, data_locacao)
	VALUES(17, NULL, 'INDISPONÍVEL', 'DISPONÍVEL', 17, NULL, NULL);
INSERT INTO historico(id_historico, registro, status_locacao, status_venda, cod_id_imovel, data_compra, data_locacao)
	VALUES(18, NULL, 'INDISPONÍVEL', 'DISPONÍVEL', 18, NULL, NULL);
INSERT INTO historico(id_historico, registro, status_locacao, status_venda, cod_id_imovel, data_compra, data_locacao)
	VALUES(19, '8', 'INDISPONÍVEL', 'INDISPONÍVEL', 19, '2022-06-10', '2022-08-12');
INSERT INTO historico(id_historico, registro, status_locacao, status_venda, cod_id_imovel, data_compra, data_locacao)
	VALUES(20, '9', 'INDISPONÍVEL', 'INDISPONÍVEL', 20, '2022-11-01', '2023-01-02');
