$(document).ready(function () {
    var $mediaAttachment = $('#media-attachment');

    $('.add-attachment').click(function () {
        $mediaAttachment.click();
    });

    $mediaAttachment.change(function (event) {
        var files = event.target.files;
        var image = files[0];
        var reader = new FileReader();
        reader.onload = function(file) {
            var img = new Image();
            img.src = file.target.result;
            $('.attachment-preview').html(img)
        };
        reader.readAsDataURL(image)
    });

    $mediaAttachment.on("change", function () {
        $('.attachment-content').addClass('show-attachment');
        $('.attachment-tooltip').addClass('show-tooltip');
    });

    $mediaAttachment.change(function () {
        var $pathname = ($('#media-attachment').val());
        var splitPath = $pathname.split("fakepath\\")[1];
        $('.file-name').html(splitPath);
    });

    function offsetAttachment() {
        var $addAttachment = $('.add-attachment');
        var $offsetTop = $addAttachment.offset().top;
        var $offsetLeft = $addAttachment.offset().left;
        var $height = $addAttachment.height();
        $('.attachment-content').css({ top: $offsetTop + ($height * 2.5), left: $offsetLeft - 8  });
    }

    offsetAttachment();

    $(window).resize(function () {
        offsetAttachment();
    });

    $('.close-message').click(function () {
        offsetAttachment();
    });

    $('.destroy-attachment').click(function () {
        var $el = $('#media-attachment');
        $el.wrap('<form>').closest('form').get(0).reset();
        $el.unwrap();
        $('.attachment-content').removeClass('show-attachment');
    });

    // Toggle show and hide transaction attachment per transaction
    $(document).on("click", '.hide-file', function () {
        var closestAttachment = $(this).closest('.media-attachment').find('.attachment-file');
        console.log(closestAttachment)
        closestAttachment.toggleClass('hide-image');
       $(this).toggleClass('fa-chevron-down fa-chevron-right')
    });
});