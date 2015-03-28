remove_photo = function(input){
    var id = input
    var url = "/pictures/"+input
    bootbox.confirm("Are you sure?", function(result) {
        if(result == true)
        {
            $.ajax({
                url: url,
                type: "DELETE",
                success: function() {
                    p_count -=1
                }
            });
        }
    });
}