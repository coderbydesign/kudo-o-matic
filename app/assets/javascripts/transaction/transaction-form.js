$(document).ready(function() {
    // Click submit button on form by hitting enter
    $('.textarea-field').keypress(function(event) {
        if (event.keyCode == 13 || event.which == 13) {
            $('#send-kudos-button').click();
            event.preventDefault();
        }
    });

    // Prevent submitting form by hitting enter
    $('.input-receiver, .input-amount').keydown(function(event){
        if(event.keyCode == 13) {
            event.preventDefault();
            return false;
        }
    });

    // Number of characters left in activity input field calculated
    var textMax = $('.character-count').attr('maxLength');
    $('.counter').html(textMax);

    $('.character-count').keyup(function() {
        $('.counter').addClass('show-counter');
        var textLength = $('.character-count').val().length;
        var textRemaining = textMax - textLength;
        $('.counter').html(textRemaining);
    });
});