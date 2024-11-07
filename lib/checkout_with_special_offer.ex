defmodule CheckoutWithSpecialOffer do
  @moduledoc """
  The module adds products to a cart and displays the total price.
  with special conditions:

  ● The CEO is a big fan of buy-one-get-one-free offers and of green tea. He wants us to add a
  rule to do this.

  ● The COO, though, likes low prices and wants people buying strawberries to get a price
  discount for bulk purchases. If you buy 3 or more strawberries, the price should drop to £4.50
  per strawberry.

  ● The CTO is a coffee addict. If you buy 3 or more coffees, the price of all coffees should drop
  to two thirds of the original price.

  Also, Our check-out can scan items in any order, and because the CEO and COO change their minds often,
  it needs to be flexible regarding our pricing rules.

  """

  @doc ~S"""
  Parses the given `line` into a command.

  ## Examples

      iex> CheckoutWithSpecialOffer.add_product("GR1,SR1,GR1,GR1,CF1")
      {:ok,
      %{ total_price: "£22.45",
        cart_item: [
        %{price: 11.23, product: "Coffee", product_code: "CF1", quantity: 1},
        %{price: 6.22, product: "Green tea", product_code: "GR1", quantity: 3},
        %{price: 5.0, product: "Strawberries", product_code: "SR1", quantity: 1}
        ]
        }
      }

      iex> CheckoutWithSpecialOffer.add_product(["GR1","SR1","GR1","GR1","CF1"])
      {:ok,
       %{ total_price: "£22.45",
          cart_item: [
           %{price: 11.23, product: "Coffee", product_code: "CF1", quantity: 1},
           %{price: 6.22, product: "Green tea", product_code: "GR1", quantity: 3},
           %{price: 5.0, product: "Strawberries", product_code: "SR1", quantity: 1}
         ]
         }
       }

  Wrong arguments return an error:

       iex> CheckoutWithSpecialOffer.add_product(nil)
       {:error, "Invalid product details"}

  """

  @type product_code() :: String.t() | list(String.t())
  @discount_amount_for_strawbarries 0.50

  # Return Cart items and Total price of the cart items
  @spec add_product(String.t() | list(String.t())) :: {:ok, String.t()} | {:error, String.t()}
  def add_product(product_code) when is_binary(product_code) do
    product_details =
      product_code
      |> String.trim()
      |> String.split(",")
      |> get_product_details()

    total_price = calculate_total_price(product_details)

    {:ok, %{cart_item: product_details, total_price: "£#{total_price}"}}
  end

  def add_product(product_code) when is_list(product_code) do
    product_details = get_product_details(product_code)

    total_price = calculate_total_price(product_details)

    {:ok, %{cart_item: product_details, total_price: "£#{total_price}"}}
  end

  def add_product(_), do: {:error, "Invalid product details"}

  # Return total price of the cart items
  @spec calculate_total_price(list(String.t())) :: float()
  defp calculate_total_price(products) do
    Enum.reduce(products, 0.0, fn product, value -> Float.round(product.price + value, 2) end)
  end

  # Get and Returns list of product details by product_code with
  # discounted price if conditions are meants else original price is use

  @spec get_product_details(list(String.t())) :: list(map())
  defp get_product_details(product_codes) do
    product_codes
    |> Enum.filter(fn product_code ->
      Enum.find(products(), &(&1.product_code == product_code))
    end)
    |> Enum.frequencies()
    |> Enum.map(fn {product_code, quantity} -> add_product_to_cart(product_code, quantity) end)
  end

  # Get and Returns product details by product_code with discounted price
  # if conditions are meants else original price is use

  @spec add_product_to_cart(String.t(), pos_integer()) :: float()
  def add_product_to_cart(product_code, quantity) do
    product = Enum.find(products(), &(&1.product_code == product_code))

    %{
      product: product.name,
      product_code: product.product_code,
      quantity: quantity,
      price: check_for_special_offer(product_code, quantity, product.price)
    }
  end

  # Pattern match and Check special offer for product code and calculating price discount
  # for the offer based on ordered quantity

  @spec check_for_special_offer(String.t(), pos_integer(), float()) :: float()
  defp check_for_special_offer("GR1", order_quantity, price) when order_quantity >= 2 do
    (order_quantity - 1) * price
  end

  defp check_for_special_offer("SR1", order_quantity, price) when order_quantity >= 3 do
    order_quantity * (price - @discount_amount_for_strawbarries)
  end

  defp check_for_special_offer("CF1", order_quantity, price) when order_quantity >= 3 do
    original_price = order_quantity * price
    original_price * 2 / 3
  end

  defp check_for_special_offer(_, order_quantity, price) do
    order_quantity * price
  end

  # Returns list of test products registered

  @spec products() :: list(map())
  defp products do
    [
      %{product_code: "GR1", name: "Green tea", price: 3.11},
      %{product_code: "SR1", name: "Strawberries", price: 5.00},
      %{product_code: "CF1", name: "Coffee", price: 11.23}
    ]
  end
end
