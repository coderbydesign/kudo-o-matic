jQuery(function() {
    return $('#transaction_receiver_name').autocomplete ({
        source: $('#transaction_receiver_name').data('autocomplete-source'),
        autoFocus: true,
        maxShowItems: 5
    });
});

$(document).ready(function() {

    $('.character-count').textcomplete([
        { // emoji strategy
            id: 'emoji',
            match: /\B:([\-+\w]*)$/,
            search: function (term, callback) {
                callback($.map(emojies, function (emoji) {
                    return emoji.indexOf(term) === 0 ? emoji : null;
                }));
            },
            template: function (value) {
                return '<img src="https://yuku-t.com/jquery-textcomplete/media/images/emoji/' + value + '.png"></img>' + value;
            },
            replace: function (value) {
                return ':' + value + ': ';
            },
            index: 1
        },
        { // tech companies
            id: 'tech-companies',
            words: ['apple', 'google', 'facebook', 'github'],
            match: /\b(\w{2,})$/,
            search: function (term, callback) {
                callback($.map(this.words, function (word) {
                    return word.indexOf(term) === 0 ? word : null;
                }));
            },
            index: 1,
            replace: function (word) {
                return word + ' ';
            }
        }
    ], {
        onKeydown: function (e, commands) {
            if (e.ctrlKey && e.keyCode === 74) { // CTRL-J
                return commands.KEY_ENTER;
            }
        }
    });

    $('.menu-option.filter').click(function () {
        $('.hidden-menu.filter').slideToggle("slow");
    });

    // Error container hide
    $('.close-message').click(function () {
        $('.message-container').addClass('hide-message');
    });

    // Dropdown profile toggle show/hide
    $('.current-user').click(function () {
        $(this).find('.fa').toggleClass('fa-chevron-down fa-chevron-up');
        // $('.profile.dropdown-content').slideToggle(250);
        $('.profile.dropdown-content').toggleClass('slide-menu');
        return false
    });

    // Dropdown meny toggle show/hide
    $('.general-menu').click(function () {
        $('.general.dropdown-content').slideToggle(250);
    });

    // Menu icons toggle
    $('.general-menu').click(function () {
        $(this).find('i').toggleClass('fa-bars fa-chevron-up')
    });

    // Characters left in activity input field
    var textMax = $('.character-count').attr('maxLength');
    $('.counter').html(textMax);

    $('.character-count').keyup(function() {
        $('.counter').addClass('show-counter');
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

    $('.input-receiver, .input-amount').keydown(function(event){
        if(event.keyCode == 13) {
            event.preventDefault();
            return false;
        }
    });
});