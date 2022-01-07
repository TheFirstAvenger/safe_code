# SafeCode

SafeCode is currently a very early stage project to answer the question "Is this code safe to load and run in an elixir application?". The immediate driving force is the potential need to answer this question in the [Beacon LiveView CMS](https://github.com/BeaconCMS/beacon). It also has potential to be used in other projects that load code dynamically such as [LiveBook](https://github.com/livebook-dev/livebook).

## Load code into a running application?

Yes! One of Elixirs many strengths is the ability to load modules on the fly via the [Code.compile_string](https://hexdocs.pm/elixir/1.12/Code.html#compile_string/2) function. However, with great power comes great responsibility. As noted in the function docs: "Warning: string can be any Elixir code and code can be executed with the same privileges as the Erlang VM: this means that such code could compromise the machine (for example by executing system commands). Don't use compile_string/2 with untrusted input (such as strings coming from the network)."

## What is safe?

One of the questions to answer as this project develops is "what is safe". While it is obvious that `System.cmd("rm", ["-rf", "/"])` is not safe, and `1 + 1` is safe, what about `IO.puts`? Could overloading logging be an attack vector? And what about non-tail recursion or simply running code that chews up cpu cycles? What about process communication? Can that be allowed safely? At the outset we are focusing on determining what simple code is safe (e.g. `Enum.map(vals, fn {x, y} -> x + y end)`), but the more advanced attack vectors are front of mind.

## Heex Templates

As [Beacon LiveView CMS](https://github.com/BeaconCMS/beacon) is an early potential use of SafeCode, we will out of the gate support validating both regular Elixir code and Heex templates. This will allow a user to define Beacon Components by entering the LiveComponent code via a web interface, and load that code into memory on a running system to be rendered on request.

## Allow list

This project is using an allow-list approach. We are parsing the code into AST and allowing

## Usage

The main entry points are `SafeCode.Validator.validate/1` and `SafeCode.Validator.validate_heex!/1`.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `safe_code` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:safe_code, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/safe_code>.

