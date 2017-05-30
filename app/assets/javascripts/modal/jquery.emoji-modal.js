$(document).ready(function () {
    // Open emoji modal
    $('.fa-smile-o').click(function () {
        $('.emoji-modal').addClass('show-modal');
        return false
    });

    // Close emoji modal
    $('.close-emoji').click(function () {
        $('.emoji-modal').removeClass('show-modal');
        $('.clipboard-emoji').removeClass('show-clipboard');
        $('.character-count').focus();
    });

    $(document).keyup(function(e) {
        if (e.keyCode === 27) { // esc
            $('.emoji-modal').removeClass('show-modal');
            $('.clipboard-emoji').removeClass('show-clipboard');
            $('.character-count').focus();
        }
    });

    // Clipboard
    var smiley = document.getElementsByClassName('emoji-container');
    var clipboard = new Clipboard(smiley);
    //
    // clipboard.on('success', function(e) {
    //     if ($('.character-count').val().length + (e.text).length < 90) {
    //         $('.clipboard-emoji').html("Added: '" + e.text + "'");
    //         $('.character-count').append(e.text + " ");
    //         console.log((e.text).length);
    //         console.log($('.character-count').val().length)
    //     } else {
    //         $('.clipboard-emoji').html("Max. characters reached, can't copy");
    //     }
    // });

    $('.emoji-container').click(function () {
        var target = $(this).closest('.emoji-container');
        var emojiName = target.data('clipboard');

        var activityLength = $('.textarea-field').val().length;
        var emojiLength = (emojiName).length;
        var totalLength = activityLength + emojiLength;

        var $clipboardEmoji = $('.clipboard-emoji');
        var $textareaField = $('.textarea-field');

        if (totalLength < 90) {
            $clipboardEmoji.html("Added: '" + emojiName + "'");
            $textareaField.val($('.textarea-field').val() + emojiName + ' ');
        } else {
            $clipboardEmoji.html("Max. characters reached, can't copy");
        }
    });



    $('.emoji-container').click(function () {
        $('.clipboard-emoji').removeClass('show-clipboard');
        setTimeout(function () {
            $('.clipboard-emoji').addClass('show-clipboard');
        }, 0)
    });
});