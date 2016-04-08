require "test_helper"

class GoalTest < ActiveSupport::TestCase

  def test_previous_goal
    assert_equal goals(:tennis), Goal.previous
  end

  def test_next_goal
    assert_equal goals(:karten), Goal.next
  end

  def test_achieve
    goal = goals(:karten)

    refute goal.achieved?
    goal.achieve!
    assert goal.achieved?
  end

end
