require 'test_helper'

class ParseClippingServiceTest < ActiveSupport::TestCase

    test 'open clipping file' do
        clipping = ParseClippingService.new('/Users/BadTudou/Desktop/Other/demo1.txt')
        #puts clipping.parseForSection
        #puts clipping.parseForFragment
        puts clipping.parseForNote
    end
end