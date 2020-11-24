# Time Streamer

Explore the versions of your ActiveRecord models in the browser.

The web interface allows you to view models at different points in time based on versions from an auditing system. It also allows for traversing associations. Works with [Audited](https://github.com/collectiveidea/audited) and [PaperTrail](https://github.com/paper-trail-gem/paper_trail) by default.

## Installation

Not currently released as a gem.

## Usage

Mount Time Streamer inside your application

```ruby
# routes.rb
mount TimeStreamer::App, at: '/time_streamer'
```

Configure the gem to suit your needs. The following example shows the default configuration.

```ruby
# config/initializers/time_streamer.rb
TimeStreamer.configure do |config|
  config.adapter = TimeStreamer::Adapters::Audited.new
  config.global_ignored_associations = []
  config.ignored_associations = {}
  config.mount_path = '/time_streamer'
end
```

Ignore associations that should not be displayed. For example, the association containing the versions (`audits` for Audited and `versions` for PaperTrail) should probably be ignored.

To ignore associations for specific models, set the `ignored_associations` hash.

*IMPORTANT*: The associations have to be given as strings.
```ruby
TimeStreamer.configure do |config|
  config.global_ignored_associations = ['audits']
  config.ignored_associations = {
    'Customer' => ['product_ratings'],
    'Order' => ['products', 'discounts']
  }
end
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
