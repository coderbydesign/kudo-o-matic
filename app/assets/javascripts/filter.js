$(document).ready(function() {
    // Checkbox icons toggle
    $('.filter-option').click(function () {
        $(this).find('i').toggleClass('fa-square-o fa-check-square-o')
    });

    $('.filter-option').click(function () {
        if ($('.filter-option.send i').hasClass('fa-check-square-o') && $('.filter-option.received i').hasClass('fa-check-square-o')) {
            $.ajax({
                type:'GET',
                url: "/transactions.js?filter=mine", success: function (result) {
                }
            });
        } else if ($('.filter-option.send i').hasClass('fa-check-square-o')) {
            $.ajax({
                type:'GET',
                url: "/transactions.js?filter=send", success: function (result) {
                }
            });
        } else if ($('.filter-option.received i').hasClass('fa-check-square-o')) {
            $.ajax({
                type:'GET',
                url: "/transactions.js?filter=received", success: function (result) {
                }
            });
        } else {
            $.ajax({
                type:'GET',
                url: "/transactions.js?filter=all", success: function (result) {
                }
            });
        }
    });

    $('.user-statistics-container').click(function () {
        $('.delete-filter').addClass('button-enabled');
    });

    $('.given-transactions').click(function () {
        $.ajax({
            type:'GET',
            url: "/transactions.js?filter=send", success: function (result) {
            }
        });
        $('.active-filter-text').html('Given (Personal)');
    });

    $('.received-transactions').click(function () {
        $.ajax({
            type:'GET',
            url: "/transactions.js?filter=received", success: function (result) {
            }
        });
        $('.active-filter-text').html('Received (Personal)')
    });

    $('.all-transactions').click(function () {
        $.ajax({
            type:'GET',
            url: "/transactions.js?filter=mine", success: function (result) {
            }
        });
        // $('.active-filter-text').add('All (Personal)');
        $('.active-filter-text').html('<option>All (Personal)</option>');
    });

    $('.delete-filter').click(function () {
        $.ajax({
            type:'GET',
            url: "/transactions.js?filter=all", success: function (result) {
            }
        });
        $('.active-filter-select').html('None');
        $('.delete-filter').removeClass('button-enabled');
    });

    if ($('.active-filter-select'))

});