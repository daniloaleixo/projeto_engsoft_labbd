create table if not exists 'usuario' (
	'email' varchar(128) NOT NULL,
	'senha' varchar(512) NOT NULL,
	'nome' varchar(256) NOT NULL,
	PRIMARY KEY ('email'),
);
################################################################################
create table if not exists 'area'(
	'titulo' varchar(128) NOT NULL,
	'e_subarea' varchar(128) DEFAULT NULL,
	'criado_por' varchar(128) NOT NULL,
	'criado_em' datetime NOT NULL,
	PRIMARY KEY ('titulo'),
	KEY 'e_subarea' ('e_subarea'),
	KEY 'criado_por' ('criado_por'),
	CONSTRAINT 'area_fk1' FOREIGN KEY ('e_subarea') REFERENCES 'area' ('titulo'),
	CONSTRAINT 'area_fk2' FOREIGN KEY ('criado_por') REFERENCES 'usuario' ('email'),
);
################################################################################
create table if not exists 'curso' (
	'titulo' varchar(512) NOT NULL,
	'descricao' varchar(1024),
	'data_inicio' date,
	'area_pertencente' varchar(128) NOT NULL,
	KEY 'area_pertencente' ('area_pertencente'),
	CONSTRAINT 'curso_fk1' FOREIGN KEY ('area_pertencente') REFERENCES 'area' ('titulo'),
	PRIMARY KEY ('titulo'),
);
################################################################################
create table if not exists 'aula' (
	'id' int(11) NOT NULL AUTO INCREMENT,
	'titulo' varchar(256),
	'curso_pertencente' varchar(512) NOT NULL,
	KEY 'curso_pertencente' ('curso_pertencente'),
	CONSTRAINT 'aula_fk1' FOREIGN KEY ('curso_pertencente') REFERENCES 'curso' ('titulo'),
	PRIMARY KEY ('id'),
);
################################################################################
create table if not exists 'avaliou' (
	'avaliador_email' varchar(128) NOT NULL,
	'aula_id' int(11) NOT NULL,
	'nota' int(2) DEFAULT 0,
	KEY 'avaliador_email' ('avaliador_email'),
	KEY 'aula_id' ('aula_id'),
	CONSTRAINT 'avaliou_fk1' FOREIGN KEY ('avaliador_email') REFERENCES 'usuario' ('email'),
	CONSTRAINT 'avaliou_fk2' FOREIGN KEY ('aula_id') REFERENCES 'aula' ('id'),
	PRIMARY KEY ('avaliador_email', 'aula_id')
);
################################################################################
create table if not exists 'questao' (
	'enunciado' text NOT NULL,
	'aula_id' int(11) NOT NULL,
	KEY 'aula_id' ('aula_id'),
	CONSTRAINT 'questao_fk1' FOREIGN KEY ('aula_id') REFERENCES 'aula' ('id'),
	PRIMARY KEY ('enunciado')
);
################################################################################
create table if not exists 'alternativa' (
	'alternativa_certa' tinyint(1) NOT NULL DEFAULT 0,
	'texto' text NOT NULL,
	'questao_enunciado' text NOT NULL,
	PRIMARY KEY ('questao_enunciado', 'texto') ON DELETE CASCADE,
	KEY 'questao_enunciado' ('questao_enunciado'),
	CONSTRAINT 'alternativa_fk1' FOREIGN KEY ('questao_enunciado') REFERENCES 'questao' ('enunciado'),
);
################################################################################
create table if not exists 'post' (
	'id' int(11) NOT NULL AUTO INCREMENT,
	'texto' text,
	'data_criacao' date NOT NULL,
	'usuario_email' varchar(128) NOT NULL,
	'aula_id' int(11) NOT NULL,
	'e_resposta_a' int(11) DEFAULT NULL,
	PRIMARY KEY ('id'),
	KEY 'usuario_email' ('usuario_email'),
	KEY 'e_resposta_a' ('e_resposta_a'),
	KEY 'aula_id' ('aula_id'),
	CONSTRAINT 'post_fk1' FOREIGN KEY ('usuario_email') REFERENCES 'usuario' ('email'),
	CONSTRAINT 'post_fk2' FOREIGN KEY ('e_resposta_a') REFERENCES 'post' ('id'),
	CONSTRAINT 'post_fk3' FOREIGN KEY ('aula_id') REFERENCES 'aula' ('id'),
);
################################################################################
create table if not exists 'participa' (
	'participante_email' varchar(128) NOT NULL,
	'curso_titulo' varchar(512) NOT NULL,
	'permissao' int(2),
	'data_inicio' date NOT NULL,
	PRIMARY KEY ('participante_email', 'curso_titulo', 'permissao'),
	KEY 'participante_email' ('participante_email'),
	KEY 'curso_titulo' ('curso_titulo'),
	CONSTRAINT 'participa_fk1' FOREIGN KEY ('participante_email') REFERENCES 'usuario' ('email'),
	CONSTRAINT 'participa_fk2' FOREIGN KEY ('curso_titulo') REFERENCES 'curso' ('titulo'),
);
################################################################################
create table if not exists 'material' (
	'id' int(11) NOT NULL AUTO INCREMENT,
	'data_criacao' date NOT NULL,
	'aula_id' int(11) NOT NULL,
	'uploader_email' varchar(128) NOT NULL,
	KEY 'aula_id' ('aula_id'),
	KEY 'uploader_email' ('uploader_email'),
	CONSTRAINT 'material_fk1' FOREIGN KEY ('uploader_email') REFERENCES 'usuario' ('email'),
	CONSTRAINT 'material_fk2' FOREIGN KEY ('aula_id') REFERENCES 'aula' ('id'),
	PRIMARY KEY ('id'),
);
################################################################################
create table if not exists 'visualizacao' (
	'aluno_email' varchar(128) NOT NULL,
	'material_id' int(11) NOT NULL,
	'data_visualizacao' date NOT NULL,
	PRIMARY KEY ('aluno_email', 'material_id') ON DELETE CASCADE,
	KEY 'aluno_email' ('aluno_email'),
	KEY 'material_id' ('material_id'),
	CONSTRAINT 'visualizacao_fk1' FOREIGN KEY ('aluno_email') REFERENCES 'usuario' ('email'),
	CONSTRAINT 'visualizacao_fk2' FOREIGN KEY ('material_id') REFERENCES 'material' ('id'),
);
################################################################################
create table if not exists 'texto' (
	'material_id' int(11) NOT NULL,
	'conteudo' text,
	PRIMARY KEY ('material_id') ON DELETE CASCADE,
	KEY 'material_id' ('material_id'),
	CONSTRAINT 'texto_fk2' FOREIGN KEY ('material_id') REFERENCES 'material' ('id'),
);
################################################################################
create table if not exists 'arquivo_subido' (
	'material_id' int(11) NOT NULL,
	'tamanho' int(11),
	'extensao_arquivo' varchar(4) DEFAULT NULL,
	PRIMARY KEY ('material_id') ON DELETE CASCADE,
	KEY 'material_id' ('material_id'),
	CONSTRAINT 'arquivo_subido_fk1' FOREIGN KEY ('material_id') REFERENCES 'material' ('id'),
);
################################################################################
create table if not exists 'referencia_externa' (
	'id' int(11) NOT NULL AUTO INCREMENT,
	'material_id' int(11) NOT NULL,
	'link' varchar(256),
	PRIMARY KEY ('id'),
	KEY 'material_id' ('material_id'),
	CONSTRAINT 'referencia_externa_fk1' FOREIGN KEY ('material_id') REFERENCES 'material' ('id') ON DELETE CASCADE,
);
################################################################################
create table if not exists 'video' (
	'id' int(11) NOT NULL AUTO INCREMENT,
	'ref_externa_id' int(11) NOT NULL,
	'duracao' double,
	PRIMARY KEY ('id') ON DELETE CASCADE,
	KEY 'ref_externa_id' ('ref_externa_id'),
	CONSTRAINT 'video_fk1' FOREIGN KEY ('ref_externa_id') REFERENCES 'referencia_externa' ('id') ON DELETE CASCADE,
);
################################################################################
create table if not exists 'assistiu' (
	'usuario_email' varchar(128) NOT NULL,
	'video_id' int(11) NOT NULL,
	'tempo_visualizado' double,
	PRIMARY KEY ('usuario_email', 'video_id') ON DELETE CASCADE,
	KEY 'usuario_email' ('usuario_email'),
	KEY 'video_id' ('video_id'),
	CONSTRAINT 'assistiu_fk1' FOREIGN KEY ('usuario_email') REFERENCES 'usuario' ('email'),
	CONSTRAINT 'assistiu_fk2' FOREIGN KEY ('video_id') REFERENCES 'video' ('id'),
);



