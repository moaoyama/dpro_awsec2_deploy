app_path = "/var/www/cdp_web_web_aws_deploy_task/current"
shared_path = "/var/www/cdp_web_web_aws_deploy_task/shared"
worker_processes 2
working_directory app_path

pid "#{shared_path}/tmp/pids/unicorn.pid"
listen "/var/www/cdp_web_web_aws_deploy_task/shared/tmp/sockets/unicorn.sock", backlog: 64
stderr_path "#{shared_path}/log/unicorn.stderr.log"
stdout_path "#{shared_path}/log/unicorn.stdout.log"

timeout 60
preload_app true

before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |_server, _worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
