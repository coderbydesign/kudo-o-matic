$(document).on("click", '.transaction-selector', function (e) {
    // Ignore selecting / highlighting text
    if (!getSelection().toString()) {
        // ignore clickable items
        if ($(e.target).closest('.upvote-transaction, .downvote-transaction, .hide-file, .attachment-file, .transaction-actions').length) return;

        // ignore links
        if ($(e.target).is('a')) return;

        // redirect to the show page of the transaction
        location.href = $(this).data('team') + "/" + "transactions/" + $(this).attr('id')
    }
});