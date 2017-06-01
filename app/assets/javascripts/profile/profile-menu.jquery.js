$(document).ready(function () {
    // Dropdown profile toggle show/hide
    $('.current-user').click(function () {
        var innerWidth = $('.current-user').innerWidth();
        $('.dropdown-content').css({width: innerWidth})
        $(this).find('.fa').toggleClass('fa-chevron-down fa-chevron-up');
        $('.profile.dropdown-content').toggleClass('slide-menu');
        $('.drop-menu .menu-tooltip').toggleClass('show-tooltip');
        return false
    });

    $(window).resize(function () {
        var innerWidth = $('.current-user').innerWidth();
        $('.dropdown-content').css({width: innerWidth})
    });
});