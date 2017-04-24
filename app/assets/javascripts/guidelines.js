$(document).ready(function() {
    $('.suggested-guidelines-container').hide();

    $('#transaction_amount').on('keyup', function () {
        if (this.value) {
            $('.suggested-guidelines-container').slideDown(250);
        }

        $('.amount-of-kudos').html(this.value);

        $.get("/kudo_guidelines?kudo_amount=" + this.value, function (data) {
            var list = $('.suggested-guidelines').empty();

            for (var i = 0; i < data.length; i++) {
                var listItem = $('<li>')
                var listName = $('<span/>').text(data[i][0]).addClass('g-name highlighted');
                var listValue = $('<span/>').text(data[i][1]).addClass('g-value');

                listName.appendTo(listItem);
                listValue.appendTo(listItem);
                listItem.appendTo(list);
            }
        })
    });

    $('#transaction_amount').keyup(function(){
        if (!this.value) {
            $('.suggested-guidelines-container').slideUp(250);
        }
    });
});