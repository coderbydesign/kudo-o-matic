$(document).ready(function () {

    $(document).click(function () {
        if ($('.transaction-dropdown').hasClass('is-visible')) {
            $('.transaction-dropdown').removeClass('is-visible');
        }
    });

    $(".transaction-actions").click(function(e){
        e.stopPropagation();
    });

    // Dropdown profile toggle show/hide
    $('.transaction-actions').click(function () {
        var data = $(this).attr('data-id');
        $('.transaction-dropdown[data-id = '+data+']').toggleClass('is-visible');
    });
});