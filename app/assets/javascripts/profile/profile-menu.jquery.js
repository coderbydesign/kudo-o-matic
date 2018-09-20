$(document).ready(function () {

    $(document).click(function () {
        if ($('.profile-dropdown').hasClass('is-visible')) {
            $('.profile-dropdown').removeClass('is-visible');
        }
    });

    $(".profile-username").click(function(e){
        e.stopPropagation();
    });

    $(".profile-icon-mobile").click(function(e){
        e.stopPropagation();
    });

    $(".profile-dropdown").click(function(e){
        e.stopPropagation();
    });

    // Dropdown profile toggle show/hide
    $('.profile-menu .profile-username').click(function () {
        $('.profile-dropdown').toggleClass('is-visible');
    });

    // Dropdown profile toggle show/hide
    $('.profile-menu .profile-icon-mobile').click(function () {
        $('.profile-dropdown').toggleClass('is-visible');
    });
});