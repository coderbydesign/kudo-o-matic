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
    });

    // Clipboard
    var smiley = document.getElementsByClassName('emoji-container');
    var clipboard = new Clipboard(smiley);

    clipboard.on('success', function(e) {
        $('.clipboard-emoji').html("Copied: '" + e.text +"'");
    });

    $('.emoji-container').click(function () {
        $('.clipboard-emoji').removeClass('show-clipboard');
        setTimeout(function () {
            $('.clipboard-emoji').addClass('show-clipboard');
        }, 0)
    });
});