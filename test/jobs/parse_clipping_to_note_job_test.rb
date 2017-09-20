require 'test_helper'

class ParseClippingToNoteJobTest < ActiveJob::TestCase
  test "the truth" do
    path = '/Users/BadTudou/Desktop/Other/demo1.txt'
    assert ParseClippingToNoteJob.perform_later path
  end
end
