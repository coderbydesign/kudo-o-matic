$(document).ready(function () {
    // Dropdown profile toggle show/hide
    $('.current-user').click(function () {
        var innerWidth = $('.current-user').innerWidth();
        var innerWidthMobile = $('.profile-picture-mobile').innerWidth();
        $('.dropdown-content').toggleClass('slide-menu');
        $('.drop-menu .menu-tooltip').toggleClass('show-tooltip');

        if ($(window).width() > 720) {
            $('.dropdown-content').css({width: innerWidth - 50});
        } else {
            $('.dropdown-content').css({width: innerWidthMobile / 2});
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