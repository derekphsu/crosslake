class GenerateReport
  attr_reader :file_path
  attr_accessor :report_to_track, :track_to_indicator, :file_path
  def initialize
    @file_path = ARGV[0]
  end

  def generate_report
    output_file
    calculate
    display_output
  end

  def output_file
    File.foreach(file_path) do |line|
      file_content << line
    end
  end

  def calculate
    file_content.each do |line|
      line_array = line.split(" ")
      type = line_array[0]
      if type == "REPORT"
        report_id = line_array[1]
        report_to_track[report_id] = []
      elsif type == "Track"
        track_id = line_array[1]
        report_id = line_array[2]
        report_to_track[report_id] << track_id
        track_to_indicator[track_id] = { total: 0, weight: 0, avg: 0 }
      elsif type == "Indicator"
        indicator_id = line_array[1]
        track_id = line_array[2]
        score = line_array[3]
        weight = line_array[4]
        track_to_indicator[track_id][:total] += score.to_i * weight.to_i
        track_to_indicator[track_id][:weight] += weight.to_i
        track_to_indicator[track_id][:avg] = track_to_indicator[track_id][:total] / track_to_indicator[track_id][:weight]
      end
    end
  end

  def display_output
    report_to_track.each do |report_id, track_array|
      report_id_scores = track_array.map {|track_id| track_to_indicator[track_id][:avg]}
      puts "Report #{report_id} Overall Score: #{report_id_scores.sum / report_id_scores.size}"
      for i in (0...track_array.length) do
        puts "Track #{track_array[i]} Score: #{report_id_scores[i]}"
      end
    end
  end

  def file_content
    @file_content ||= []
  end

  def track_to_indicator
    @track_to_indicator ||= {}
  end

  def report_to_track
    @report_to_track ||= {}
  end

  def report_output
    @report_output ||= []
  end
end

# GenerateReport.new.generate_report
