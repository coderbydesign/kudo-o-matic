$(document).ready(function () {
    // Open emoji modal
    $('.fa-smile-o').click(function () {
        $('.emoji-modal').addClass('show-modal');
        $('.emoji-modal-background').addClass('visible-as-modal');
        return false
    });

    // Close emoji modal
    $('.close-emoji').click(function () {
        $('.emoji-modal').removeClass('show-modal');
        $('.clipboard-emoji').removeClass('show-clipboard');
        $('.emoji-modal-background').removeClass('visible-as-modal');
        $('.character-count').focus();
    });

    $(document).keyup(function(e) {
        if (e.keyCode === 27) { // esc
            $('.emoji-modal').removeClass('show-modal');
            $('.clipboard-emoji').removeClass('show-clipboard');
            $('.emoji-modal-background').removeClass('visible-as-modal');
            $('.character-count').focus();
        }
    });

    $('.emoji-modal-background').click(function () {
        $('.emoji-modal').removeClass('show-modal');
        $('.emoji-modal-background').removeClass('visible-as-modal')
    });

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