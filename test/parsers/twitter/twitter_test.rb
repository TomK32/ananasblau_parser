require '../../test_helper'

class AnanasblauParsersTwitterTest < ActiveSupport::TestCase
  def setup
    @parser = Ananasblau::Parsers::Twitter.new
  end
  def test_01_extract_usernames
    assert_equal %w(TomK32), @parser.usernames('Hi @TomK32. How are you?')
    assert_equal %w(TomK32 TomK33), @parser.usernames('@TomK32@TomK33')
  end
end
