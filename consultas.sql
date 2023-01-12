/* BONIFICAR O FUNCIONÁRIO QUE VENDEU A MAIOR QUANTIA EM PROPRIEDADES */
--- A BONIFICAÇÃO É 2% DO VALOR FATURADO
	
--- 1 SELECIONAR OS NOMES FUNCIONÁRIOS E OS RESPECTIVOS NOMES DOS CLIENTES OS QUAIS FORAM ATENDIDOS PARA VENDAS, ASSIM COMO OS VALORES DAS VENDAS --- 

SELECT funcionario.nome, cliente_proprietario.nome, compra.valor
	FROM funcionario INNER JOIN 
		(compra INNER JOIN cliente_proprietario
		 	ON compra.cpf_cliente_proprietario = cliente_proprietario.cpf)
		ON funcionario.cpf = compra.cpf_funcionario;
				
--- 2 SELECIONAR A QUANTIA TOTAL QUE CADA FUNCIONARIO OBTEVE NAS VENDAS DE IMÓVEIS---

SELECT funcionario.nome, SUM (compra.valor) AS Quantia_Total
	FROM funcionario INNER JOIN compra
	ON funcionario.cpf = compra.cpf_funcionario
	GROUP BY funcionario.nome;
	
--- 3 SELECIONAR O FUNCIONÁRIO QUE OBTEVE A MAIOR QUANTIA ---

SELECT a.nome, c.maior_quantia_vendida
	FROM(SELECT funcionario.nome, SUM (compra.valor) AS Quantia_Total
			FROM funcionario INNER JOIN compra
			ON funcionario.cpf = compra.cpf_funcionario
			GROUP BY funcionario.nome) AS a
INNER JOIN(SELECT MAX(b.quantia_total) AS maior_quantia_vendida
			FROM (SELECT funcionario.nome, SUM (compra.valor) AS Quantia_Total
						FROM funcionario INNER JOIN compra
						ON funcionario.cpf = compra.cpf_funcionario
						GROUP BY funcionario.nome) AS b) AS c
ON a.quantia_total = c.maior_quantia_vendida;

--- 4 Procurar o telefone do funcionário em questão para notificá-lo da bonificacao e o cargo da mesma ---

SELECT f.nome, f.telefone, cargos.nome
FROM ( SELECT *
		FROM (SELECT * 
				FROM (SELECT a.nome
						FROM(SELECT funcionario.nome, SUM (compra.valor) AS Quantia_Total
								FROM funcionario INNER JOIN compra
								ON funcionario.cpf = compra.cpf_funcionario
								GROUP BY funcionario.nome) AS a
					INNER JOIN(SELECT MAX(b.quantia_total) AS maior_quantia_vendida
								FROM (SELECT funcionario.nome, SUM (compra.valor) AS Quantia_Total
											FROM funcionario INNER JOIN compra
											ON funcionario.cpf = compra.cpf_funcionario
											GROUP BY funcionario.nome) AS b) AS c
					ON a.quantia_total = c.maior_quantia_vendida) AS d
			NATURAL JOIN funcionario
		) as e 
		INNER JOIN telefone_funcionario
		 ON e.cpf = telefone_funcionario.cpf) AS f
INNER JOIN cargos
 ON f.salario_base = cargos.salario_base;
 
 /* Qual tipo de imóvel é mais alugado e suas características, no
intuito de investigar as opções que mais agradam e desagradam os clientes usuários no momento da escolha  */

--- 5 IMOVEIS MAIS ALUGADOS ---

SELECT imovel.tipo_imovel, COUNT(*) AS numero_de_imoveis_alugados 
	FROM aluga NATURAL JOIN imovel
	GROUP BY imovel.tipo_imovel
	ORDER BY COUNT(*) DESC;

---  6 CARACTERÍSTICAS DOS IMOVEIS MAIS ALUGADOS ---

SELECT * 
	FROM(SELECT *
		FROM(SELECT imovel.cod_id_imovel,imovel.tipo_imovel
			FROM aluga NATURAL JOIN imovel) AS a
		INNER JOIN apartamento 
		ON a.cod_id_imovel = apartamento.cod_id_ap) AS b
	INNER JOIN endereco
	ON b.id_endereco = endereco.id_endereco;

