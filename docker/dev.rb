require 'pry'

args = ARGV.dup

project_name = "learnsched"
compose_command = "docker-compose -f docker/docker-compose.yml -p #{project_name}"
run_command = "#{compose_command} run --rm"

sub_command = args.shift
args_rest = args.join(' ')

cmd = run_command.dup

case sub_command
when "setup" then
  cmds = []
  cmds << "#{run_command} web bundle install"
  cmds << "#{run_command} web bundle exec rails db:migrate"
  cmd = cmds.join(' && ')
when "server", "s" then cmd += " -p 80:80 web bundle exec rails s -b 0.0.0.0 -p 80 #{args_rest}"
when "console", "c" then cmd += " web bundle exec rails c #{args_rest}"
when "bundle-install", "bi" then cmd += " web bundle install #{args_rest}"
when "bundle-update", "bu" then cmd += " web bundle update #{args_rest}"
when "bundle-exec", "be" then cmd += " web bundle exec #{args_rest}"
when "psql" then cmd += " postgresql_services psql #{args_rest}"
when "pg_dump" then cmd += " postgresql_services pg_dump #{args_rest}"
when "stop" then cmd = "#{compose_command} stop"
when "docker-run", "dr" then cmd += " #{args_rest}"
else
  puts <<-TEXT
  Helper script for accessing rails commands inside of docker containers
  USAGE: ruby dev.rb [COMMAND] [arguments]
  Available commands:
    server | s               - starts rails server
    console | c              - starts rails console
    bundle-install | bi      - runs: bundle install [arguments]
    bundle-update | bu       - runs: bundle update [arguments]
    bundle-exec | be         - runs: bundle exec [arguments]
    psql                     - starts psql console
    stop                     - stops all containers in docker-compose
    docker-run | dr          - runs docker command in docker-compose context
  TEXT
  exit 1
end

STDERR.puts "Executing: #{cmd}"
exec(cmd)
