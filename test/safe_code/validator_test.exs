defmodule SafeCode.ValidatorTest do
  use ExUnit.Case

  alias SafeCode.Validator
  alias SafeCode.Validator.InvalidNode

  describe "validate/1" do
    test "add" do
      str = """
      1 + 1
      """

      assert Validator.validate!(str)
    end

    test "Enum.map" do
      str = """
      Enum.map([1, 2, 3], fn x -> x * x end)
      """

      assert Validator.validate!(str)
    end

    test "raises on problem function" do
      str = """
      System.cmd("touch", ["foo"])
      """

      assert_raise InvalidNode, "No validator approved safe_module_function?(System, :cmd)\n\nast:\n{:., [line: 1], [{:__aliases__, [line: 1], [:System]}, :cmd]}", fn ->
        Validator.validate!(str)
      end
    end
  end

  describe "validate_heex/1" do
    test "basic" do
      heex = """
      hello <%= 1 + 1 %> how <%= 2+2 %> are you
      """

      assert {:ok, _quoted} = Validator.validate_heex(heex)
    end

    test "for loop" do
      heex = """
      <%= for foo <- bar do %>
        <%= foo %>
      <% end %>
      """

      assert {:ok, _quoted} = Validator.validate_heex(heex)
    end

    test "return the error tuple when invalid template" do
      heex = """
      <div>
        hello <%= 1 + 1 %> how <%= 2+2 %> are you
      """

      assert {:error, %Phoenix.LiveView.HTMLTokenizer.ParseError{} = error} = Validator.validate_heex(heex)
      assert error.description == "end of template reached without closing tag for <div>"
    end

    test "return an error tuple on problem function" do
      str = """
      <%= System.cmd("touch", ["foo"]) %>
      """

      assert {:error, %InvalidNode{} = error} = Validator.validate_heex(str)
      assert error.message == "System . :cmd\n\nast:\n{:., [line: 1], [{:__aliases__, [line: 1], [:System]}, :cmd]}"
    end
  end

  describe "validate_heex!/1" do
    test "basic" do
      heex = """
      hello <%= 1 + 1 %> how <%= 2+2 %> are you
      """

      assert Validator.validate_heex!(heex)
    end

    test "for loop" do
      heex = """
      <%= for foo <- bar do %>
        <%= foo %>
      <% end %>
      """

      assert Validator.validate_heex!(heex)
    end

    test "raises on problem function" do
      str = """
      <%= System.cmd("touch", ["foo"]) %>
      """

      assert_raise InvalidNode, "No validator approved safe_module_function?(System, :cmd)\n\nast:\n{:., [line: 1], [{:__aliases__, [line: 1], [:System]}, :cmd]}", fn ->
        Validator.validate_heex!(str)
      end
    end
  end
end
