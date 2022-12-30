# Rack attack tips

Repository https://github.com/duleorlovic/rack_attack_tips

This is example for using rack-attack gem https://github.com/rack/rack-attack
that prevents DOS attacks.

It will allow all requests from `safelist` and exit.
Otherwise it will ban all requests from `blocklist` and exit.
Otherwise it will check for throttle.

```
bundle add rack-attack

sed -i '' -e '/^  end$/i \
    config.middleware.use Rack::Attack' config/application.rb
```

Add sample page
```
rails g controller pages index test_throttle
```
Configure cache for test
```
# config/environments/test.rb
  if ENV["TEST_USING_CACHE"].present?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.cache_store = :memory_store
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end
```

Copy `config/initializers/rack_attack.rb` and add test like
`test/controllers/pages_controller_test.rb`

Since we can not run multiple tests with Rack::Attack enabled (it will be
throttled) we can run only single test for example
```
# we need `spring stop` since config/environments/test.rb is different
spring stop && TEST_USING_CACHE=true rails test test/controllers/pages_controller_test.rb -n test_throttle && spring stop
```
