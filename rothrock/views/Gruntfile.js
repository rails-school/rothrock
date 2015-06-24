module.exports = function (grunt) {
    'use strict';

    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-coffeelint');
    grunt.loadNpmTasks('grunt-contrib-jade');
    grunt.loadNpmTasks('grunt-contrib-sass');
    grunt.loadNpmTasks('grunt-scss-lint');
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
                    'js/rothrock.js': [
                        'coffee/components/slider.coffee',
                        'coffee/components/share_menu.coffee',
                        'coffee/controllers/base_controller.coffee',
                        'coffee/controllers/class_list_controller.coffee',
                        'coffee/controllers/single_class_controller.coffee',
                        'coffee/controllers/settings_controller.coffee',
                        'coffee/main.coffee'
                    ]
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
        jade: {
            dist: {
                options: {
                    pretty: true
                },
                files: {
                    "html/main.html": ['jade/main.jade'],
                    "html/settings.html": ['jade/settings.jade'],
                    "html/single_class.html": ['jade/single_class.jade']
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
            dist: {
                options: {
                    colorizeOutput: true,
                    config: 'config/scsslint-default.yml',
                    force: true
                },
                files: {
                    src: ['sass/*.scss']
                }
            }
        },
        watch: {
            coffee: {
                files: 'coffee/**/*.coffee',
                tasks: ['coffeelint', 'coffee'],
                options: {
                    interrupt: true,
                    atBegin: true
                }
            },
            jade: {
                files: 'jade/**/*.jade',
                tasks: ['jade'],
                options: {
                    interrupt: true,
                    atBegin: true
                }
            },
            sass: {
                files: 'sass/**/*.scss',
                //tasks: ['scsslint', 'sass'],
                tasks: ['sass'],
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
        'jade',
        'scsslint',
        'sass'
    ]);

    grunt.registerTask('fast', [
        'coffee',
        'jade',
        'sass'
    ]);
};

