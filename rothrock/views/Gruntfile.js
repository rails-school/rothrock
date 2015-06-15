module.exports = function (grunt) {
    'use strict';

    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-coffeelint');
    grunt.loadNpmTasks('grunt-contrib-jade');
    grunt.loadNpmTasks('grunt-contrib-sass');
    grunt.loadNpmTasks('grunt-contrib-sasslint');
    grunt.loadNpmTasks('grunt-contrib-watch');

    // Project configuration
    grunt.initConfig({
        coffee: {
            dist: {
                options: {
                    bare: true,
                    join: true
                },
                files: {
                    'js/rothrock.js': 'coffee/*.coffee'
                }
            }
        },
        coffeelint: {
            dist: {
                options: {
                    configFile: 'config/coffeelint-default.json'
                },
                files: {
                    src: ['coffee/*.coffee']
                }
            }
        },
        sass: {
            dist: {
                options: {
                    sourcemap: 'none'
                },
                files: {
                    'css/rothrock.css': 'sass/rothrock.scss'
                }
            }
        },
        scsslint: {
            options: {
                config: 'config/scsslint-default.json'
            },
            dist: {
                allFiles: ['sass/*.scss']
            }
        },
        watch: {
            coffee: {
                files: 'coffee/*.coffee',
                tasks: ['coffeelint', 'coffee'],
                options: {
                    interrupt: true,
                    atBegin: true
                }
            },
            sass: {
                files: 'sass/**/*.scss',
                tasks: ['scsslint', 'sass'],
                options: {
                    interrupt: true,
                    atBegin: true
                }
            }
        }
    });

    // Default task
    grunt.registerTask('default', [
        'coffeelint',
        'coffee',
        'scsslint',
        'sass'
    ]);

    grunt.registerTask('fast', [
        'coffee',
        'sass'
    ]);
};

