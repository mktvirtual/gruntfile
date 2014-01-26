module.exports = (grunt) ->

    # chama o matchdep que carrega todas as tarefas nas quais o nome comece com "grunt-"
    require("matchdep").filterDev("grunt-*").forEach(grunt.loadNpmTasks)
    grunt.initConfig

        # caminhos padrões para as pastas do seu projeto
        # mude-as para adequar este Gruntfile para
        # a árvore de diretórios do seu projeto
        
        paths:
            assets: "assets/"
            coffee: "coffee/"
            build:  "build/assets/"
            fonts:  "fonts/"
            sass:   "sass/"
            img:    "img/"
            css:    "css/"
            js:     "js/"

        # a tarefa "watch" dispara outras tarefas quando certos arquivos são alterados
        watch:
            options:
                nospawn: true
                livereload: false
            
            compass:
                files: ['<%= paths.assets %><%= paths.sass %>**/*.{scss,sass}']
                tasks: ['compass', 'notify:compass']
            
            coffee:
                files: '<%= paths.assets %><%= paths.coffee %>**/*.coffee'
                tasks: ['coffee', 'notify:coffee']

        # TESTE: tarefa para injetar css e sincronizar browsers
        # a tarefa em si ainda está em desenvolvimento
        # Para utilizá-la, inclua os arquivos pedidos utilizando o seguinte código
        # (testado apenas na plataforma OS X, possivelmente)
        ###
        $ifconfig = shell_exec('ifconfig');
        preg_match('/(inet\s((\d{3})\.(\d{3})\.(\d)\.(.*))\snetmask)/', $ifconfig, $matches);
        if (isset($matches[2]) && !empty($matches[2])){
            $serverIP = $matches[2];
            <script src="http://<?php echo $serverIP ?>:3000/socket.io/socket.io.js" ></script>
            <script src="http://<?php echo $serverIP ?>:3001/browser-sync-client.min.js" ></script>
        }
        ###
        #
        # o Browser Sync analisa arquivos e atualiza os arquivos dinâmicamente, em todos os dispositivos conectados
        #
        # você pode acessar seu site através de http://seu-ip:3002/ em qualquer dispositivo e eles ficarão sincronizados
        browser_sync:
            files: [
                '<%= paths.build %><%= paths.css %>**/*.css',
                '<%= paths.build %><%= paths.img %>**/*.{png,jpg,gif}',
                '<%= paths.build %><%= paths.js %>**/*.js',
                '**/*.ctp',
                '**/*.php'
            ]
            options:

                # para ser utilizado com a task watch (também deve ser executado antes)
                # a task default já roda as duas tarefas na sequência correta, basta executar no terminal:
                # grunt
                #
                watchTask: true

                # INCRÍVEL, mas experimental. Sincroniza informações de scroll, navegação por links e completar forms
                ghostMode:
                    scroll: true
                    links: true
                    forms: true

        # tarefa para compilar CoffeeScript
        coffee:
            options:
                bare: true

            all:
                expand: true
                cwd: '<%= paths.assets %><%= paths.coffee %>'
                src: '**/*.coffee'
                dest: '<%= paths.assets %><%= paths.js %>'
                ext: '.js'

        # task para compilar sass usando compass
        # se você não está usando compass no seu projeto, veja grunt-contrib-sass e grunt-sass
        compass:
            dist:
                options:
                    sassDir: '<%= paths.assets %><%= paths.sass %>'
                    cssDir: '<%= paths.assets %><%= paths.css %>'
                    imagesDir: '<%= paths.assets %><%= paths.img %>'
                    fontsDir: '<%= paths.assets %><%= paths.fonts %>'
                    relativeAssets: true
                    raw: 'preferred_syntax = :sass\n'

        # Otimização avançada de imagens
        # para utilizá-la, instale o jpegMini (comprado pela Mkt na App Store),
        # o imageOptim (http://imageoptim.com/) e o imageAlpha (http://pngmini.com/)
        # ---
        # A otimização por esta task é bastante demorada, principalmente se o site
        # possui muitas imagens em alta-definição. Se você precisa de velocidade
        # para uma alteração, utilize a imagemin, faça o deploy e depois rode a imageoptim.
        imageoptim:
            all:
                options:
                    jpegMini: true,
                    imageAlpha: true,
                    quitAfter: true
                src: ['<%= paths.assets %><%= paths.img %>']

        # Otimização simples de imagens (sem dependências)
        # Evite utilizar. A tarefa imageoptim é superior.
        # Utilize apenas se você necessita de velocidade
        imagemin:
            dist:
                options:
                    optimizationLevel: 7
                    progressive: true

                files: [
                    expand: true
                    cwd: '<%= paths.assets %><%= paths.img %>'
                    src: '**/*.{png,jpg,gif}'
                    dest: '<%= paths.build %><%= paths.img %>'
                ]

        # Concatena e comprime scripts
        uglify:
            options:
                mangle: false

            my_target:
                files:
                    '<%= paths.build %><%= paths.js %>app.js': ['<%= paths.assets %><%= paths.js %>**/*.js', '!modernizr.min.js']

        # contatena e minifica stylesheets
        cssmin:
            minify:
                expand: true
                cwd: '<%= paths.assets %><%= paths.css %>'
                src: ['*.css']
                dest: '<%= paths.build %><%= paths.css %>'
                ext: '.css'

        # notificação para conclusão de tarefas
        notify:
            compass:
                options:
                    title: "Compass",
                    message: "Success"


            coffee:
                options:
                    title: "CoffeeScript",
                    message: "Success"


            image:
                options:
                    title: "Imagemin",
                    message: "Success"

            compile:
                options:
                    title: "Compile"
                    message: "Tarefa concluída"

            build:
                options:
                    title: "Build"
                    message: "Tarefa concluída"

            minify:
                options:
                    title: "Minify"
                    message: "Tarefa concluída"

        # Mantém a qualidade de código CoffeeScript. Veja http://www.coffeelint.org/
        coffeelint:
            options:
                arrow_spacing:
                    'level': 'error'
                max_line_length: 
                    'level': 'ignore'
                no_implicit_parens:
                    'level': 'error'
                no_trailing_semicolons:
                    'level': 'error'
                no_tabs:
                    'level': 'ignore'
                indentation:
                    'level': 'ignore'

            app: ['<%= paths.assets %><%= paths.coffee %>**/*.coffee']

    # registra nomes para conjutos de tarefas
    grunt.registerTask( 'compile', ['coffee', 'compass'] )
    grunt.registerTask( 'build', ['compile', 'imageoptim'] )
    grunt.registerTask( 'minify', ['uglify', 'cssmin'] )
    grunt.registerTask( 'default', ['browser_sync', 'watch'] )

    # Compilar apenas os scripts modificados
    grunt.event.on( 'watch', (action, filepath) ->
        if grunt.file.isMatch( grunt.config('watch.coffee.files'), filepath )
            filepath = filepath.replace( grunt.config('coffee.all.cwd'), '' )
            grunt.config( 'coffee.all.src', filepath )
    )
