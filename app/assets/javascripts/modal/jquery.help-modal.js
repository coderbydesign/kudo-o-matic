$(document).ready(function () {
    $('.help-me').click(function () {
        $('.help-modal').addClass('show-modal');
        $('.help-modal-background').addClass('visible-as-modal')
        return false
    });

    $('.close-help').click(function () {
        $('.help-modal').removeClass('show-modal');
        $('.help-modal-background').removeClass('visible-as-modal')
    });

    $(document).keyup(function(e) {
        if (e.keyCode === 27) { // esc
            $('.help-modal').removeClass('show-modal');
            $('.help-modal-background').removeClass('visible-as-modal')
        }
    });

    $('.help-modal-background').click(function () {
        $('.help-modal').removeClass('show-modal');
        $('.help-modal-background').removeClass('visible-as-modal')
    });


});