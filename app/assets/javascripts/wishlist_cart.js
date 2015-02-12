function addRemoveProductsFromWishlist(){
    $('.wishable_products .add_product_to_wishlist_btn').click(function (e){
        e.preventDefault()
        $this = $(this)

        if($(this).find('span').first().hasClass('add')){ // Add product to wishlist
            var url = '/event/'+$(this).data('event-id')+'/wishlist/add_product'
            var data = {variant_id: $(this).data('variant-id')}
            $.ajax({
                type: "POST",
                url: url,
                data: data,
                beforeSend: function(){  $('.loading-indicator').fadeIn('slow') },
                success: function(res) {
                    $this.removeClass('product_add_btn').addClass('product_added_btn')
                    $this.find('span:first').removeClass('glyphicon-plus add').addClass('glyphicon-ok remove');
                    $("#wishlist-count").text(parseInt($("#wishlist-count").text()) + 1);
                    $(".wishlist_modal_count").text(parseInt($(".wishlist_modal_count").text()) + 1)
                    $('.loading-indicator').hide()
                }
            });
        }else{ // Remove product from wishlist
            var url =  '/event/'+$(this).data('event-id')+'/wishlist/remove_product'
            var data = {"_method": 'delete',variant_id: $(this).data('variant-id')}
            $.ajax({
                type: "POST",
                url: url,
                data: data,
                beforeSend: function(){ $('.loading-indicator').fadeIn('slow') },
                success: function(res) {
                    $this.removeClass('product_added_btn').addClass('product_add_btn')
                    $this.find('span:first').removeClass('glyphicon-ok remove').addClass('glyphicon-plus add');
                    $("#wishlist-count").text(parseInt($("#wishlist-count").text()) - 1);
                    $(".wishlist_modal_count").text(parseInt($(".wishlist_modal_count").text()) - 1)
                    $('.loading-indicator').hide()
                }
            });
        }
        // alert($(this).parent('.product').attr('id'))
    })
}

$(function () {
    addRemoveProductsFromWishlist()
})
