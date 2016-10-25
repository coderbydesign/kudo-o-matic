var worker = null;
var coinstatus = 0
var loaded = 0;
var bp = $(".next.amount").val();

$( document ).ready(function() {
    $(".dynamic").hide();

});

function increment() {
    $('#counter').html(coinstatus+' Coins');
    $('#drink').css('top', (100-loaded*.9)+'%');
    for (i = 0; i < 20; i++) {
      if(loaded == i * 5 && loaded < bp) $('#cubes div:nth-child(' + i +')').fadeIn(100);
    }
    if(loaded == bp) {
        loaded = 0;
        coinstatus = 0;
        stopLoading();
        $(".dynamic").fadeIn(1000);
        $(".loadingmessage").hide();
    }
    else loaded = loaded + 1
    console.log(loaded);

    // if (loaded == 10){
    //   $(".dynamicmessage").html("1st message ");
    // }
    // if (loaded == 25){
    //   $(".dynamicmessage").html("2nd message ");
    // }
    // if (loaded == 400){
    //   console.log("50test");
    //   $(".dynamicmessage").html("3rd message ");
    // }
    // if (loaded == 900){
    //   $(".dynamicmessage").html("4th message ");
    // }
    // if (loaded == 900){
    //   $(".dynamicmessage").html("5th message ");
    // }
}

function startLoading(bp) {
    $('#cubes div').hide();
    worker = setInterval(increment , 60);
}
function stopLoading(bp) {
    console.log("stoploading")
    clearInterval(worker);
    setText(bp)
}

function setText(bp){
  console.log("calling settext", bp)
    if (bp == 10){
      $(".dynamicmessage").html("1 ");
    }
     if (bp == 25){
      $(".dynamicmessage").html("2 ");
    }
     if (bp == 400){
      console.log("50test");
      $(".dynamicmessage").html("3 ");
    }
     if (bp == 900){
      $(".dynamicmessage").html("4 ");
    }
    if (bp == 900){
      $(".dynamicmessage").html("5 ");
    }
};

startLoading(bp);
