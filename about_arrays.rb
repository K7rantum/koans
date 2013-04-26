require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutArrays < EdgeCase::Koan
  def test_creating_arrays
    empty_array = Array.new
    assert_equal Array, empty_array.class
    assert_equal 0, empty_array.size
  end

  def test_array_literals
    array = Array.new
    assert_equal [], array

    array[0] = 1
    assert_equal [1], array

    array[1] = 2
    assert_equal [1, 2], array

    array << 333
    assert_equal [1,2,333], array
  end

  def test_accessing_array_elements
    array = [:peanut, :butter, :and, :jelly]

    assert_equal :peanut, array[0]
    assert_equal :peanut, array.first
    assert_equal :jelly, array[3]
    assert_equal :jelly, array.last
    assert_equal :jelly, array[-1]
    assert_equal :butter, array[-3]
  end

  def test_slicing_arrays
    array = [:peanut, :butter, :and, :jelly]

    assert_equal [:peanut], array[0,1]
    assert_equal [:peanut,:butter], array[0,2]
    assert_equal [:and,:jelly], array[2,2]
    assert_equal [:and,:jelly], array[2,20]
    assert_equal [], array[4,0]
    assert_equal [], array[4,100]
    assert_equal nil, array[5,0]

    # NOTE:
    # array[#a, #b] ==> starting at index #a, grab #b values
    # ------------------------------------------------------
    # The array above size is 4, meaning the last index is 3. (0 - 3)
    # However when trying to grab value at index 4, we get '[]'.
    # This is due to another index included in the array (not by us) that is the ENDPOINT.
    #
    # When grabbing a value at the index PAST 4, index 5, our array is nil, because we are now outside its BOUNDS.
  end

  def test_arrays_and_ranges
    assert_equal Range, (1..5).class
    assert_not_equal [1,2,3,4,5], (1..5)
    assert_equal [1,2,3,4,5], (1..5).to_a
    assert_equal [1,2,3,4], (1...5).to_a

    # NOTE:
    # Range (1...5) will do the range from numbers 1-5, non inclusive (1,2,3,4)
    # Range (1..5) is inclusive and includes the number 5 (1,2,3,4,5)
  end

  def test_slicing_with_ranges
    array = [:peanut, :butter, :and, :jelly]

    assert_equal [:peanut,:butter,:and], array[0..2]
    assert_equal [:peanut,:butter], array[0...2]
    assert_equal [:and,:jelly], array[2..-1]
  end

  def test_pushing_and_popping_arrays
    array = [1,2]
    array.push(:last)

    assert_equal [1,2,:last], array

    popped_value = array.pop
    assert_equal :last, popped_value
    assert_equal [1,2], array
  end

  def test_shifting_arrays
    array = [1,2]
    array.unshift(:first)

    assert_equal [:first,1,2], array

    shifted_value = array.shift
    assert_equal :first, shifted_value
    assert_equal [1,2], array
  end

end
