$(document).ready(function() {
    $('.suggested-guidelines-container').hide();

    $('#transaction_amount').on('keyup', function () {
        if (this.value) {
            $('.suggested-guidelines-container').slideDown(250);
        }

        $('.amount-of-kudos').html(this.value);

        $.get("/kudo_guidelines?kudo_amount=" + this.value, function (data) {
            $(".suggested-guidelines").html(data);
            $('.suggested-guidelines').each(function () {
                // debugger
                var $this = $(this);
                for (var i = 0; i < data.length; i++) {
                    data[i] = wrap_activity_in_li(data[i])
                }
                $this.html($('<table>').html(data));
            });
        })
    });

    function wrap_activity_in_li(activity){
        return activity = '<tr><th class="guideline">' + activity[0] + '<th class="highlighted">' +  activity[1] + '</th>' +'</th></tr>';
    }

    $('#transaction_amount').keyup(function(){
        if (!this.value) {
            $('.suggested-guidelines-container').slideUp(250);
        }
    });
});