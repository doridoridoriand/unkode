
@coupon_data = {

  number_of_coupons: {
    "high": 3,
    "middle": 2,
    "low": 5
  },
  coupon_rank: {
    "high": 500,
    "middle": 200,
    "low": 100
  }

}



def calc(product_price_original)
  p @coupon_data[:number_of_coupons][:high]
  p @coupon_data.keys
  unless !(product_price_original > 1000)
    product_price_discount = product_price_original
    #while product_price_discount >= 0
      product_price_discount = product_price_original - @coupon_data[:coupon_rank][:high].to_i
    #end
      p product_price_discount
  end
end

calc(1001)
