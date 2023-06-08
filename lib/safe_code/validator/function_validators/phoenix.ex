defmodule SafeCode.Validator.FunctionValidators.Phoenix do
  @behaviour SafeCode.Validator.FunctionValidators.Behaviour

  def safe_function?(_), do: false

  def safe_module_function?(Phoenix.LiveView.Engine, :live_to_iodata), do: true
  def safe_module_function?(Phoenix.LiveView.Engine, :changed_assign?), do: true
  def safe_module_function?(Phoenix.LiveView.Engine, :fetch_assign!), do: true
  def safe_module_function?(Phoenix.LiveView.Engine, :nested_changed_assign?), do: true
  def safe_module_function?(Phoenix.LiveView.Engine, :to_component_dynamic), do: true
  def safe_module_function?(Phoenix.LiveView.Engine, :to_component_static), do: true
  def safe_module_function?(Phoenix.LiveView.Comprehension, :__annotate__), do: true
  def safe_module_function?(Phoenix.LiveView.HTMLEngine, :binary_encode), do: true
  def safe_module_function?(Phoenix.LiveView.TagEngine, :binary_encode), do: true
  def safe_module_function?(Phoenix.LiveView.TagEngine, :class_attribute_encode), do: true
  def safe_module_function?(Phoenix.LiveView.TagEngine, :component), do: true
  def safe_module_function?(Phoenix.LiveView.TagEngine, :link), do: true
  def safe_module_function?(Phoenix.LiveView.TagEngine, :inner_block), do: true
  def safe_module_function?(Phoenix.LiveView.TagEngine, :function), do: true
  def safe_module_function?(Phoenix.LiveView.TagEngine, :file), do: true
  def safe_module_function?(Phoenix.HTML, :attributes_escape), do: true
  def safe_module_function?(:assigns, _), do: true
  def safe_module_function?("assigns." <> _, _), do: true

  def safe_module_function?(_, _), do: false
end
