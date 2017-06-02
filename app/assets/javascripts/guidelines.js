$(document).ready(function() {
    var index = 0;
    // var popper;

    var instance = new Tooltip(document.getElementsByClassName("input-amount")[0], {
        html: true,
        title: "Suggested",
        trigger: "none",
        placement: "bottom",
        referenceOffsets: '100px'
    });

    instance.hide();

    $('#transaction_amount').on('keyup', function () {
        if (this.value) {
            instance.show();
        }

        $('.amount-of-kudos').html(this.value);

        $.get("/kudo_guidelines?kudo_amount=" + this.value, function (data) {
            var list = $('.tooltip-inner').empty();
            var listMore = $('<p>Guideline suggestions</p>').addClass('suggested-guidelines-title');
            listMore.appendTo(list);
            for (var i = 0; i < data.length; i++) {
                var listItem = $('<li>');
                var listName = $('<span/>').text(data[i][0]).addClass('g-name');
                var listValue = $('<span/>').text(data[i][1]).addClass('g-value');

                listName.appendTo(listItem);
                listValue.appendTo(listItem);
                listItem.appendTo(list);
            }

            if (data.length === 0) {
                var listZero = $('<li>No suggestions available at this value</li>');
                listZero.appendTo(list)
            }
        })
    });

    $('#transaction_amount').keyup(function(){
        if (!this.value) {
            instance.hide()
        }
    });

    $('#transaction_amount').focusout(function(){
        instance.hide()
    });

});

