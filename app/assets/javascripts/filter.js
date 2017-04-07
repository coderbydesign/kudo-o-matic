$(document).ready(function() {
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