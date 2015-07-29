Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['913209035405243'], ENV['e9d249d26c4a6b9c36cf7331363362c6']
end