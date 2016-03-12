var decision_time = 15;
var preload_time  = 2;

var movieState = {
  INIT    : 0,
  WATCH   : 1,
  DECIDE  : 2,
  PRELOAD : 3,
};

var current_state = movieState.INIT;
var current_video;
var next_video;



i=0;
function append_video(data) {
  var player = $("#video-player");
  var insert_video_html = "<video controls=\"\" id=\"video-stream-"+i+"\" preload=\"auto\"><source src=\"" + data.video + "\" type=\"video/mp4\">Your browser does not support the video tag. </video>";
  player.append(insert_video_html);

  next_video = $("#video-stream-" + i);
  next_video.hide();
  if (data.question != null) { 
    next_video.on("timeupdate", continuous_checks);
    next_video.on("ended", switch_video);
  }

  if (current_state == movieState.INIT){
    current_video = next_video;
    current_video.show();
    current_video.get(0).play();
    current_state = movieState.WATCH;
  }

  i += 1;
}

function switch_video() {
  current_video.hide();
  next_video.show();
  next_video.get(0).play();
  current_video = next_video;
  current_state = movieState.WATCH;
  $("#decision-result-movie").fadeIn( 1000 );
  $("#decision-result-movie").fadeOut( 10000 );
}

function continuous_checks(){
  var decision_point = this.duration - decision_time - preload_time;
  var decision_made = this.duration - preload_time;

  if (this.currentTime > decision_point && current_state == movieState.WATCH) {
    ws.send(JSON.stringify({ decision_active: true }));
    $("#decision-logo").fadeIn( 1000 );
    current_state = movieState.DECIDE;
  }

  if (this.currentTime > decision_made && current_state == movieState.DECIDE) {
    ws.send(JSON.stringify({ video: 'ended' }));
    $("#decision-logo ").fadeOut(1000);
    current_state = movieState.PRELOAD;
  }
}

ws.onmessage = function(message) {
  var data = JSON.parse(message.data);
  if (data.video) {
    append_video(data);
    if (data.votes) { edit_decision_results(data.votes) }
  } else if (data.the_end) {
    $("#decision-logo").html('<div><p>Ende</p></div>');
    $("#decision-logo").fadeIn( 1000 );
  }
};



function edit_decision_results(votes) {
  var votes = JSON.parse(votes);
  if (!jQuery.isEmptyObject(votes)) {
    $("#decision-result-movie").html('');
    for (vote in votes) {
      $("#decision-result-movie").append(
        "<div>" + vote + " : " + votes[vote] + "</div>");
    }
  }
}

$(document).ready(function() {
  $("#decision-logo").hide();
  $("#decision-result-movie").hide();
});
