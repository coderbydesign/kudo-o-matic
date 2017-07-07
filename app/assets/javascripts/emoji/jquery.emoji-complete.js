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
                return '<img src="textcomplete/' + value + '.png">' + value;
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