#################
####TRIGGERS#####
################################################################################
CREATE or REPLACE FUNCTION verifica_alternativas()
	RETURNS TRIGGER AS $$
BEGIN
	IF 5 = (SELECT count(*) FROM alternativa AS A WHERE A.questao_enunciado = NEW.questao_enunciado) THEN
	RAISE EXCEPTION 'Já existem 5 alternativas para a questão';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER cinco_alternativas
BEFORE INSERT OR UPDATE OF questao_enunciado ON alternativa
FOR EACH ROW
EXECUTE PROCEDURE verifica_alternativas();
################################################################################
CREATE or REPLACE FUNCTION verifica_alternativas1()
	RETURNS TRIGGER AS $$
BEGIN
	IF 4 = (SELECT count(*) FROM alternativa AS A WHERE A.questao_enunciado = NEW.questao_enunciado AND A.alternativa_certa = 0) AND NEW.alternativa_certa = 0 THEN
	RAISE EXCEPTION 'A questão precisa de uma alternativa correta';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER uma_alternativa_certa1
BEFORE INSERT ON alternativa
FOR EACH ROW
EXECUTE PROCEDURE verifica_alternativas1();
################################################################################
CREATE or REPLACE FUNCTION verifica_alternativas2()
	RETURNS TRIGGER AS $$
BEGIN
	IF 1 = (SELECT count(*) FROM alternativa AS A WHERE A.questao_enunciado = NEW.questao_enunciado AND A.alternativa_certa = 1) AND NEW.alternativa_certa = 1 THEN
	RAISE EXCEPTION 'A questão só pode ter uma alternativa correta';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER uma_alternativa_certa2
BEFORE INSERT ON alternativa
FOR EACH ROW
EXECUTE PROCEDURE verifica_alternativas2();




ATENÇÃO!!! CRIAR COISAS EXTRAS LISTADAS ABAIXO
- função pra verificar que apenas uma das alternativas eh certa
