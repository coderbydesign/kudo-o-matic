$(document).ready(function() {
    // Checkbox icons toggle
    $('.filter-option').click(function () {
        $(this).find('i').toggleClass('fa-square-o fa-check-square-o')
    });

    // $('.filter-btn.click').click(function () {
    //     // $(this).find('filter-option').slideToggle();
    //     $(this).find('i').toggleClass('fa-chevron-right fa-chevron-left')
    // });

    $('.filter-option').click(function () {
        if ($('.filter-option.send i').hasClass('fa-check-square-o') && $('.filter-option.received i').hasClass('fa-check-square-o')) {
            $.ajax({
                type:'GET',
                url: "/dashboard.js?filter=mine", success: function (result) {
                }
            });
        } else if ($('.filter-option.send i').hasClass('fa-check-square-o')) {
            $.ajax({
                type:'GET',
                url: "/dashboard.js?filter=send", success: function (result) {
                }
            });
        } else if ($('.filter-option.received i').hasClass('fa-check-square-o')) {
            $.ajax({
                type:'GET',
                url: "/dashboard.js?filter=received", success: function (result) {
                }
            });
        } else {
            $.ajax({
                type:'GET',
                url: "/dashboard.js?filter=all", success: function (result) {
                }
            });
        }
    });
});