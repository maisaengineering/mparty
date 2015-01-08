# config/initializers/delayed_job_config.rb
Delayed::Worker.destroy_failed_jobs = false # The failed jobs will be marked with non-null failed_at
#Delayed::Worker.sleep_delay = 60
Delayed::Worker.max_attempts = 3 # default 25 attempts
Delayed::Worker.max_run_time = 59.minutes # default 5 minutes
#Delayed::Worker.read_ahead = 10
Delayed::Worker.default_queue_name = 'default'
#Delayed::Worker.delay_jobs = !Rails.env.test?
#Delayed::Worker.raise_signal_exceptions = :term
#Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))