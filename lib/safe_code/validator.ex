defmodule SafeCode.Validator do
  alias SafeCode.HeexParser
  alias SafeCode.Parser

  def validate!(str) when is_binary(str) do
    str
    |> Parser.parse_string()
    |> validate_quoted()
  end

  def validate_heex!(heex) when is_binary(heex) do
    heex
    |> HeexParser.parse_template()
    |> validate_quoted()
  end

  @spec validate_quoted(Macro.t()) :: true | no_return()
  defp validate_quoted(quoted) do
    Macro.prewalk(quoted, &validate_node/1)
  end

  defp validate_node(val) do
    if valid_node?(val) do
      val
    else
      raise "invalid_node:\n\n#{Macro.to_string(val)}\n\nast:\n#{inspect(val)}"
    end
  end

  defp valid_node?(atom) when is_atom(atom), do: true
  defp valid_node?(int) when is_integer(int), do: true
  defp valid_node?(binary) when is_binary(binary), do: true
  defp valid_node?(list) when is_list(list), do: true
  defp valid_node?({_, _}), do: true

  defp valid_node?({_, _, nil}), do: true
  defp valid_node?({variable, _, scope}) when is_atom(variable) and is_atom(scope), do: true
  defp valid_node?({{_, _, _}, _, _}), do: true
  defp valid_node?({:., _, [{:__aliases__, _, module_list}, func]}), do: valid_module_function?(Module.concat(module_list), func)
  defp valid_node?({:., _, [module, func]}), do: valid_module_function?(module, func)

  defp valid_node?({function, _meta, args}) when is_atom(function) and is_list(args) do
    valid_function?(function)
  end

  defp valid_node?(_), do: false

  defp valid_function?(:+), do: true
  defp valid_function?(:*), do: true
  defp valid_function?(:=), do: true
  defp valid_function?(:fn), do: true
  defp valid_function?(:case), do: true
  defp valid_function?(:do), do: true
  defp valid_function?(:when), do: true
  defp valid_function?(:%{}), do: true
  defp valid_function?(:%), do: true
  defp valid_function?(:->), do: true
  defp valid_function?(:__block__), do: true
  defp valid_function?(:__aliases__), do: true
  defp valid_function?(:require), do: true
  defp valid_function?(:for), do: true
  defp valid_function?(:<-), do: true

  defp valid_function?(_), do: false

  defp valid_module_function?(Phoenix.LiveView.Engine, :live_to_iodata), do: true
  defp valid_module_function?(Enum, :map), do: true

  defp valid_module_function?(_, _), do: false
end
