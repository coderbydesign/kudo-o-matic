var worker = null;
var loadedPercentage = 0;

function increment() {
    $('#counter').html(loader.balanceCoins + ' Coins');
    $('#drink').css('top', (100-loadedPercentage*.9)+'%');

    if(loadedPercentage % 5 == 0){
        slice = loadedPercentage / 5
        $('#cubes div:nth-child(' + slice +')').fadeIn(100)
    }

    if(loadedPercentage == loader.balancePercentage) {
        loadedPercentage = 0;
        stopLoading(loader.balancePercentage);
        $(".dynamic").fadeIn(1000);
        $(".loadingmessage").hide();
    }
    else{
        loadedPercentage = loadedPercentage + 1
    }
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
    if (bp >= 100){
      $(".dynamicmessage").html("5 ");
    }else if (bp > 80){
      $(".dynamicmessage").html("4 ");
    }else if (bp > 60){
      $(".dynamicmessage").html("3 ");
    }else if (bp > 40){
      $(".dynamicmessage").html("2 ");
    }else if (bp > 20){
      $(".dynamicmessage").html("1 ");
    }
};

$(document).ready(function(){
    $(".dynamic").hide();
    window.loader = $('#loader').data()
    startLoading();
})


