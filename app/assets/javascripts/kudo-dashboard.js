$(document).ready(function () {
    $('.see-more').click(function () {
        $('.kudo-counter-background').css("display","block");
        $('.kudo-counter').css("display","block");

    });

    $('.fa-times').click(function () {
        $('.kudo-counter').css("display","none");
        $('.kudo-counter-background').css("display","none");
    });
});