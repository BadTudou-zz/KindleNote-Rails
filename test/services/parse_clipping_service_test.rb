require 'test_helper'

class ParseClippingServiceTest < ActiveSupport::TestCase

    test 'parse clipping file' do
        clipping = ParseClippingService.new('/Users/BadTudou/Desktop/Other/demo1.txt')
        assert clipping.parseForSection && clipping.parseForFragment && clipping.parseForNote
    end
end