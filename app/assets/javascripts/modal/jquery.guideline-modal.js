$(document).ready(function () {
    // Open guideline modal
    $('.btn-guideline-info').click(function () {
        $('.guideline-modal').addClass('show-modal');
        return false
    });

    // Close guideline modal
    $('.close-guidelines').click(function () {
        $('.guideline-modal').removeClass('show-modal');
        $('.clipboard-guideline').removeClass('show-clipboard');
    });

    // Clipboard
    var guideline = document.getElementsByClassName('guideline-list');
    new Clipboard(guideline);

    $('.guideline-list').click(function () {
        $('.clipboard-guideline').removeClass('show-clipboard');
        setTimeout(function () {
            $('.clipboard-guideline').addClass('show-clipboard');
        }, 0)
    });
});