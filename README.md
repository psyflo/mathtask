# mathtask

Developed using the [jsPsych](www.jsypsych.org) library.


## Run the application
[Download the ZIP](https://github.com/psyflo/mathtask/archive/master.zip) and open task.html with a modern web browser (Firefox or Chrome  – Internet Explorer might not work!). 
**No internet connection or server is required since the program runs locally.** 

For a preview visit: http://tagging.psycho.studie.li/projekte/ML5/task.html

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND!
I can not guarantee that the data collected with this software is the same as with the original Math Task.

### Localization
Currently, English (default), Hungarian (hu), and German (de) are supported langauges. To change the default language, add the `?lang=X` parameter to the URL in the browser and replace X with the language code. For instance for Hungarian, the URL is `task.html?lang=hu`. 

## Save data
Press SPACE once more a the end of block 2 to download the recorded data as a CSV file. Save the file on your computer and **add participant ID** to the filename. 

Run the R script `convert_csv.R` in a the same directory as the collected data (format: mydata_TIMESTAMP.csv for each participant) to convert the .csv files to the original .dat format. 

## Known issues/limitations
* File download might not work with Internet Explorer - use Firefox or Chrome
* Safari does not support fullscreen
* Does not record participant ID - add it manually to the filename

## Settings
Most of the settings are in the file task.html, user.css (style) and in the plugin (plugins/jspsych-survey-text-2.js). The plugin is a copy of the original survey-text plugin that has been adapted to fit our specific needs. 

## Questions
Drop me a line if you have any questions: florian.bruehlmann@unibas.ch
