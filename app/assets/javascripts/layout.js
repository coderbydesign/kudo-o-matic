$(document).ready(function () {
    $(window).scroll(fadeBackToTopButtonInAndOut);
    $('.back-to-top').click(scrollToTopWithSmoothAnimation);

    function fadeBackToTopButtonInAndOut() {
        if ($(this).scrollTop() > 100) {
            $('.back-to-top').fadeIn();
        } else {
            $('.back-to-top').fadeOut();
        }
    }

    function scrollToTopWithSmoothAnimation() {
        $('html, body').animate({scrollTop: 0}, 800);
    }
});