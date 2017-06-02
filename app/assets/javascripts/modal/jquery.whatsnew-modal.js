$(document).ready(function () {
    $('.whatsnew').click(function () {
        $('.whatsnew-modal').addClass('show-modal');
        $('.whatsnew-modal-background').addClass('visible-as-modal')
        return false
    });

    $('.close-whatsnew').click(function () {
        $('.whatsnew-modal').removeClass('show-modal');
        $('.whatsnew-modal-background').removeClass('visible-as-modal')
    });

    $(document).keyup(function(e) {
        if (e.keyCode === 27) { // esc
            $('.whatsnew-modal').removeClass('show-modal');
            $('.whatsnew-modal-background').removeClass('visible-as-modal')
        }
    });

    $('.whatsnew-modal-background').click(function () {
        $('.whatsnew-modal').removeClass('show-modal');
        $('.whatsnew-modal-background').removeClass('visible-as-modal')
    });

    $('.clickable').click(function () {
        $('.not-visible', this).toggleClass('is-visible');
        $('i', this).toggleClass('fa-chevron-right fa-chevron-down')
    });
});