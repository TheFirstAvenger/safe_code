defmodule SafeCode.Validator.FunctionValidators.Phoenix do
  @behaviour SafeCode.Validator.FunctionValidators.Behaviour

  def safe_function?(:my_component), do: true
  def safe_function?(:rem), do: true
  def safe_function?(:&), do: true
  def safe_function?(:/), do: true
  def safe_function?(:{}), do: true
  def safe_function?(_), do: false

  def safe_module_function?(DockYardWeb.EmployeeView, :random_avatar_uri), do: true
  def safe_module_function?(DockYardWeb.EmployeeView, :display_name), do: true
  def safe_module_function?(DockYardWeb.PostView, :illustration), do: true
  def safe_module_function?(DockYardWeb.PostView, :post_path), do: true
  def safe_module_function?(DockYardWeb.PostView, :author_avatar_url), do: true
  def safe_module_function?(DockYard.ClientLeads, :change_client_lead_form), do: true
  def safe_module_function?(Phoenix.LiveView.Engine, :live_to_iodata), do: true
  def safe_module_function?(Phoenix.LiveView.Engine, :changed_assign?), do: true
  def safe_module_function?(Phoenix.LiveView.Engine, :fetch_assign!), do: true
  def safe_module_function?(Phoenix.LiveView.Engine, :nested_changed_assign?), do: true
  def safe_module_function?(Phoenix.LiveView.Engine, :to_component_static), do: true
  def safe_module_function?(Phoenix.LiveView.HTMLEngine, :binary_encode), do: true
  def safe_module_function?(Phoenix.LiveView.HTMLEngine, :component), do: true
  def safe_module_function?(Phoenix.LiveView.HTMLEngine, :function), do: true
  def safe_module_function?(Phoenix.LiveView.HTMLEngine, :file), do: true
  def safe_module_function?(Phoenix.LiveView.HTMLEngine, :inner_block), do: true
  def safe_module_function?(Phoenix.HTML, :attributes_escape), do: true
  def safe_module_function?(:assigns, _), do: true

  def safe_module_function?(_, _), do: false

  # def safe_module_function?(module, function) do
  #  IO.inspect("module: #{inspect(module)}")
  #  IO.inspect("function: #{function}")
  #  true
  # end
end
