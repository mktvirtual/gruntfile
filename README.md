Gruntfile.coffee
================

> Gruntfile padrão para iniciar rapidamente projetos com automação

## Sobre

Se você ainda não conhece o Grunt, recomendamos que leia a [sua documentação](http://gruntjs.com/getting-started). Caso prefira ler em português, [uma versão traduzida](https://github.com/gruntbrasil/grunt-docs) foi criada pela [comunidade Grunt Brasil](https://www.facebook.com/groups/gruntbrasil/).

O Grunt é uma ferramenta de automação de tarefas em JavaScript. Com ele é possível configurar simples objetos e ganhar muito tempo ao automatizar tarefas repetitivas como de validação e concatenação de scripts.

## Usando

O `Gruntfile.coffee` deste repositório serve como uma base sólida para a automação de tarefas na maioria dos projetos web da **Mkt Virtual**.

Assumimos que você já tem o Grunt instalado na sua máquina de desenvolvimento. Para utilizá-lo execute os seguintes comandos:

```shell
git clone git@github.com:mktvirtual/gruntfile.git gruntifile
cd $_
```

Copie os arquivos `package.json` e `Gruntfile.coffee` para a pasta do seu projeto e instale os plugins do Grunt usando o seguinte comando dentro da pasta:

```shell
npm install
```

Após a instalação, edite o `Gruntfile.coffee` para atender as necessidades de cada projeto. Altere a variável `paths`, por exemplo, para adequar o arquivo à estruturação do seu projeto. Altere também o `package.json`, trocando para as suas informações.

O arquivo `Gruntfile.coffee` está bem comentado e explicativo.

*Dica: ignore a pasta node_modules caso use Git ou SVN.*

## Extras

Nem todos os plugins que achamos legais estão aqui, somente os mais importantes. Porém, seperamos [uma lista com outros que recomendamos](https://github.com/mktvirtual/gruntfile/blob/master/EXTRAS.md).

## Contribua

Você pode contribuir, tanto arrumando [alguns problemas](https://github.com/mktvirtual/gruntfile/issues) quanto trazendo novidades.

1. Crie um fork!
2. Crie uma branch para a sua nova funcionalidae: `git checkout -b nova-funcionalidade`
3. Dê Commit com as suas modificações: `git commit -m 'Nova funcionalidade'`
4. Dê Push na branch: `git push origin nova-funcionalidade`
5. Envie um pull request :D

## Histórico

[Lista de releases](https://github.com/mktvirtual/gruntfile/releases)

## Licença

[Licença MIT](https://github.com/mktvirtual/gruntfile/blob/master/LICENSE) © Mkt Virtual
