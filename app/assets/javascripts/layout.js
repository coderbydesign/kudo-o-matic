$(document).ready(function () {

    function backToTop() {
        if (document.body.scrollTop > 300) {
            $('.back-to-top').addClass('show-button');
            $('.back-to-top').sticky({getWidthFrom: '.back-to-top' , topSpacing: 8});
        } else {
            $('.back-to-top').removeClass('show-button')
        }

    }

    backToTop();

    $(document).scroll(function () {
        backToTop()
    });

    $(document).resize(function () {
        backToTop()
    });

    $('.back-to-top').click(function () {
       $(document).scrollTop(0)
    });
});