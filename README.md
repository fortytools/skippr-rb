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

    Skippr::Api.credentials = {
      client_name: "fortytools",                      # ATTENTION: This client name has to refer to the same skippr client as ...
      app_key: "awesome_skippr_app",
      app_token: "098172398723419887",
      client_user_api_key: "skippr_client_user_key", # ... the client_user_api_key does! You're gonna get an error response from skippr otherwise.
      client_user_api_token: "0987654321zonk"
    }

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


## TODO

- thread safety
- add dependencies to gemspec

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
