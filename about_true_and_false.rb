require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutTrueAndFalse < EdgeCase::Koan
  def truth_value(condition)
    if condition
      :true_stuff
    else
      :false_stuff
    end
  end

  def test_true_is_treated_as_true
    assert_equal :true_stuff, truth_value(true)
  end

  def test_false_is_treated_as_false
    assert_equal :false_stuff, truth_value(false)
  end
  
  # NOTE:
  # if (condition), means that substituting false == condition, does not make a valid if statement.
  # It outsmarts us and says "if false doesn't make sense" since that would be a false statement,
  # thus moves to the else clause (denoted in method above).

  def test_nil_is_treated_as_false_too
    assert_equal :false_stuff, truth_value(nil)
  end

  def test_everything_else_is_treated_as_true
    assert_equal :true_stuff, truth_value(1)
    assert_equal :true_stuff, truth_value(0)
    assert_equal :true_stuff, truth_value([])
    assert_equal :true_stuff, truth_value({})
    assert_equal :true_stuff, truth_value("Strings")
    assert_equal :true_stuff, truth_value("")
  end

end
