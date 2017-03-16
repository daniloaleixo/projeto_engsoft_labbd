# LEME #

Instituto de Matemática e Estatística 
Bacharelado em Ciência da Computação 
Projeto do curso Laboratório de Banco de Dados - MAC0439 
Segundo semestre de 2015

Alunos: 
* Bruno de Oliveira Endo - 7990982 
* Carlos Augusto Motta de Lima - 7991228 
* Danilo Aleixo Gomes de Souza - 7972370 
* Gabriel Torres Gomes Pato - 5128401 
* José Ernesto Young Rodrigues - 7991083

## DESCRIÇÃO DO PROJETO ##
Leme é uma plataforma web educacional que pretende horizontalizar a educação. Através dela, seu usuário pode oferecer cursos sobre qualquer assunto (tornando-se assim, professor e responsável do curso que oferece) para todos os outros usuários.

Cada curso oferecido na plataforma terá um fórum onde os alunos poderão interagir entre si e com os professores, além de salas de aula virtuais com materiais de apoio (textos, links etc). Além disso, um curso poderá ter professores ou monitores extras para auxiliar no andamento do curso.

O sistema de aprendizado online será estruturado de modo que os cursos serão ranqueados pelos usuários de acordo com a proposta do mesmo, assim o sistema se autogerencia, colocando as melhores aulas (aulas com melhor ranking) em destaque.


## MODELAGEM/IMPLEMENTAÇÃO ## 

A modelagem está baseada quase integralmente no modelo relacional, usando apenas um modelo NoSQL para uma funcionalidade específica (descrita em seções posteriores).

O SGBD SQL usado foi o MySQL, enquanto que o NoSQL foi o Redis.

Na modelagem do banco de dados MySQL temos as entidades Usuário, Área, Curso, Aula, Avaliação, Material, Post, Texto e Referência externa. Possuirão os seguintes atributos: Usuário terá Login, Senha e Nome; Curso possuirá Título, Descrição, Data de Início e Data de Fim; Área terá Título como único parâmetro; Aula terá Vídeo, Duração, Data de Criação e Título; Tópico possuirá Título e Tipo; e Post terá Data de Criação e Texto.

Cada área possui sub-áreas. Para modelar isso, usamos um auto-relacionamento nessa entidade chamado “é sub-área de”. Além disso, cada área possui vários cursos.

A entidade Disciplina, além da relação citada, se relacionará com Usuário, sendo que cada um desses poderá “auxiliar”, “lecionar” ou “cursar” uma ou várias Disciplinas e, neste último caso, a relação “cursa” terá dois parâmetros: Data de Matrícula e Data de Encerramento. Curso ainda terá a relação “tem” com a entidade Aula onde cada curso poderá ter várias aulas (que pertencem a um único curso) e a relação “possui” com a entidade Tópico, na qual também cada curso poderá ter diversos tópicos que pertencem a um único curso.

A entidade Usuário ainda terá três outras relações: vários Usuários poderão “avaliar” várias aulas e nessa relação teremos Data de Avaliação e Nota como parâmetros, diversos Posts podem ser postados, cada qual por um único Usuário e, por fim, diversos Usuários poderão “assistir” a diversas aulas, e nessa relação teremos Data de Início, Evolução e Último Acesso como parâmetros. A entidade Post terá um auto-relacionamento no qual diversos Posts “são respostas de” um único post. Várias Aulas podem “ter” vários tópicos. Por fim um Tópico “possui” diversos Posts.

Quanto à implementação do sistema WEB, foi utilizado o framework Cake PHP, que implementa o modelo MVC (Model, View, Controller - https://pt.wikipedia.org/wiki/MVC) utilizando a linguagem PHP versão 5.

Quanto ao Redis, utilizou-se a versão 3.5.0 (http://redis.io). O Redis foi utilizado para fazer um contador de visualizações de aulas para cada curso. A ideia de utilizá-lo foi para otimizar a atualização dos contadores no caso de muitos usuários usando a plataforma ao mesmo tempo.

O Redis não pode ser instalado com sucesso na produção (comando make funcionou com sucesso, mas o comando ‘make test’ apresentou diversos erros). Contudo, o funcionamento geral da implementação do Redis foi exposto na apresentação do projeto em aula. Todo o código que envolve seu manuseio foi comentado na versão em produção.

## ACESSO A PLATAFORMA ## 
A plataforma foi disponibilizada online, em um servidor nosso, disponível no [site](http://labbd.teste.gwd-web.com.br/):

Porém tivemos alguns problemas em relação ao SGDB NoSQL Redis, que devido a incompatibilidade do gcc que estava rodando no server não permitiu a instalação correta do sistema e por isso estava causando erro nas páginas da plataforma. Portanto decidimos deixar o Redis fora da plataforma online, entretanto a validação do mesmo pode ser feita através do código-fonte.

## SQL no Código Fonte ##

Existem 3 arquivos .sql no código fonte DADOS.sql, TABELAS.sql e TUDO.sql Para melhor compreensão da monitora o arquivo TUDO.sql possui todos os cripts de criação de tabela e views que usamos no sistema, então esse seria o melhor arquivo para avaliar esses conceitos.