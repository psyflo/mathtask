# mathtask

Developed using the jsPsych (www.jsypsych.org) library.

[Download the ZIP](https://github.com/psyflo/mathtask/archive/master.zip) and open task.html with a modern web browser (I use Firefox). **No internet connection or server is required since the program runs locally.** 

For a preview visit: http://tagging.psycho.studie.li/projekte/ML5/task.html

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND!

I can not guarantee that the data collected with this software is the same as with the original Math Task.

Press SPACE once more a the end of block 2 to download the recorded data!


Run the R script `convert_csv.R` in a the same directory as the collected data (format: mydata_TIMESTAMP.csv for each participant) to convert the .csv files to the original .dat format. 


Most of the settings are in the file task.html, user.css (style) and in the plugin (plugins/jspsych-survey-text-2.js). The plugin is a copy of the original survey-text plugin that has been adapted to fit our specific needs. 

Drop me a line if you have any questions: florian.bruehlmann@unibas.ch
