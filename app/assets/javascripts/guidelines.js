// window.onload = function(){
//     console.log('test');
//
//     $.get("/kudo_guidelines", function(data){
//         console.log("getting guidelines", data);
//     })
//
//
// };

$(document).ready(function(){
    $('#transaction_amount').on('keyup', function(){
        console.log('test', this.value);
        $('#amount_of_kudo_clone').html(this.value);
        $.get("/kudo_guidelines?kudo_amount=" + this.value, function(data){
            console.log("getting guidelines", data);
            $(".guidelines_container").html(data);
            $('.guidelines_container').each(function() {
               // debugger
                var $this = $(this);
                for (var i = 0; i < data.length; i++) {
                    data[i] = wrap_activity_in_li(data[i])
                }
                $this.html($('<ul>').html(data));
            });
        })
    })
    function wrap_activity_in_li(activity){
       return activity = '<li>' + activity + '</li>';
    }
})







