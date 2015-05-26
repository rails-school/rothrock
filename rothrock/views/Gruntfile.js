module.exports = function (grunt) {
    'use strict';

    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-sass');
    grunt.loadNpmTasks('grunt-contrib-watch');

    // Project configuration
    grunt.initConfig({
        coffee: {
            joinedBuild: {
                options: {
                    bare: true
                },
                files: {
                    'js/rothrock.js': [
                        'coffee/class_list.coffee',
                        'coffee/main.coffee'
                    ]
                }
            }
        },
        sass: {
            dist: {
                options: {
                    sourcemap: 'none'
                },
                files: {
                    'css/rothrock.css': 'sass/class_list.scss'
                }
            }
        },
        watch: {
            coffee: {
                files: 'coffee/*.coffee',
                tasks: [ 'coffee:joinedBuild' ],
                options: {
                    interrupt: true,
                    atBegin: true
                }
            },
            sass: {
                files: 'sass/**/*.scss',
                tasks: [ 'sass' ],
                options: {
                    interrupt: true,
                    atBegin: true
                }
            }
        }
    });

    // Default task
    grunt.registerTask('default', [
        'coffee:joinedBuild',
        'sass'
    ]);
};