SELECT * 
	FROM(SELECT *
		FROM(SELECT imovel.cod_id_imovel,imovel.tipo_imovel
			FROM aluga NATURAL JOIN imovel) AS a
		INNER JOIN casa 
		ON a.cod_id_imovel = casa.cod_id_c) AS b
	INNER JOIN endereco
	ON b.id_endereco = endereco.id_endereco;
	
SELECT * 
	FROM(SELECT *
		FROM(SELECT imovel.cod_id_imovel,imovel.tipo_imovel
			FROM aluga NATURAL JOIN imovel) AS a
		INNER JOIN sala_comercial 
		ON a.cod_id_imovel = sala_comercial.cod_id_sc) AS b
	INNER JOIN endereco
	ON b.id_endereco = endereco.id_endereco;
	
--- 7 IMOVEIS NÃO ALUGADOS ---

SELECT a.tipo_imovel, COUNT(*) AS numero_de_imoveis_nao_alugados 
	FROM(SELECT imovel.cod_id_imovel,imovel.tipo_imovel
			FROM aluga FULL OUTER JOIN imovel
			ON imovel.cod_id_imovel = aluga.cod_id_imovel
			WHERE aluga.id_aluga IS NULL) AS a
		GROUP BY a.tipo_imovel
		ORDER BY COUNT(*) DESC;
		
--- 8 QUAL BAIRRO ESTÃO OS IMOVEIS NÃO ALUGADOS ---

SELECT endereco.bairro, COUNT(*) AS numero_de_imoveis_nao_alugados 
	FROM(SELECT imovel.cod_id_imovel,imovel.tipo_imovel
			FROM aluga FULL OUTER JOIN imovel
			ON imovel.cod_id_imovel = aluga.cod_id_imovel
			WHERE aluga.id_aluga IS NULL) AS b
	INNER JOIN endereco
	ON b.cod_id_imovel = endereco.id_endereco
	GROUP BY endereco.bairro
	ORDER BY COUNT(*) DESC;

--- /* AVALIAR PERFIL DOS CLIENTES PARA ENTENDER O MAIOR PÚBLICO ALVO  */ --- 

--- 9 QUANTOS CLIENTES HÁ DO SEXO MASCULINO E FEMININO---

SELECT  cliente_usuario.sexo AS genero_cliente_usuario, 
		COUNT(cliente_usuario.sexo) AS numero_de_clientes,
		cliente_proprietario.sexo AS genero_cliente_proprietario,
		COUNT(cliente_proprietario.sexo) AS numero_de_clientes
	FROM cliente_usuario FULL OUTER JOIN cliente_proprietario
	ON cliente_usuario.cpf = cliente_proprietario.cpf
	GROUP BY cliente_usuario.sexo, cliente_proprietario.sexo
	HAVING (UPPER(cliente_usuario.sexo) = 'MASCULINO' OR UPPER(cliente_usuario.sexo) = 'FEMININO' OR
	UPPER(cliente_proprietario.sexo) = 'MASCULINO' OR UPPER(cliente_proprietario.sexo) = 'FEMININO');
	
--- 10 QUANTOS CLIENTES MORAVAM/MORAM NA REGIAO SUDESTE ---

SELECT SUM(a.clientes_originarios_da_regiao_sudeste) AS total_de_clientes_originarios_da_regiao_sudeste
	FROM (
SELECT COUNT(*) AS clientes_originarios_da_regiao_sudeste
	FROM cliente_usuario FULL OUTER JOIN cliente_proprietario
	ON cliente_usuario.cpf = cliente_proprietario.cpf
	GROUP BY cliente_usuario.cpf, cliente_proprietario.cpf
	HAVING (UPPER(cliente_usuario.endereco) LIKE '%%MG' OR
			UPPER(cliente_usuario.endereco) LIKE '%%SP' OR
			UPPER(cliente_usuario.endereco) LIKE '%%RJ' OR
			UPPER(cliente_usuario.endereco) LIKE '%%ES' OR
			UPPER(cliente_proprietario.endereco) LIKE '%%MG' OR
			UPPER(cliente_proprietario.endereco) LIKE '%%SP' OR
			UPPER(cliente_proprietario.endereco) LIKE '%%RJ' OR
			UPPER(cliente_proprietario.endereco) LIKE '%%ES'
		   )) AS a;
