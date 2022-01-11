defmodule SafeCode.Validator.FunctionValidators.Behaviour do
  @callback safe_function?(function_name :: atom()) :: boolean
  @callback safe_module_function?(module :: module(), function_name :: atom()) :: boolean
end
