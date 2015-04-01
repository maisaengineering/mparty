Spree::BaseHelper.module_eval do
  def link_to_cart(text = nil)
    #text = text ? h(text) : Spree.t('cart')
    text =  "<span class='glyphicon glyphicon-shopping-cart glyphicon-flip'></span> "
    css_class = nil

    if simple_current_order.nil? or simple_current_order.item_count.zero?
      # text = "#{text}: (#{Spree.t('empty')})"
      # css_class = 'empty'
    else
      text = "#{text}:  <div class='cart-count'>#{simple_current_order.item_count}</div> <span class='amount'>#{simple_current_order.display_item_total.to_html}</span>".html_safe
      css_class = 'full'
      link_to text, spree.cart_path, :class => "cart-info btn btn-primary cart-btn-style #{css_class}",style: 'margin: 1px;'
    end
  end
end
