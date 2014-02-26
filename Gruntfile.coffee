module.exports = (grunt) ->

    # Carrega todas as tarefas
    require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

    grunt.initConfig

        # Caminhos padrões para as pastas do seu projeto
        # Adeque-a para a estruturação que você utiliza

        paths:
            assets: 'assets/'
            coffee: 'coffee/'
            build:  'build/assets/'
            fonts:  'fonts/'
            sass:   'sass/'
            img:    'img/'
            css:    'css/'
            js:     'js/'

        # Tarefa Watch: dispara outras tarefas quando certos arquivos são alterados
        watch:
            options:
                nospawn: true
                livereload: false

            compass:
                files: ['<%= paths.assets %><%= paths.sass %>**/*.{scss,sass}']
                tasks: ['compass']

            coffee:
                files: '<%= paths.assets %><%= paths.coffee %>**/*.coffee'
                tasks: ['coffee']

        # Tarefa Browser-sync: sincroniza navegação e alterações em assets
        browser_sync:
            files: [
                '<%= paths.build %><%= paths.css %>**/*.css',
                '<%= paths.build %><%= paths.img %>**/*.{png,jpg,gif}',
                '<%= paths.build %><%= paths.js %>**/*.js',
                '**/*.ctp',
                '**/*.php'
            ]
            options:
                watchTask: true

                ghostMode:
                    scroll: true
                    links: true
                    forms: true
                    clicks: true

        # Tarefa Coffee: compila arquivos CoffeeScript
        coffee:
            options:
                bare: true

            all:
                expand: true
                cwd: '<%= paths.assets %><%= paths.coffee %>'
                src: '**/*.coffee'
                dest: '<%= paths.assets %><%= paths.js %>'
                ext: '.js'

        # Tarefa Compass: compila arquivos sass usando o plugin compass
        # Necessita ter o sass e o compass instalados na sua máquina
        compass:
            dist:
                options:
                    sassDir: '<%= paths.assets %><%= paths.sass %>'
                    cssDir: '<%= paths.build %><%= paths.css %>'
                    imagesDir: '<%= paths.assets %><%= paths.img %>'
                    fontsDir: '<%= paths.assets %><%= paths.fonts %>'
                    relativeAssets: true
                    raw: 'preferred_syntax = :sass\n'

        # Tarefa Imageoptim: otimização avançada de imagens
        imageoptim:
            all:
                options:
                    jpegMini: true,
                    imageAlpha: true,
                    quitAfter: true
                src: ['<%= paths.assets %><%= paths.img %>']

        # Tarefa Imagemin: otimização simples de imagens
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

        # Tarefa Uglify: concatena e comprime scripts
        uglify:
            options:
                mangle: false

            my_target:
                files:
                    '<%= paths.build %><%= paths.js %>app.js': ['<%= paths.assets %><%= paths.js %>**/*.js', '!modernizr.min.js']

        # Tarefa Cssmin: contatena e minifica stylesheets
        cssmin:
            minify:
                expand: true
                cwd: '<%= paths.assets %><%= paths.css %>'
                src: ['*.css']
                dest: '<%= paths.build %><%= paths.css %>'
                ext: '.css'

        # Tarefa Coffeelint: mantém a qualidade do código CoffeeScript
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

    # registro de nomes para conjuntos de tarefas
    grunt.registerTask( 'compile', ['coffee', 'compass'] )
    grunt.registerTask( 'build', ['compile', 'imageoptim'] )
    grunt.registerTask( 'minify', ['uglify', 'cssmin'] )

    # excutada ao digitar apenas `grunt` na linha de comando
    grunt.registerTask( 'default', ['browser_sync', 'watch'] )

    # compilar apenas os scripts modificados
    grunt.event.on( 'watch', (action, filepath) ->
        if grunt.file.isMatch( grunt.config('watch.coffee.files'), filepath )
            filepath = filepath.replace( grunt.config('coffee.all.cwd'), '' )
            grunt.config( 'coffee.all.src', filepath )
    )
