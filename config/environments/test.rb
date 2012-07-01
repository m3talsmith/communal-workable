RebelFoundation::Application.configure do
  config.cache_classes = true
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=3600"
  config.whiny_nils = true
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = false
  config.action_controller.allow_forgery_protection    = false
  config.action_mailer.delivery_method = :test
  config.active_support.deprecation = :stderr
  config.assets.allow_debugging = true
end

Braintree::Configuration.environment = :sandbox
Braintree::Configuration.merchant_id = "dhw2g59byxb7qgj7"
Braintree::Configuration.public_key = "nj266fc95znkfnr5"
Braintree::Configuration.private_key = "zb847ftmbzvkf5zy"
