defmodule SafeCode.Validator do
  alias SafeCode.HeexParser
  alias SafeCode.Parser
  alias SafeCode.Validator.FunctionValidators

  require Logger

  defmodule InvalidNode do
    defexception [:message]

    @impl Exception
    def exception({val, last_check}) do
      message = """
      No validator approved #{last_check}

      ast:
      #{inspect(val)}
      """

      %InvalidNode{message: String.trim(message)}
    end
  end

  def validate!(str, opts \\ []) when is_binary(str) do
    str
    |> Parser.parse_string()
    |> validate_quoted(opts)
  end

  @spec validate_heex(binary, keyword) :: {:ok, ast :: Macro.t()} | {:error, Exception.t()}
  def validate_heex(heex, opts \\ []) when is_binary(heex) do
    quoted =
      heex
      |> HeexParser.parse_template()
      |> validate_quoted(include_phoenix(opts))

    {:ok, quoted}
  rescue
    error -> {:error, error}
  end

  def validate_heex!(heex, opts \\ []) when is_binary(heex) do
    heex
    |> HeexParser.parse_template()
    |> validate_quoted(include_phoenix(opts))
  end

  defp include_phoenix(opts) do
    Keyword.update(opts, :extra_function_validators, [SafeCode.Validator.FunctionValidators.Phoenix], fn
      atom when is_atom(atom) -> [SafeCode.Validator.FunctionValidators.Phoenix, atom]
      list when is_list(list) -> [SafeCode.Validator.FunctionValidators.Phoenix | list]
    end)
  end

  defp validate_quoted(quoted, opts) do
    Macro.prewalk(quoted, &validate_node(&1, opts))
  end

  defp validate_node(val, opts) do
    Logger.debug("validate_node?(#{inspect(val)})")

    Process.put(:safe_code_last_check, "validate_node?(#{inspect(val)})")

    if valid_node?(val, opts) do
      val
    else
      raise InvalidNode, {val, Process.get(:safe_code_last_check)}
    end
  end

  defp valid_node?(atom, _opts) when is_atom(atom), do: true
  defp valid_node?(int, _opts) when is_integer(int), do: true
  defp valid_node?(binary, _opts) when is_binary(binary), do: true
  defp valid_node?(list, _opts) when is_list(list), do: true
  defp valid_node?({_, _}, _opts), do: true

  defp valid_node?({_, _, nil}, _opts), do: true
  defp valid_node?({variable, _, scope}, _opts) when is_atom(variable) and is_atom(scope), do: true
  defp valid_node?({{_, _, _}, _, _}, _opts), do: true
  defp valid_node?({:., _, [{:__aliases__, _, module_list}, func]}, opts), do: safe_module_function?(Module.concat(module_list), func, opts)
  defp valid_node?({:., _, [{{:., _, [{:__aliases__, _, module_list}, func]}, _, _}, _]}, opts), do: safe_module_function?(Module.concat(module_list), func, opts)
  defp valid_node?({:., _, [{{:., _, [{module, _, _}, func]}, _, _}, _]}, opts), do: safe_module_function?(module, func, opts)
  defp valid_node?({:., _, [{:__ENV__, _, module}, func]}, opts) when is_atom(module), do: safe_module_function?(module, func, opts)
  defp valid_node?({:., _, [{module, _, _}, func]}, opts), do: safe_module_function?(module, func, opts)
  defp valid_node?({:., _, [module, func]}, opts) when is_atom(module), do: safe_module_function?(module, func, opts)
  defp valid_node?({:&, _, [{:/, _, [{func, _, module}, _]}]}, opts) when is_atom(module), do: safe_module_function?(module, func, opts)
  defp valid_node?({:/, _, [{func, _, module}, _]}, opts) when is_atom(module), do: safe_module_function?(module, func, opts)
  defp valid_node?({:<<>>, _, _}, _opts), do: true
  defp valid_node?({:"::", _, _}, _opts), do: true
  defp valid_node?({:<>, _, _}, _opts), do: true
  defp valid_node?({:{}, _, _}, _opts), do: true

  defp valid_node?({function, _meta, args}, opts) when is_atom(function) and is_list(args) do
    FunctionValidators.safe_function?(function, opts)
  end

  defp valid_node?(_, _opts), do: false

  defp safe_module_function?({:., _, [{module, _, _}, function1]}, function2, opts) do
    safe_module_function?(module, function1, opts) and safe_module_function?(Enum.join([to_module(module), function1], "."), function2, opts)
  end

  defp safe_module_function?(module, function, opts), do: FunctionValidators.safe_module_function?(module, function, opts)

  defp to_module({:., _, [{:__aliases__, _, module_list}, function]}), do: Enum.join([Module.concat(module_list), function], ".")
  defp to_module({:., _, [{module, _, _}, function]}), do: Enum.join([to_module(module), function], ".")
  defp to_module(module) when is_atom(module), do: module
end
