$(document).ready(function () {
    // Dropdown profile toggle show/hide
    $('.current-user').click(function () {
        var innerWidth = $('.current-user').innerWidth();
        $('.dropdown-content').toggleClass('slide-menu');
        $('.drop-menu .menu-tooltip').toggleClass('show-tooltip');

        if ($(window).width() > 720) {
            $('.dropdown-content').css({width: innerWidth});
        } else {
            $('.dropdown-content').css({width: 'fit-content'});
        }
        return false
    });

    $(window).resize(function () {
        var innerWidth = $('.current-user').innerWidth();
        if ($(window).width() > 720) {
            $('.dropdown-content').css({width: innerWidth});
        } else {
            $('.dropdown-content').css({width: 'fit-content'});
        }
    });

    $(window).click(function () {
        $('.dropdown-content').removeClass('slide-menu');
        $('.drop-menu .menu-tooltip').removeClass('show-tooltip');
    });
});