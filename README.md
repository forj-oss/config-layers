# ConfigLayers

ConfigLayers is a library which help to manage a complex configuration hierarchy, (Hash of Hashes/Array/...) 
per layers.

* What kind of complexity are we trying to resolve?

  If you are using yaml or json, you can write anything in that format in some configuration file.
  Ex: 

      :global:
        :url: http://url.example.org
        :options: 
          :timeout: 60
          :port: 4708
      :application
        :publish: [ help, about, main, go ]

  When you load this yaml, you are going to get a Hash containing hash/array/string/... etc...
  then, when you want to access :timeout, you access it like that:

      timeout = data[:global][:options][:timeout]

  If your data has this Hash of Hash of Hash, loaded in memory, then you get the data.
  But you need to manage the exception or do some test for each Hash, otherwise you get a
  nil exception.

  ConfigLayers simplify this:

  - access ':timeout' :
    
      config = PRC::BaseConfig.new(data)

      timeout = config[:global, :options, :timeout]

    No need to add any test.

  - set ':timeout' :

      config[:global, :options, :timeout] = 60

    No need to create the Hash structure to set the ':timeout'

  ConfigLayer embed YAML, so you can load and save this data from/to a yaml file...
  
      config.save(filename)
      config.load(filename)

  You can check the key existence as well!

      if config.exist?(:global, :options, :timeout)
         <do things>
      end

* What is that layer notion in ConfigLayers?

  If you have an application which has some predefine default, a system config, a user config
  and an account config, you may want to get a consolidated environment that you want to use.

  if we are back in the previous ':timeout' example, let's say that :
  - application default for timeout is. 60
  - the system config has no timeout data.
  - the user config has 120
  - and the user load an account file that also has a timeout to 90

  If the application run, with the account data loaded, when the application wants to get the timeout data

  you expect to just read it! But you need to check if found in account, use it, otherwise check in user 
  config, etc... until the application defaults if none of those previous configuration file has the :timeout
  setting...

  Here with ConfigLayers, you create a class based on CoreConfig and you define those layers.
  then you just access you data!

  Ex: This is a real simple example.

      # We define layers
      class MyConfigApp < PRC::CoreConfig
        def initialize(files)
          config_layers = []

          # Application default layer
          config_layers << define_default_layer

          # runtime Config layer
          config_layers << define_layer('system', files[0])

          # User Config layer
          config_layers << define_layer('user', files[1])

          # Account config layer
          config_layers << define_layer('account', files[2]))

          initialize_layers(config_layers)
        end
        
        def define_layer(name, filename)
          config = PRC::BaseConfig.new()
          config.load(filename)
          PRC::CoreConfig.define_layer(:name => name,
                                   :config   => config,
                                   :file_set => true,
                                   :load     => true, :save     => true)
        end

        def define_default_layer
          config = PRC.BaseConfig()
          config[:global, :options, :timeout] = 60
          PRC::CoreConfig.define_layer(:name => 'default',
                                   :config   => config)
        end
     end

     # Using my ConfigLayers
     files = ['/etc/myapp.yaml', '~/.myapp.yaml', '~/.conf/account/myaccount.yaml']
     config = MyConfigApp.new(files)

     [...]

     puts config[:global, :options, :timeout]


  As you saw, we define the layer, load or set it, assign a name and declare in a new class
  and just use that class...

You can do strongly more.

You can define you own layer, you can redefine how your access data.
For example, you can ignore some layers...

You can get a full consolidated data, with merge!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'config_layers'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install config_layers

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/config_layers/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
