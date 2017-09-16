//var decisionSound = new Audio('sounds/decision_sound.mp3');

ws.onmessage = function(message) {
  var data = JSON.parse(message.data);

  if (data.question && data.answers) {
    hideDecision();
    $("#question").html(data.question);
    $("#answers").html('');
    for (answer_key in data.answers) {
      $("#answers").append(
        "<button id='"+answer_key+"-btn' class='decision-btn' onclick='handleDecision(\""+answer_key+"\")'>"+
        data.answers[answer_key]+"</button>");
    }
  }
  if (data.decision_active === true) {
    showDecision();
  } else {
    hideDecision();
  }
  if (data.votes) {
    showDecisionResult(data.votes);
  };
};

function showDecision() {
  //decisionSound.play();
  $("#waiting-panel").hide();
  $("#decision-panel").show();
}

function hideDecision(smooth) {
  if (smooth) {
    $("#decision-panel").delay( 500 ).fadeOut( 500 );
    $("#waiting-panel").delay( 1000 ).fadeIn( 500 );
  } else {
    $("#decision-panel").fadeOut();
    $("#waiting-panel").fadeIn();
  }
}

function handleDecision(e) {
  $(".decision-btn").attr("disabled", "disabled");
  $("#"+e+"-btn").addClass('decided-button');
  ws.send(JSON.stringify({ decided: e }));
  hideDecision(true);
}

function showDecisionResult(votes) {
  var votes = JSON.parse(votes);
  if (!jQuery.isEmptyObject(votes)) {
    $("#decision-result-voting").html('<b style="font-variant: small-caps">Letzte Abstimmung</b>');
    for (vote in votes) {
      $("#decision-result-voting").append(
        "<div> " + vote + " : " + votes[vote] + " Stimme(n) </div>");
    }
    $("#decision-result-voting").delay( 1500 ).fadeIn( 1000 );
    $("#decision-result-voting").fadeOut( 10000 );
  }
}

$(document).ready(function() {
  $("#decision-result-voting").hide();
});
