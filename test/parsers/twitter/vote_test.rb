require '../../test_helper'

class AnanasblauParsersVoteTest < ActiveSupport::TestCase
  def setup
    @parser = Ananasblau::Parsers::Vote.new
  end
  def test_01_create_voting
    assert_equal [:create, {:question => 'Is there a god?', :options => []}], @parser.parse('Is there a god?')
  end
  def test_02_list_my_votings
    assert_equal :list, @parser.parse('list')
  end
end
