require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutStrings < EdgeCase::Koan
  def test_double_quoted_strings_are_strings
    string = "Hello, World"
    assert_equal true, string.is_a?(String)
  end

  def test_single_quoted_strings_are_also_strings
    string = 'Goodbye, World'
    assert_equal true, string.is_a?(String)
  end

  def test_use_single_quotes_to_create_string_with_double_quotes
    string = 'He said, "Go Away."'
    assert_equal "He said, \"Go Away.\"", string
  end

  def test_use_double_quotes_to_create_strings_with_single_quotes
    string = "Don't"
    assert_equal "Don't", string
  end

  def test_use_backslash_for_those_hard_cases
    a = "He said, \"Don't\""
    b = 'He said, "Don\'t"'
    assert_equal true, a == b
  end

  def test_use_flexible_quoting_to_handle_really_hard_cases
    a = %(flexible quotes can handle both ' and " characters)
    b = %!flexible quotes can handle both ' and " characters!
    c = %{flexible quotes can handle both ' and " characters}
    assert_equal true, a == b
    assert_equal true, a == c
  end

  def test_flexible_quotes_can_handle_multiple_lines
    long_string = %{
It was the best of times,
It was the worst of times.
}

    assert_equal 54, long_string.length
    assert_equal 3, long_string.lines.count
    
    # NOTE:
    #
    # Though it looks like long_string is in fact 4 lines, the trailing \n (newline)
    # at the end of it is ignored. Also, Though it appears there's a total of 57 chars
    # in long_string, (51 characters plus 3 \n's), ruby counts the 3 \n's into the length (51 +3)
  end

  def test_here_documents_can_also_handle_multiple_lines
    long_string = <<EOS
It was the best of times,
It was the worst of times.
EOS
    assert_equal 53, long_string.length
    assert_equal 2, long_string.lines.count
    
    # NOTE:
    # 
    # Again, trailing \n is not counted, and beginning is not in fact a line break;
    # at the beginning of the string we notify input <<EOS.
    # Thus, we're left with (sentence1 + \n + sentence2).
    # In the case of a file input, we count all characters for a line break (\n == 2),
    # rather than with a string we count how many line breaks are present and add that # to total length
  end

  def test_plus_will_concatenate_two_strings
    string = "Hello, " + "World"
    assert_equal "Hello, World", string
  end

  def test_plus_concatenation_will_leave_the_original_strings_unmodified
    hi = "Hello, "
    there = "World"
    string = hi + there
    assert_equal "Hello, ", hi
    assert_equal "World", there
  end

  def test_plus_equals_will_concatenate_to_the_end_of_a_string
    hi = "Hello, "
    there = "World"
    hi += there
    assert_equal "Hello, World", hi
  end

  def test_plus_equals_also_will_leave_the_original_string_unmodified
    original_string = "Hello, "
    hi = original_string
    there = "World"
    hi += there
    assert_equal "Hello, ", original_string
  end

  def test_the_shovel_operator_will_also_append_content_to_a_string
    hi = "Hello, "
    there = "World"
    hi << there
    assert_equal "Hello, World", hi
    assert_equal "World", there
  end

  def test_the_shovel_operator_modifies_the_original_string
    original_string = "Hello, "
    hi = original_string
    there = "World"
    hi << there
    assert_equal "Hello, World", original_string

    # THINK ABOUT IT:
    #
    # Ruby programmers tend to favor the shovel operator (<<) over the
    # plus equals operator (+=) when building up strings.  Why?
    #
    # ANSWER:
    # They tend to use the shovel operator instead of += so that they may
    # constantly update values while continuing logical operations. It's an
    # easier way to keep track of some changing value in a program.
  end

  def test_double_quoted_string_interpret_escape_characters
    string = "\n"
    assert_equal 1, string.size
  end

  def test_single_quoted_string_do_not_interpret_escape_characters
    string = '\n'
    assert_equal 2, string.size
    
    # NOTE:
    #
    # So single quotes count \n as each character ('\' and 'n')
    # Fuck strings.
  end

  def test_single_quotes_sometimes_interpret_escape_characters
    string = '\\\''
    assert_equal 2, string.size
    assert_equal "\\'", string
  end

  def test_double_quoted_strings_interpolate_variables
    value = 123
    string = "The value is #{value}"
    assert_equal "The value is 123", string
  end

  def test_single_quoted_strings_do_not_interpolate
    value = 123
    string = 'The value is #{value}'
    assert_equal 'The value is #{value}', string
  end

  def test_any_ruby_expression_may_be_interpolated
    string = "The square root of 5 is #{Math.sqrt(5)}"
    assert_equal "The square root of 5 is 2.23606797749979", string
  end

  def test_you_can_get_a_substring_from_a_string
    string = "Bacon, lettuce and tomato"
    assert_equal "let", string[7,3]  # Start at index 7, count 3 characters
    assert_equal "let", string[7..9] # Range index 7-9 inclusive (7 - 8 - 9 HAHAHAHHHAH!)
  end

  def test_you_can_get_a_single_character_from_a_string
    string = "Bacon, lettuce and tomato"
    assert_equal 97, string[1]

    # Surprised? << Fuckyoubitch
    #
    # NOTE:
    # Ruby Koans is fucking stupid, lol jk.
    # So 97 represents the ASCII number for 'a'. Downloading the newer version of Koans,
    # this is no longer a problem and the answer comes up as 'a' (LIKE ITFUCKINGSHOULD SHIT!)
  end

  in_ruby_version("1.8") do
    def test_in_ruby_1_8_single_characters_are_represented_by_integers # lolbitch.
      assert_equal 97, ?a
      assert_equal true, ?a == 97

      assert_equal true, ?b == (?a + 1)
    end
  end

  in_ruby_version("1.9") do
    def test_in_ruby_1_9_single_characters_are_represented_by_strings
      assert_equal 'a', ?a
      assert_equal false, ?a == 97
    end
  end

  def test_strings_can_be_split
    string = "Sausage Egg Cheese"
    words = string.split
    assert_equal ["Sausage", "Egg", "Cheese"], words
  end

  def test_strings_can_be_split_with_different_patterns
    string = "the:rain:in:spain"
    words = string.split(/:/)
    assert_equal ["the", "rain", "in", "spain"], words

    # NOTE: Patterns are formed from Regular Expressions.  Ruby has a
    # very powerful Regular Expression library.  We will become
    # enlightened about them soon.
  end

  def test_strings_can_be_joined
    words = ["Now", "is", "the", "time"]
    assert_equal "Now is the time", words.join(" ") # Join with a " " in between values (of Array); that's what this means
  end

  def test_strings_are_unique_objects
    a = "a string"
    b = "a string"

    assert_equal true, a           == b
    assert_equal false, a.object_id == b.object_id
    
    # Note:
    #
    # Remember? Everything is an object in ruby and upon instantiation gains a unique object ID
  end
end
