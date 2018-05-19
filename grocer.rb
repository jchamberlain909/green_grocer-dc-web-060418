require "pry"

def consolidate_cart(cart)
  # code here
  consolidated_cart =  {}
  cart.each do |e|
    if !consolidated_cart.has_key?(e.keys[0])
      consolidated_cart[e.keys[0]] = e[e.keys[0]]
      consolidated_cart[e.keys[0]][:count] = 1
    else
      consolidated_cart[e.keys[0]][:count]=consolidated_cart[e.keys[0]][:count]+ 1
    end
  end
  consolidated_cart
end

def apply_coupons(cart, coupons)
  # code here
  coupons.each do |coupon|
    item_name = coupon[:item]
    if !!cart[item_name]
      #Coupon applies to item in cart
      if cart[item_name][:count]%coupon[:num] ==0
        #Coupon divides evenly into cart
        cart[item_name+" W/COUPON"] = {:price => coupon[:cost],
           :clearance => cart[item_name][:clearance],
           :count => cart[item_name][:count]/coupon[:num].floor
         }
        cart[item_name][:count] = 0
      elsif cart[item_name][:count]/coupon[:num] >= 1
        #Coupon does not divide evenly but still applies
        cart[item_name+" W/COUPON"] = {:price => coupon[:cost],
           :clearance => cart[item_name][:clearance],
           :count => cart[item_name][:count]/coupon[:num].floor
         }
        cart[item_name][:count] = cart[item_name][:count]%coupon[:num]
      end
    end
  end
  cart
end

def apply_clearance(cart)
  # code here
  cart.each do |item, item_details|
    if item_details[:clearance]
      cart[item][:price] = (cart[item][:price] * 0.8).round(2)
    end
  end
end

def checkout(cart, coupons)
  # code here
  total_cost = 0
  apply_clearance(apply_coupons(consolidate_cart(cart),coupons)).each do |item, item_data|
    total_cost+=item_data[:price] * item_data[:count]
  end

  if total_cost > 100
    return (total_cost * 0.9).round(2)

  else
    return total_cost.round(2)
  end

end
