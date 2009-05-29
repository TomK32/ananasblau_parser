require '../../test_helper'

class AnanasblauParsersVoteTest < ActiveSupport::TestCase
  def setup
    @parser = Ananasblau::Parsers::Vote.new
  end
  def test_01_create_voting
    assert_equal [:create, {:question => 'Is there a god?', :options => []}], @parser.parse('Is there a god?')
  end
  def test_02_create_voting_with_options
    assert_equal [:create, {:question => 'Is there a god?', :options => %w(Yes Maybe No)}], @parser.parse('Is there a god? Yes. Maybe. No')
    assert_equal [:create, {:question => 'Is there a god?', :options => %w(Yes Maybe No)}], @parser.parse('Is there a god? Yes Maybe No')
    assert_equal [:create, {:question => 'Is there a god?', :options => %w(Yes Maybe No)}], @parser.parse('@vote4 new Is there a god? Yes Maybe No')
    assert_equal [:create, {:question => 'Is there a god?', :options => %w(Yes Maybe No)}], @parser.parse('@vote4 create Is there a god? Yes Maybe No')
    assert_equal [:create, {:question => 'Is there a god?', :options => %w(Yes Maybe No)}], @parser.parse('@vote4 Is there a god? Yes Maybe No')
  end
  def test_03_vote_on_id
    assert_equal [:vote, {:id => '123', :option => 'No'}], @parser.parse('@vote #123 No')
    assert_equal [:vote, {:id => 'is-there-a-god', :option => 'Yes'}], @parser.parse('@vote #is-there-a-god Yes')
  end
  def test_04_vote_on_username
    assert_equal [:vote, {:user_screen_name => 'TomK32', :option => 'Yes'}], @parser.parse('@vote @TomK32 Yes')
  end
  def test_05_errors
    assert_equal :error, @parser.parse('@vote Yes')
    assert_equal :error, @parser.parse('@vote @TomK32')
    assert_equal :error, @parser.parse('@vote #123')
    assert_equal :error, @parser.parse('@vote You look great')
    assert_equal :error, @parser.parse('@vote I think @tomk32 looks great')
  end
end
