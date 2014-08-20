var _ = require('lodash');

module.exports = function(grunt) {
    'use-strict';

    /* Initialize configuration
    -----------------------------------------------------*/

    require('load-grunt-tasks')(grunt);
    require('time-grunt')(grunt);

    // default config
    var config = {
        sourcemap: false,
        compass: false
    };

    // apply command line configuration
    _.forEach(grunt.option.flags(), function(option) {
        config[option] = grunt.option(option);
    });

    // default paths
    var paths = {
        assets: 'assets',
        build:  'assets',
        sass:   'sass',
        scss:   'scss',
        css:    'css',
        js:     'js',
        img:    'images',
        fonts:  'fonts'
    };

    /* Tasks
    -----------------------------------------------------*/

    var tasks = {};
    tasks.paths = paths;

    // Watch---------------------------
    // [TODO]: add support to compass
    // [TODO]: add support to coffee
    tasks.watch = {
        gruntfile: {
            files: ['./Gruntfile.js'],
            options: {
                reload: true
            }
        },

        stylesheets: {
            files: [
                '<%= paths.assets %>/<%= paths.scss %>/**/*.{scss,sass}',
                '<%= paths.assets %>/<%= paths.sass %>/**/*.{scss,sass}',
            ],
            tasks: ['sass', 'autoprefixer']
        }
    };

    // BrowserSync --------------------
    // [TODO]: configure proxy option
    tasks.browserSync = {
        dev: {
            bsFiles: {
                src: [
                    '<%= paths.build %>/<%= paths.css %>/**/*.css',
                    '<%= paths.build %>/<%= paths.img %>/**/*.{png,jpg,gif}',
                    '<%= paths.build %>/<%= paths.js %>/**/*.js',
                    '**/*.php'
                ]
            },
            options: {
                watchTask: true,
                ghostMode: {
                    location: true
                },
                debugInfo: false // silence is golden.
            }
        }
    };

    // Sass ---------------------------
    tasks.sass = {
        dev: {
            files: [
                {
                    expand: true,
                    cwd: '<%= paths.assets %>/<%= paths.scss %>/',
                    src: [
                        '**/*.scss'
                    ],
                    dest: '<%= paths.build %>/<%= paths.css %>',
                    ext: '.css',
                    extDot: 'last'
                },
                {
                    expand: true,
                    cwd: '<%= paths.assets %>/<%= paths.sass %>/',
                    src: [
                        '**/*.sass'
                    ],
                    dest: '<%= paths.build %>/<%= paths.css %>',
                    ext: '.css',
                    extDot: 'last'
                }
            ],
            options: {
                style: 'compressed',
                sourcemap: config.sourcemap,
                compass: config.compass
            }
        }
    };

    // Imagemin -----------------------
    tasks.imagemin = {
        dev: {
            files: [{
                expand: true,
                cwd: '<%= paths.assets %>/<%= paths.img %>',
                src: '**/*.{png,jpg,gif,svg}',
                dest: '<%= paths.build %>/<%= paths.img %>'
            }],
            options: {
                optimizationLevel: 7
            }
        }
    };

    // Autoprefixer -------------------
    tasks.autoprefixer = {
        options: {
            map: true,
            browsers: ['last 2 versions', 'ie 8', 'ie 9', '> 1%']
        },
        dev: {
            files: [{
                expand: true,
                cwd: '<%= paths.build %>/<%= paths.css %>/',
                src: [
                    '**/*.css'
                ],
                dest: '<%= paths.build %>/<%= paths.css %>',
                ext: '.css',
                extDot: 'last'
            }]
        }
    };

    // configures grunt
    grunt.initConfig(tasks);


    /* Group Tasks
    -----------------------------------------------------*/

    grunt.registerTask('default', [
        'browserSync',
        'watch'
    ]);

    grunt.registerTask('build', [
        'sass',
        'autoprefixer',
        'imagemin'
    ]);

};
