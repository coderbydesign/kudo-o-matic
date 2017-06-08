$(document).ready(function () {
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
        }
    ], {
        onKeydown: function (e, commands) {
            if (e.ctrlKey && e.keyCode === 74) { // CTRL-J
                return commands.KEY_ENTER;
            }
        }
    });
});