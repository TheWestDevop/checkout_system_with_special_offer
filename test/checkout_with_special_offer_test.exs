defmodule CheckoutWithSpecialOfferTest do
  use ExUnit.Case
  doctest CheckoutWithSpecialOffer

  alias CheckoutWithSpecialOffer, as: Subject

  describe "(String) Success add_product/1" do
    test "Success for buy-one-get-one-free offers of green tea with other product" do
      assert {:ok, %{total_price: "£22.45"}} = Subject.add_product("GR1,SR1,GR1,GR1,CF1")

      # test for random order flexiblity
      assert {:ok, %{total_price: "£22.45"}} = Subject.add_product("CF1,GR1,SR1,GR1,GR1")
    end

    test "Success for buy-one-get-one-free offers of green tea only " do
      assert {:ok, %{total_price: "£3.11"}} = Subject.add_product("GR1,GR1")
    end

    test "No buy-one-get-one-free offers for green tea, for not meeting the requirements." do
      assert {:ok, %{total_price: "£19.34"}} = Subject.add_product("SR1,GR1,CF1")
    end

    test "Success for strawberries bulk purchases discount" do
      assert {:ok, %{total_price: "£16.61"}} = Subject.add_product("SR1,SR1,GR1,SR1")

      # test for random order flexiblity
      assert {:ok, %{total_price: "£16.61"}} = Subject.add_product("GR1,SR1,SR1,SR1")
    end

    test "No discount added for strawberries for not meeting the requirements." do
      assert {:ok, %{total_price: "£13.11"}} = Subject.add_product("SR1,SR1,GR1")
    end

    test "Success for coffees bulk purchases discount" do
      assert {:ok, %{total_price: "£30.57"}} = Subject.add_product("GR1,CF1,SR1,CF1,CF1")

      # test for random order flexiblity
      assert {:ok, %{total_price: "£30.57"}} = Subject.add_product("SR1,GR1,CF1,CF1,CF1")
    end

    test "No discount added for coffees for not meeting the requirements." do
      assert {:ok, %{total_price: "£35.57"}} = Subject.add_product("SR1,SR1,GR1,CF1,CF1")
    end
  end

  describe "(List) Success add_product/1" do
    test "Success for buy-one-get-one-free offers of green tea with other product" do
      assert {:ok, %{total_price: "£22.45"}} =
               Subject.add_product(["GR1", "SR1", "GR1", "GR1", "CF1"])

      # test for random order flexiblity
      assert {:ok, %{total_price: "£22.45"}} =
               Subject.add_product(["SR1", "GR1", "GR1", "GR1", "CF1"])
    end

    test "Success for buy-one-get-one-free offers of green tea only " do
      assert {:ok, %{total_price: "£3.11"}} = Subject.add_product(["GR1", "GR1"])
    end

    test "Success for strawberries bulk purchases discount" do
      assert {:ok, %{total_price: "£16.61"}} = Subject.add_product(["SR1", "SR1", "GR1", "SR1"])

      # test for random order flexiblity
      assert {:ok, %{total_price: "£16.61"}} = Subject.add_product(["SR1", "SR1", "SR1", "GR1"])
    end

    test "Success for coffees bulk purchases discount" do
      assert {:ok, %{total_price: "£30.57"}} =
               Subject.add_product(["GR1", "CF1", "SR1", "CF1", "CF1"])

      # test for random order flexiblity
      assert {:ok, %{total_price: "£30.57"}} =
               Subject.add_product(["CF1", "SR1", "CF1", "CF1", "GR1"])
    end

    test "Success filter out invalid product code added" do
      assert {:ok, %{total_price: "£27.45"}} =
               Subject.add_product(["AR1", "GF1", "SR1", "CF1", "GR1", "GR1", "SR1", "GR1"])
    end
  end

  describe "Error add_product/1" do
    test "nil value passed as parameter" do
      assert {:error, "Invalid product details"} = Subject.add_product(nil)
    end

    test "atom value passed as parameter" do
      assert {:error, "Invalid product details"} = Subject.add_product(:ok)
    end
  end
end
