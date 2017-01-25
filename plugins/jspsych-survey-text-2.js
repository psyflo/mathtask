/**
 * jspsych-survey-text
 * a jspsych plugin for free response survey questions
 *
 * Josh de Leeuw
 *
 * documentation: docs.jspsych.org
 *
 */


jsPsych.plugins['survey-input-validate'] = (function() {

  var plugin = {};

  plugin.trial = function(display_element, trial) {

    trial.preamble = typeof trial.preamble == 'undefined' ? "" : trial.preamble;
    if (typeof trial.rows == 'undefined') {
      trial.rows = [];
      for (var i = 0; i < trial.questions.length; i++) {
        trial.rows.push(1);
      }
    }
    if (typeof trial.columns == 'undefined') {
      trial.columns = [];
      for (var i = 0; i < trial.questions.length; i++) {
        trial.columns.push(40);
      }
    }

    // if any trial variables are functions
    // this evaluates the function and replaces
    // it with the output of the function
    trial = jsPsych.pluginAPI.evaluateFunctionParameters(trial);

    // show preamble text
    display_element.append($('<div>', {
      "id": 'jspsych-survey-text-preamble',
      "class": 'jspsych-survey-text-preamble'
    }));

    $('#jspsych-survey-text-preamble').html(trial.preamble);

    // add questions
    for (var i = 0; i < trial.questions.length; i++) {
      // create div
      display_element.append($('<div>', {
        "id": 'jspsych-survey-text-' + i,
        "class": 'jspsych-survey-text-question custom-question'
      }));

      // add question text
      $("#jspsych-survey-text-" + i).append('<p class="jspsych-survey-text left" style="color: darkred;">' + trial.questions[i] + '</p>');

      // add text box
      $("#jspsych-survey-text-" + i).append('<input type="text" name="#jspsych-survey-text-response-' + i + '" cols="' + trial.columns[i] + '" rows="' + trial.rows[i] + '" style="width: 60px;"></input>');
    }

    // add submit button
    $("div[id^='jspsych-survey-text-']").last().append($('<button>', {
      'id': 'jspsych-survey-text-next',
      'class': 'jspsych-btn jspsych-survey-text enter-button'
    }));
    $("#jspsych-survey-text-next").html('Enter');

    $('input').keyup(function(e){
          if(e.keyCode == 13)
          {
             $("#jspsych-survey-text-next").click();
          }
      });
    $('input').focus();

    $("#jspsych-survey-text-next").click(function() {
      var end = false;
      // measure response time
      var endTime = (new Date()).getTime();
      var response_time = endTime - startTime;

      // create object to hold responses
      var question_data = {};
      $("div.jspsych-survey-text-question").each(function(index) {
        var id = "Q" + index;
        var val = parseInt($(this).children('input').val().trim());
        end = $.isNumeric(val);
        var obje = {};
        obje[id] = val;
        $.extend(question_data, obje);
      });

      // save data
      var trialdata = {
        "rt": response_time,
        "responses": JSON.stringify(question_data)
      };


      // next trial if response is valid
      if(end) {
        display_element.html('');
        jsPsych.finishTrial(trialdata);
      }
    });

    var startTime = (new Date()).getTime();
  };

  return plugin;
})();
