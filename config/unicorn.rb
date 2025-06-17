app_path = "/var/www/cdp_web_web_aws_deploy_task/current"

worker_processes 2
working_directory app_path

# ソケット通信
listen "#{app_path}/tmp/sockets/unicorn.sock", backlog: 64

# PID 管理ファイル
pid "#{app_path}/tmp/pids/unicorn.pid"

# ログ出力
stderr_path "#{app_path}/log/unicorn.stderr.log"
stdout_path "#{app_path}/log/unicorn.stdout.log"

# アプリの preload（メモリ効率を上げる）
preload_app true

timeout 60

before_fork do |server, worker|
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
