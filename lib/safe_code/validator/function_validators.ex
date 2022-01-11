defmodule SafeCode.Validator.FunctionValidators do
  require Logger

  def safe_function?(function, opts) do
    Logger.debug("safe_function?(#{inspect(function)}, #{inspect(opts)})")

    [SafeCode.Validator.FunctionValidators.Elixir | extra_function_validators(opts)]
    |> Enum.reduce_while(false, fn module, _ ->
      if module.safe_function?(function) do
        {:halt, true}
      else
        {:cont, false}
      end
    end)
  end

  def safe_module_function?(module, function, opts) do
    Logger.debug("safe_module_function?(#{inspect(module)}, #{inspect(function)}, #{inspect(opts)})")

    [SafeCode.Validator.FunctionValidators.Elixir | extra_function_validators(opts)]
    |> Enum.reduce_while(false, fn validator_module, _ ->
      if validator_module.safe_module_function?(module, function) do
        {:halt, true}
      else
        {:cont, false}
      end
    end)
  end

  defp extra_function_validators(opts) do
    extra_function_validators = Keyword.get(opts, :extra_function_validators, [])

    case extra_function_validators do
      atom when is_atom(atom) -> [atom]
      list when is_list(list) -> list
      other -> raise "extra_function_validators must be a list, got #{inspect(other)}"
    end
  end
end
