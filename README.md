# kinedu api test - backend

##Requirements

* ruby
* rails
* mysql2
* bundler

## Setup

1. Run bundler to install project dependencies.

1. Get master.key

1. Create `config/database.yml` based on `config/database.yml.example` to match your local settings.

1. Create database.

    ```sh
    $ rake db:create
    ```

1. Load db schema.

    ```sh
    $ rake db:schema:load
    ```

## Run

1. Run application server.

    ```sh
    $ rails s -b your.ip
    ```

## Testing

The application uses rspec for testing.

To run all tests use the following command.

```sh
$ rspec
```

To run a specific file of tests use the following command.

```sh
$ rspec path/to/file_spec.rb
```

To run a specific test in a file use the following command. Change the number to the line of the first line of the test block.

```sh
$ rspec path/to/file_spec.rb:15
```

