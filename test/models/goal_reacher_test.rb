require 'test_helper'

class GoalReacherTest < ActiveSupport::TestCase

  def test_no_goal_reached
    assert_equal goals(:tennis), Goal.previous
    assert_equal goals(:karten), Goal.next

    GoalReacher.check!

    assert_equal goals(:tennis), Goal.previous
    assert_equal goals(:karten), Goal.next
  end

  def test_goal_reached
    assert_equal goals(:tennis), Goal.previous
    assert_equal goals(:karten), Goal.next

    Balance.current.add(1000)
    GoalReacher.check!

    assert_equal goals(:karten), Goal.previous
    assert_equal goals(:bbq), Goal.next
  end
end
