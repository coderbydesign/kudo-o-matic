$(document).on("click", '.transaction-selector', function (e) {
    // ignore clickable items
    if ($(e.target).closest('.upvote-transaction, .downvote-transaction, .hide-file, .attachment-file').length) return;

    // ignore links
    if ($(e.target).is('a')) return

    // redirect to the show page of the transaction
    location.href = "transactions/" + $(this).attr('id')
});