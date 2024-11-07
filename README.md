# CheckoutWithSpecialOffer

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

     iex> CheckoutWithSpecialOffer.add_product(["GR1","GR1"])
        {:ok,
          %{
            total_price: "£3.11",
            cart_item: [%{price: 3.11, product: "Green tea", product_code: "GR1", quantity: 2}]
           }
        }
     iex> CheckoutWithSpecialOffer.add_product([])
       {:ok, %{cart_item: [], total_price: "£0.0"}}
     
     iex> CheckoutWithSpecialOffer.add_product(1)
       {:error, "Invalid product details"}
     

     iex> CheckoutWithSpecialOffer.add_product(%{})
       {:error, "Invalid product details"}

     iex> CheckoutWithSpecialOffer.add_product(nil)
       {:error, "Invalid product details"}

     iex> CheckoutWithSpecialOffer.add_product(:data)
       {:error, "Invalid product details"}
     
     iex> CheckoutWithSpecialOffer.add_product([])
     {:ok, %{cart_item: [], total_price: "£0.0"}}
     

