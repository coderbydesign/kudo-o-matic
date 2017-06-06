$(document).ready(function () {
    $('.btn-guideline-info').click(function(e) {
        e.preventDefault();
        $('body').css('overflow', 'hidden');
    });

    $('.close-guidelines').click(function(e) {
        e.preventDefault();
        $('body').css('overflow', 'auto');
    });

    // Open guideline modal
    $('.btn-guideline-info').click(function () {
        $('.guideline-modal').addClass('show-modal');
        $('.guideline-modal-background').addClass('visible-as-modal');
        return false
    });

    // Close guideline modal
    $('.close-guidelines').click(function () {
        $('.guideline-modal').removeClass('show-modal');
        $('.clipboard-guideline').removeClass('show-clipboard');
        $('.guideline-modal-background').removeClass('visible-as-modal');
    });

    $(document).keyup(function(e) {
        if (e.keyCode === 27) { // esc
            $('.guideline-modal').removeClass('show-modal');
            $('.clipboard-guideline').removeClass('show-clipboard');
            $('.guideline-modal-background').removeClass('visible-as-modal');
        }
    });

    $('.guideline-modal-background').click(function () {
        $('.guideline-modal').removeClass('show-modal');
        $('.guideline-modal-background').removeClass('visible-as-modal')
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