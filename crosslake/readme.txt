How to run the code
In generate_report.rb, make sure line 70 `GenerateReport.new.generate_report` is not commented out
In the terminal, navigate to the folder and enter `ruby generate_report.rb {path_to_file}`
Ex. `ruby generate_report.rb "report.txt"`

How to test the code
In generate_report.rb, comment out line 70 `GenerateReport.new.generate_report`
In the terminal enter `ruby generate_report_spec.rb`

Assumption 1
It assumes that the ruby version is 1.9 and above.  Ruby version 1.9 and above retains insertion order of hash, thus it retains the order of Report insertion

Assumption 2
It assumes the input format is a .txt file

Assumption 3
It assumes the correct case of "REPORT", "Track", and "Indicator" are used as the first word in each line with the correct upper/lower/caps casing

Assumption 4
It assumes that the version of Rspec is 3.0 and above


Why I chose this method
.generate_report
By listing out the steps it takes to generate the report, it is clear at a glance what steps it needs to take to go from input to output before anyone needs to take a deeper dive into the code.  It also means that each method has a specific purpose and no method is too big.  It is also easy to test.

.output_file
I have to create .output_file because I was unable to stub out the File.foreach method in my tests.  Normally I would just add it as the first line in .calculate and leverage the added efficiency in the foreach method.  The current implementation takes extra memory by dumping everything out to .file_content and forgoes the benefit of the foreach loop which only reads one line at a time, thus improving memory usage when the input file is large.  

.calculate
I am create/update two hash maps here.  One is linking which track belongs to which report, and the other is recording the current total score, the total weight, and average score of each track.  I use a hashmap to link the reports to the tracks because in ruby 1.9 and above, the insertion order is kept in a hash, thus fulfilling the FIFO requirement of the Reports during output.

.display_output
This also uses the data created in the previous step of .calculate to generate the output of the data in this step.  This step is last because we dont know the score of the reports without knowing the scores of the tracks.  Then it is a simple process of looping through all the reports, and the tracks its associated with, and output them in stdout.

I thought about storing the output to an instance variable and add another step to print it out in generate report but decided against it.  It does not add any additional benefit to the code and now we have to store the output somewhere, which increases memory usage.

Testing
For each individual method, they are unit tested.  
.initiate
I did not test the initiate method as I ran into trouble testing the ARGV aspect of the code.

.generate_report
Since this is the public method the user would be calling, it would make sense to do an end to end testing.  However since I was having trouble feeding it a test file, this method was not tested extensively.  I did basic unit test to ensure that the 3 methods are being called in here.

.output_file
This is also not tested because because I was having problems with stubbing out File.foreach. Since File is a built in Ruby/IO code,  it's more important to test the other features of the code and assumes this piece just functions properly.  

.calculate
This method accepts a predefined format of input as listed out by the schema.  We are safe to assume each track/report/indicator id will be an integer when converted from string to int.  Therefore we just have to make sure two things.  1) data is correctly being entered to .track_to_indicator and .report_to_track, and 2) data coming in is not grouped by report or tracks.
Once we tested for these two variables, then any changes to the code should break the test, thus ensuring that the business logic will remain the same.

.display_output 
This method requires data that is generated from .calculate.  It is not called elsewhere.  The method in a sense is like similar to functional programming, where the same input will always generate the same output.  As long as the output to stdout matches expectations, then the test should be 100% coverage.

.report_to_track, .track_to_indicator, .file_path
These three methods are not tested as they serve the purpose as instance variables.
