# Skippr::Rb

Skippr api gem - this is WIP!

## Installation

Add this line to your application's Gemfile:

    gem 'skippr-rb'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install skippr-rb

## Usage

    Skippr::Api.configure({
      client_name: "fortytools",
      app_key: "awesome_skippr_app",
      app_token: "098172398723419887",
      client_user_api_key: "skippr_client_user_key",  # ATTENTION: has to refer to the same client as the 'client_name' does
      client_user_api_token: "0987654321zonk",
    })

    # The Endpoint is per default configured to be
    # https://skippr.com/api/v2
    # so in general you're done with the configuration above


    # But just in case you'd like to tweak this endpoint, then provide a conf hash with any of the following
    Skippr::Api.configure_endpoint({
      protocol: "http",
      domain: "skippr.local",
      port: 3030,
      path: '/superapi/v33/',         # path is always surrounded by '/'
      user: 'basicauthuser',          # if the api is protected by http basic auth
      password: 'basicauthpassword',  # if the api is protected by http basic auth
    })
    # that's for 'http://batzen.skippr.local:3030/superapi/v33/' with basic auth



    # Now use it in your models and controllers like follows:

    Skippr::Customer.all

    c = Skippr::Customer.new
    c.name = "fortytools gmbh"
    c.street = "Georgsplatz 10"
    c.zip = "20099"
    c.city = "Hamburg"
    c.customer_state_id = Skippr::CustomerState.all.select{|s| s.name == "Kunde"}.first
    c.save

    i = Skippr::Invoice.new
    i.date = Date.today
    i.customer_id = 4711
    i.line_items_attributes = [
      { title: "Development Gricker.com",
        quantity: 15,
        price: 1234,
        service_period_start: 5.days.ago,
        service_period_end: 4.days.ago,
        service_type_id: Skippr::ServiceType.all.first.id
      }
    ]
    i.save


## Thread safety
- The Skippr::Api and Skippr::Endpoint classes are thread safe. They do not store anything in class variables but in
  thread locals (the thread_container). Hence, you can use several threads using the code above with varying credentials
  and endpoints without interfering with each other.

## TODO

- add dependencies to gemspec

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
