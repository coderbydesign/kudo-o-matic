var worker = null;
var loadedPercentage = 0;

function increment(jar) {
    $('#counter').html(jar.balanceCoins + ' Coins');
    $('#drink').css('top', (100-loadedPercentage*.9)+'%');

    if(loadedPercentage % 5 == 0){
        slice = loadedPercentage / 5
        $('#cubes div:nth-child(' + slice +')').fadeIn(100)
    }

    if(loadedPercentage == jar.balancePercentage) {
        loadedPercentage = 0;
        stopLoading(jar.balancePercentage);
        $(".dynamic").fadeIn(1000);
        $(".loadingmessage").hide();
    }
    else{
        loadedPercentage = loadedPercentage + 1
    }
}

function startLoading(bp) {
    $('#cubes div').hide();

    worker = setInterval(function(){increment(bp)} , 60);
}
function stopLoading(bp) {
    clearInterval(worker);
    setText(bp)
}

function setText(bp){
    if (bp >= 100){
      $(".dynamicmessage").html("5th message ");
    }else if (bp > 80){
      $(".dynamicmessage").html("4th message ");
    }else if (bp > 60){
      $(".dynamicmessage").html("3rd message");
    }else if (bp > 40){
      $(".dynamicmessage").html("2nd message ");
    }else if (bp > 20){
      $(".dynamicmessage").html("1st message ");
    }
};

$(document).ready(function(){
    $(".dynamic").hide();
    startLoading($('#loader').data())
})


