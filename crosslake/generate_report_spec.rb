require './generate_report.rb'
require "rspec/autorun"

describe GenerateReport do
  let(:report1) {GenerateReport.new}

  describe 'generate_report' do
    let(:dbl) { double("GenerateReport", 
                      :report_array => {"R1"=>["T1", "T2", "T3"], "R2"=>["T4"]}, 
                      :track_to_indicator => {"R1"=>["T1", "T2", "T3"], "R2"=>["T4"]})}
    it "calls three methods" do
      expect(report1).to receive(:output_file).once
      expect(report1).to receive(:calculate).once
      expect(report1).to receive(:display_output).once
      report1.generate_report
    end
  end

  describe 'calculate' do
    describe "it records the correct data" do
      let(:data) {["REPORT R1", "Track T1 R1", "Indicator I1 T1 99 1", "Indicator I2 T1 50 5"]}
      
      before(:each) do
        allow(report1).to receive_messages(:output_file => nil, :file_content => data)
        report1.calculate
      end

      it "adds the correct calculation to .track_to_indicator" do
        expect(report1.track_to_indicator).to eq({"T1" => {:avg=>58, :total=>349, :weight=>6}})
      end

      it "adds the correct data to .report_to_track" do
        expect(report1.report_to_track).to eq({"R1"=>["T1"]})
      end
    end

    
    describe "Tracks and Indicator are not grouped by report" do
      let(:data) {["REPORT R1", "REPORT R2", "Track T1 R1", "Indicator I1 T1 99 1", "Indicator I2 T1 99 1", "Track T2 R1", "Indicator I3 T2 99 1"]}
      
      before(:each) do
        allow(report1).to receive_messages(:output_file => nil, :file_content => data)
        report1.calculate
      end

      it "adds the correct data to .track_to_indicator" do
        expect(report1.track_to_indicator).to eq({"T1"=>{:avg=>99, :total=>198, :weight=>2}, "T2"=>{:avg=>99, :total=>99, :weight=>1}})
      end

      it "adds the correct data to .report_to_track" do
        expect(report1.report_to_track).to eq({"R1"=>["T1", "T2"], "R2"=>[]})
      end
    end
  end

  describe 'display_output' do
    let(:report_to_track) {{"R1"=>["T1", "T2"], "R2"=>["T3"]}}
    let(:track_to_indicator) {{"T1"=>{:avg=>72}, "T2"=>{:avg=>74}, "T3"=>{:avg=>66}}}

    it "generates the proper report_output" do
      allow(report1).to receive_messages(:report_to_track => report_to_track, :track_to_indicator => track_to_indicator)
      report1.display_output
      expect{report1.display_output}.to output("Report R1 Overall Score: 73\nTrack T1 Score: 72\nTrack T2 Score: 74\nReport R2 Overall Score: 66\nTrack T3 Score: 66\n").to_stdout
    end
  end
end
