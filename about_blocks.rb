require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutBlocks < EdgeCase::Koan
  def method_with_block
    result = yield
    result
  end
  
  # NOTE:
  # Code above ^^ uses = yield, this means that whatever is passed to our method, is yielded in our result
  # Ruby syntax :)

  def test_methods_can_take_blocks
    yielded_result = method_with_block { 1 + 2 }
    assert_equal 3, yielded_result
  end

  def test_blocks_can_be_defined_with_do_end_too
    yielded_result = method_with_block do 1 + 2 end
    assert_equal 3, yielded_result
  end

  # NOTE:
  # wtffffffffffuuuuuuuuuckkkkkk. ^^ Powerful shit. do end loop passed to method.

  def method_with_block_arguments
    yield("Jim")
  end

  def test_blocks_can_take_arguments
    result = method_with_block_arguments do |argument|
      assert_equal "Jim", argument
    end
  end

  # ------------------------------------------------------------------

  def many_yields
    yield(:peanut)
    yield(:butter)
    yield(:and)
    yield(:jelly)
  end

  def test_methods_can_call_yield_many_times
    result = []
    many_yields { |item| result << item }
    assert_equal [:peanut, :butter, :and, :jelly], result
  end

  # NOTE:
  # Here we call many_yields, which gives us a result for each item (line) in many_yields yield(:name)

  def yield_tester
    if block_given?
      yield
    else
      :no_block
    end
  end

  def test_methods_can_see_if_they_have_been_called_with_a_block
    assert_equal :with_block, yield_tester { :with_block }
    assert_equal :no_block, yield_tester
  end

  # NOTE:
  # Remember block_given? is a built in ruby method that can be called on methods :/
  # Methods can tells us if they were called with or without a block ^^

  def test_block_can_affect_variables_in_the_code_where_they_are_created
    value = :initial_value
    method_with_block { value = :modified_in_a_block }
    assert_equal :modified_in_a_block, value
  end

  def test_blocks_can_be_assigned_to_variables_and_called_explicitly
    add_one = lambda { |n| n + 1 }
    assert_equal 11, add_one.call(10)

    # Alternative calling sequence
    assert_equal 11, add_one[10]
  end
  
  # NOTE:
  # Lambda is just a way to save a block that you can call later, with specified arguments.

  def test_stand_alone_blocks_can_be_passed_to_methods_expecting_blocks
    make_upper = lambda { |n| n.upcase }
    result = method_with_block_arguments(&make_upper)
    assert_equal "JIM", result
  end

  # NOTE:
  # ^^ We pass to to our method, a block argument (&make_upper), which is reference to our lambda block.
  # Since method_with_block_arguments, originally yields a result of "Jim"...
  # And we're passing a REFERENCE to our lambda, it takes our result, and performs the lambda (upcase)
  # Thus our answer yielded by method_with_block_arguments, and transformed through our lambda.
  # pretty
  # fuckin
  # cool.

  def method_with_explicit_block(&block)
    block.call(10)
  end

  def test_methods_can_take_an_explicit_block_argument
    assert_equal 20, method_with_explicit_block { |n| n * 2 }

    add_one = lambda { |n| n + 1 }
    assert_equal 11, method_with_explicit_block(&add_one)
  end

end
