$(document).ready(function () {
    // Hide notice message
    $('.close-message').click(function () {
        $(this).closest('.message-container').addClass('hide-message');
    });
});