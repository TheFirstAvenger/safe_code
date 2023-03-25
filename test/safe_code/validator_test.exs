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

      assert_raise InvalidNode, "System . :cmd\n\nast:\n{:., [line: 1], [{:__aliases__, [line: 1], [:System]}, :cmd]}", fn ->
        Validator.validate!(str)
      end
    end
  end

  describe "validate_heex/1" do
    test "basic" do
      heex = """
      hello <%= 1 + 1 %> how <%= 2+2 %> are you
      """

      assert Validator.validate_heex!(heex)
    end

    test "accepts the 'not' expression" do
      heex = """
      hello <%= not false %> how are you
      """

      assert Validator.validate_heex!(heex)
    end

    test "accepts the '||' expression" do
      heex = """
      hello <%= nil || true %> how are you
      """

      assert Validator.validate_heex!(heex)
    end

    test "accepts the '&&' expression" do
      heex = """
      hello <%= 1 && true %> how are you
      """

      assert Validator.validate_heex!(heex)
    end

    test "accepts the '!' expression" do
      heex = """
      hello <%= !false %> how are you
      """

      assert Validator.validate_heex!(heex)
    end

    test "accepts the '==' expression" do
      heex = """
      hello <%= 1 == 1 %> how are you
      """

      assert Validator.validate_heex!(heex)
    end

    test "accepts the '===' expression" do
      heex = """
      hello <%= 1 === 1 %> how are you
      """

      assert Validator.validate_heex!(heex)
    end

    test "accepts the '!==' expression" do
      heex = """
      hello <%= 1 !== 2 %> how are you
      """

      assert Validator.validate_heex!(heex)
    end

    test "accepts the '!=' expression" do
      heex = """
      hello <%= 1 != 2 %> how are you
      """

      assert Validator.validate_heex!(heex)
    end

    test "accepts the '<' expression" do
      heex = """
      hello <%= 1 < 5 %> how are you
      """

      assert Validator.validate_heex!(heex)
    end

    test "accepts the '>' expression" do
      heex = """
      hello <%= 1 > 5 %> how are you
      """

      assert Validator.validate_heex!(heex)
    end

    test "accepts the '>=' expression" do
      heex = """
      hello <%= 5 >= 1 %> how are you
      """

      assert Validator.validate_heex!(heex)
    end

    test "accepts the '<=' expression" do
      heex = """
      hello <%= 1 <= 5 %> how are you
      """

      assert Validator.validate_heex!(heex)
    end

    test "accepts the 'or' expression" do
      heex = """
      hello <%= false or true %> how are you
      """

      assert Validator.validate_heex!(heex)
    end

    test "accepts the 'and' expression" do
      heex = """
      hello <%= true and true %> how are you
      """

      assert Validator.validate_heex!(heex)
    end

    test "accepts the '<>' expression" do
      heex = """
      hello <%= "Steve" <> "Rogers" %> how are you
      """

      assert Validator.validate_heex!(heex)
    end

    test "accepts the '++' expression" do
      heex = """
      hello <%= [1,2] ++ [3,4] %> how are you
      """

      assert Validator.validate_heex!(heex)
    end

    test "accepts the '--' expression" do
      heex = """
      hello <%= [1,2,3] -- [2] %> how are you
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

      assert_raise InvalidNode, "System . :cmd\n\nast:\n{:., [line: 1], [{:__aliases__, [line: 1], [:System]}, :cmd]}", fn ->
        Validator.validate_heex!(str)
      end
    end
  end
end
