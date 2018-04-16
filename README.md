
###  Analyzing sleep patterns using ELK stack and training an Artificial Intelligence model using machine learning for future predictions of sleep patterns of an individual.

## Implemented using: 

### Elastic search, Logstash and Kibana

## ELK Stack

Elasticsearch is a distributed, JSON-based search and analytics engine designed for horizontal scalability, maximum reliability, and easy management.

Logstash is a dynamic data collection pipeline with an extensible plugin ecosystem and strong Elasticsearch synergy. This
stores the input data and stores the indexed data in the kibana localhost.

Kibana gives the visualization of data through a UI.

## Pre-requisite:

Main dependency for installing the ELK stack is Java. Make sure to install java 8 or above.

Install ElasticSearch, Logstash and kibana. You can follow the steps included in the document.
Check if all the installations are done perfectly.

### Configure Logstash

Next configure the logstash, specify the following sections in the configuration file.
## [Config File](https://github.com/shruthipinnamwar/SleepAnalysis_Fixers/blob/master/src/logstash-6.2.3/sleep_log.conf)
The three sections are:
  input
  filter
  output

**Input:**

## [Logs File](https://github.com/shruthipinnamwar/SleepAnalysis_Fixers/blob/master/src/logstash-6.2.3/bulk_sleep.csv)
In this we can specify the CSV input file that contains the log files. This input is used to index the data for the kibana.

**Filter:** 
We can specify separators and columns present in the input file. we can also change data types of the column. By default kibana takes each column as a textvalue. Mutate is used to convert the datatypes.

**Output:**
In this we need to specify where the indexed log data should be stored and visualized.Here we specified the output in the localhost of kibana. we should also specify the input and output file name.

## Implementation:

To insert the sleeppattern CSV file data into the elasticsearch you have to notify the Logstash server.

## Kibana:

### Dashboard Page

The Dashboard page displays a collection of saved visualizations. Here you can either add new visualizations or you can use any saved visualization as well.

### Visualize Page

Visualize page enables to visualize the data present in your Elasticsearch indices, in the form of charts, bars, pies etc. Here we can even build the dashboards which will display the related visualizations based on Elasticsearch queries. Here different types of visualization options are provided.

**Steps for Visualizing Pattern:**

1. To visualize any pattern goto the visualize tab of kibana and add new pattern. 
2. Here we get a list of visualization types to select like bar graph, pie chart,line graph etc...
3. Once we select the pattern type, we get the list of indexed files as a source to select. 
4. Then we get the x-axis and y-axis to configure the csv data columns.
5. In both the axis there are different operators like min,max,count,sum,range,date,histogram etc..
6. Once the operator is selected we should select the column/field on which this should be applied.
7. Now depends on the pattern type we selected,we get the required output.
8. We can also select the labels and colors on both the axis. 

Now we can save the patterns and add to the dashboard to visualize the data. Each visualized pattern will have the iframe and a link that can be added externally.   
Result:   
![](https://github.com/shruthipinnamwar/SleepAnalysis_Fixers/blob/master/Documentation/Analysis.jpeg)
### Duartion VS How he felt afterwards
![](https://github.com/shruthipinnamwar/SleepAnalysis_Fixers/blob/master/Documentation/Duration%20vs%20How%20felt%20afterwards.jpeg)
## Dashboard with all analysis grapghs
![](https://github.com/shruthipinnamwar/SleepAnalysis_Fixers/blob/master/Documentation/Dashboard.jpeg)
## Future Prediction
![](https://github.com/shruthipinnamwar/SleepAnalysis_Fixers/blob/master/Documentation/Future%20Prediction.jpeg)
## References :
### [https://www.elastic.co/learn](https://www.elastic.co/learn)
### [https://www.elastic.co/videos](https://www.elastic.co/videos)
### [https://www.elastic.co/webinars/getting-started-kibana?elektra=home&storm=sub2](https://www.elastic.co/webinars/getting-started-kibana?elektra=home&storm=sub2)
