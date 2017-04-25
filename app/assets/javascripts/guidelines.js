$(document).ready(function(){
    $('.col-md-7').hide();
    $('#transaction_amount').on('keyup', function(){
        $('.guidelines_static').hide();
        $('.col-md-7').fadeIn(1000);
        console.log('test', this.value);
        $('#amount_of_kudo_clone').html(this.value);

        $.get("/kudo_guidelines?kudo_amount=" + this.value, function (data) {
            var list = $('.guidelines_container').empty();

            for (var i = 0; i < data.length; i++) {
                var listItem = $('<li>').text(data[i][0]);
                var listValue = $('<span/>').text(data[i][1]);

                listValue.appendTo(listItem);
                listItem.appendTo(list);
            }
        })
    });

    $('#transaction_amount').keyup(function(){
        if (!this.value) {
            $('.col-md-7').hide();
            $('.guidelines_static').show();
        }
    });

    // $("input").focus(function() {    // $("input").focus(function() {
    //     console.log("focus test ")
    //     $("header, .bottomouterwrapper").css({
    //         filter: "blur(5px)",
    //         transition: "100ms -webkit-filter linear"
    //     });
    //     $(".col-md-5").css({
    //
    //     });
    //
    //     $(".topinnerwrapper").css({height:"400px;"});
    //
    //     $("input").focusout(function() {
    //         console.log("focus out test")
    //        // $("header, .bottomouterwrapper").end()
    //             cancelBlur();
    //         });
    //     });
    //
    // $(window).scroll(function() {
    //     if ($(this).scrollTop()>10)
    //     {
    //         cancelBlur();
    //     }
    // });
    //
    // function focusOut(){
    // }
    //
    // function cancelBlur() {
    //     $("header, .bottomouterwrapper").css({
    //         filter: "",
    //         transition: "100ms -webkit-filter linear"
    //     });
    // }
    //     console.log("focus test ")
    //     $("header, .bottomouterwrapper").css({
    //         filter: "blur(5px)",
    //         transition: "100ms -webkit-filter linear"
    //     });
    //     $(".col-md-5").css({
    //
    //     });
    //
    //     $(".topinnerwrapper").css({height:"400px;"});
    //
    //     $("input").focusout(function() {
    //         console.log("focus out test")
    //        // $("header, .bottomouterwrapper").end()
    //             cancelBlur();
    //         });
    //     });
    //
    // $(window).scroll(function() {
    //     if ($(this).scrollTop()>10)
    //     {
    //         cancelBlur();
    //     }
    // });
    //
    // function focusOut(){
    // }
    //
    // function cancelBlur() {
    //     $("header, .bottomouterwrapper").css({
    //         filter: "",
    //         transition: "100ms -webkit-filter linear"
    //     });
    // }

 $('.close-new-visitor-show').click(function(){
        $('.new-visitor-show').fadeOut(500);
    });

});



