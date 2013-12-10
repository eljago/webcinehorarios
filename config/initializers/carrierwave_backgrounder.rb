CarrierWave::Backgrounder.configure do |c|
  # c.backend :delayed_job, queue: :carrierwave
  # c.backend :resque, queue: :carrierwave
  c.backend :sidekiq, queue: :carrierwave, size: 5
  # c.backend :girl_friday, queue: :carrierwave
  # c.backend :qu, queue: :carrierwave
  # c.backend :qc
end
