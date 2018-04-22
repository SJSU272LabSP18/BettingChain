module.exports = function(grunt) {
    grunt.loadNpmTasks('grunt-shell');
    grunt.loadNpmTasks('grunt-ssh');
    grunt.loadNpmTasks('grunt-replace');
    grunt.loadNpmTasks('grunt-gitinfo');

    var home = grunt.option("blockchain_lottery_home") || __dirname ;
    grunt.initConfig({
        gitinfo: {
            commands: {
                'my.custom.command': ['describe','--always']
            }
        },
        shell: {
            build: {
                command: [
                    'echo <%= secret.password %> | sudo -S whoami'
                ].join('&&')
            },
            build_docker_image: {
                command: [
                    'echo <%= secret.password %> | sudo -S whoami',
                    'cd ' + home,
                    'sudo docker build --tag="gshivani08/blockchain-lottery:<%= gitinfo.my.custom.command %>" .',
                    'sudo docker build --tag="gshivani08/blockchain-lottery:<%= gitinfo.my.custom.command %>" .'
                ].join('&&'),
                options: {
                    execOptions: {
                        maxBuffer: Infinity
                    }
                }
            },
            push_docker_image: {
                command: [
                    'echo <%= secret.password %> | sudo -S whoami',
                    'echo "docker.devops"|sudo docker login',
                    'sudo docker push gshivani08/blockchain-lottery:<%= gitinfo.my.custom.command %>',
                    'echo "docker.devops"|sudo docker login',
                    'sudo docker push gshivani08/blockchain-lottery:<%= gitinfo.my.custom.command %>'
                ].join('&&')
            }
        },
        // Pass file name as argument to call this task e.g grunt --config qa shell
        secret: grunt.file.readJSON(grunt.option("config")+'.json'),
        sshexec: {
            //Placeholder for future
        }
    });
    grunt.registerTask('buildAll', ['gitinfo','shell:build_docker_image','shell:push_docker_image']);
}