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
        $('.goal-container').slideToggle(250);
    });

    // Dropdown profile toggle show/hide
    $('.current-user').click(function () {
        $('.profile.dropdown-content').slideToggle(250);
    });

    // Dropdown meny toggle show/hide
    $('.general-menu').click(function () {
        $('.general.dropdown-content').slideToggle(250);
    });

    // Menu icons toggle
    $('.general-menu').click(function () {
        $(this).find('i').toggleClass('fa-bars fa-chevron-up')
    });

    // Kudometer icons toggle on max width 1200px
    $('span.expand-collapse').click(function () {
        $(this).find('i').toggleClass('fa-chevron-down fa-chevron-up')
    });

    // Characters left in activity input field
    $('.counter').hide();
    var textMax = $('.character-count').attr('maxLength');
    console.log(textMax);
    $('.counter').html(textMax);

    $('.character-count').keyup(function() {
        $('.counter').fadeIn('fast');
        var textLength = $('.character-count').val().length;
        var textRemaining = textMax - textLength;

        $('.counter').html(textRemaining);
    });

    // Submit on enter in transaction textarea
    $('.character-count').keypress(function(event) {
        if (event.keyCode == 13 || event.which == 13) {
            $('.send-kudos-button').click();
            event.preventDefault();
        }
    });
});