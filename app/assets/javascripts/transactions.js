jQuery(function() {
    return $('#transaction_receiver_name').autocomplete({
        source: $('#transaction_receiver_name').data('autocomplete-source'),
        autoFocus: true,
        maxShowItems: 5
    });
});

// jQuery(function() {
//     return $('#transaction_activity_name').autocomplete({
//         source: $('#transaction_activity_name').data('autocomplete-source'),
//         autoFocus: true,
//         maxShowItems: 5
//     });
// });

$(document).ready(function() {
    $('.menu-option.filter').click(function () {
        $('.hidden-menu.filter').slideToggle("slow");
    });

    // Error container hide
    $('.message-container .fa-times').click(function () {
        $('.message-container').fadeOut(325);
    });

    // Goals container toggle show/hide
    $('.expand-collapse i.fa.fa-chevron-down').click(function () {
        $('.chart--second-goal').slideToggle(325);
    });

    // Dropdown menu toggle show/hide
    $('button.dropdown-button .current-user').click(function () {
        $('.dropdown-content').slideToggle(325);
    });

    // Kudometer icons toggle on max width 1200px
    $(function () {
        $('span').click(function () {
            $(this).find('i').toggleClass('fa-chevron-down fa-chevron-up')
        });
    });

    // Checkbox icons toggle
    $('.filter-option').click(function () {
        $(this).find('i').toggleClass('fa-square-o fa-check-square-o')
    });

    // Menu icons toggle
    $('.current-user').click(function () {
        $(this).find('i').toggleClass('fa-bars fa-chevron-up')
    });
});