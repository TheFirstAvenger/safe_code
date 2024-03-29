defmodule SafeCode.Validator.FunctionValidators.Elixir do
  @behaviour SafeCode.Validator.FunctionValidators.Behaviour

  def safe_function?(:+), do: true
  def safe_function?(:*), do: true
  def safe_function?(:=), do: true
  def safe_function?(:fn), do: true
  def safe_function?(:if), do: true
  def safe_function?(:case), do: true
  def safe_function?(:do), do: true
  def safe_function?(:when), do: true
  def safe_function?(:and), do: true
  def safe_function?(:or), do: true
  def safe_function?(:%{}), do: true
  def safe_function?(:%), do: true
  def safe_function?(:->), do: true
  def safe_function?(:__block__), do: true
  def safe_function?(:__aliases__), do: true
  def safe_function?(:require), do: true
  def safe_function?(:for), do: true
  def safe_function?(:<-), do: true
  def safe_function?(:==), do: true
  def safe_function?(:elem), do: true
  def safe_function?(:to_string), do: true
  def safe_function?(:<<>>), do: true
  def safe_function?(:<>), do: true
  def safe_function?(:"::"), do: true
  def safe_function?(:{}), do: true

  def safe_function?(_), do: false

  def safe_module_function?(Access, _), do: true
  def safe_module_function?(Calendar, _), do: true
  def safe_module_function?(Enum, _), do: true
  def safe_module_function?(Date, _), do: true
  def safe_module_function?(DateTime, _), do: true
  def safe_module_function?(Map, _), do: true

  def safe_module_function?(Kernel, fun), do: safe_function?(fun)
  def safe_module_function?(_, _), do: false
end
