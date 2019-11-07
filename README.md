
# Nubank Authorizer Challenge

This is my attempt at the Authorizer app for ***Nubank***

## How to run
In order to run the application you don't need any external dependency outside of Ruby,

You can pass a file as `stdin`
```
$ ./authorizer < transactions
```

Or you can also run and paste the input

```
$ ./authorizer
{ "account": { "activeCard": true, "availableLimit": 100 } }
{ "account": { "activeCard": true, "availableLimit": 100 }, "violations": [] }
{ "transaction": { "merchant": "Burger King", "amount": 20, "time": "2019-02-13T10:00:00.000Z" } }
{ "account": { "activeCard": true, "availableLimit": 80 }, "violations": [] }
```

## How to run specs
Specs were written using the `rspec` gem, so in order to run the specs you need to install the gem by running `bundle install`, then run `rspec` and it should run the test suite.

## Implementation Details
The entry point for this application is the `authorizer` binary, it reads the `stdin` and pass it down to the `Authorizer` class, it takes the output from that and prints it to `stdout`.

The `Authorizer` class parses the JSON from the input and it sends it to the `Account` class, it keeps an instance of `Account` in memory for the run of the program.

The `Account` class handles the operations, it receives the parsed data from the input and checks for violations. If the operation is valid it applies to the current state.

The `Validation` module includes all the business logic rules that validate transactions and account.

The `Transaction` class is a wrapper to make it easier to deal with the transaction data and parsing times.
