image_preview = function(input){
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function (e) {
            var img= new Image();
            img.src =  e.target.result;
            //$(input).siblings('#img-preview').html(img);
            $(".profile_photo_icon").hide()
            $(input).siblings('#img-preview').html(img)
        }
        reader.readAsDataURL(input.files[0]);
    }
}
