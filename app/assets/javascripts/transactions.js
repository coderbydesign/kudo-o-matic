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
        $('.message-container').fadeOut(250);
    });

    // Goals container toggle show/hide
    $('.expand-collapse i.fa.fa-chevron-down').click(function () {
        $('.chart--second-goal').slideToggle(250);
    });

    // Dropdown profile toggle show/hide
    $('.current-user').click(function () {
        $('.profile-content').slideToggle(250);
    });

    // Dropdown meny toggle show/hide
    $('button.dropdown-button .general-menu').click(function () {
        $('.dropdown-content').slideToggle(250);
    });

    // Kudometer icons toggle on max width 1200px
    $('span').click(function () {
        $(this).find('i').toggleClass('fa-chevron-down fa-chevron-up')
    });

    // Checkbox icons toggle
    $('.filter-option').click(function () {
        $(this).find('i').toggleClass('fa-square-o fa-check-square-o')
    });

    // Menu icons toggle
    $('.general-menu').click(function () {
        $(this).find('i').toggleClass('fa-bars fa-chevron-up')
    });
});