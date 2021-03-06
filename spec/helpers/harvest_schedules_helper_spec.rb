# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

require "spec_helper"

describe HarvestSchedulesHelper do
  let(:harvest_schedule) { mock(:harvest_schedule, 
                                 frequency: 'monthly', 
                                 at_hour: '13', 
                                 at_minutes: '46', 
                                 cron: '46 13 1 * *',
                                 status: 'active') }


  context '#harvest_schedule_frequency' do
    it "should generate the text" do
      helper.harvest_schedule_frequency(harvest_schedule).should eq 'monthly at 13:46 (46 13 1 * *)'
    end
  end

  context '#pause_resume_class_for' do
    it 'returns pause when status is active' do
      helper.pause_resume_class_for(harvest_schedule).should eq 'pause'
    end

    it 'returns resume when status is paused' do
      harvest_schedule.stub(:status) { 'paused' }
      helper.pause_resume_class_for(harvest_schedule).should eq 'resume'
    end
  end

  context '#pause_resume_value_for' do
    it 'returns paused when status is active' do
      helper.pause_resume_value_for(harvest_schedule).should eq 'paused'
    end

    it 'returns active when status is paused' do
      harvest_schedule.stub(:status) { 'paused' }
      helper.pause_resume_value_for(harvest_schedule).should eq 'active'
    end
  end
end

