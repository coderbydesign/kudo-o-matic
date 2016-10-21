var worker = null;
var loaded = 0;
//var message = document.getElementsByClassName('dynamicmessage');
$( document ).ready(function() {
    $(".dynamic").hide();

});

function increment() {
    $('#counter').html(loaded+' Coins');
    $('#drink').css('top', (100-loaded*.9)+'%');
  //  console.log("test", loaded, max, (loaded==5 && loaded < max) );

    for (i = 0; i < 20; i++) {
      if(loaded == i * 5 && loaded < max) $('#cubes div:nth-child(' + i +')').fadeIn(100);
    }
    if(loaded == max) {
        loaded = 0;
        stopLoading();
        $(".dynamic").fadeIn(1000);
        $(".loadingmessage").hide();

    // setTimeout(startLoading, 1000);
    }
    else loaded = loaded + 1

    if(loaded == 25)
      $(".dynamicmessage").html("not even close to anywhere. What are you guys? Lazy?!");

    if(loaded == 50)
      $(".dynamicmessage").html("over the half full mark. Nice, but we're not there yet ");

    if(loaded == 75)
        $(".dynamicmessage").html("is not full yet. Why is this not full yet? ");

    if(loaded == 90)
        $(".dynamicmessage").html("almost full. Can it be true? Are we almost there? Soooo close, we got this! ");

}

function startLoading() {
    $('#cubes div').hide();
    worker = setInterval(increment , 40);
}
function stopLoading() {
    clearInterval(worker);
}

max = $(".next.amount").val();
startLoading();
