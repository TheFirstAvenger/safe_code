defmodule SafeCode.Validator.FunctionValidators.Elixir do
  @behaviour SafeCode.Validator.FunctionValidators.Behaviour

  def safe_function?(:+), do: true
  def safe_function?(:*), do: true
  def safe_function?(:=), do: true
  def safe_function?(:fn), do: true
  def safe_function?(:case), do: true
  def safe_function?(:do), do: true
  def safe_function?(:when), do: true
  def safe_function?(:%{}), do: true
  def safe_function?(:%), do: true
  def safe_function?(:->), do: true
  def safe_function?(:__block__), do: true
  def safe_function?(:__aliases__), do: true
  def safe_function?(:require), do: true
  def safe_function?(:for), do: true
  def safe_function?(:<-), do: true
  def safe_function?(:elem), do: true

  def safe_function?(_), do: false

  def safe_module_function?(Enum, :map), do: true
  def safe_module_function?(Access, :get), do: true

  def safe_module_function?(_, _), do: false
end
