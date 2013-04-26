# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutRegularExpressions < EdgeCase::Koan
  def test_a_pattern_is_a_regular_expression
    assert_equal Regexp, /pattern/.class
  end

  def test_a_regexp_can_search_a_string_for_matching_content
    assert_equal "match", "some matching content"[/match/]
  end

  def test_a_failed_match_returns_nil
    assert_equal nil, "some matching content"[/missing/]
  end

  def test_question_mark_means_optional
    assert_equal "ab", "abbcccddddeeeee"[/ab?/]
    assert_equal "a", "abbcccddddeeeee"[/az?/]
    
    # NOTE:
    # '?' attaches to the last character it's connected to
  end

  def test_plus_means_one_or_more
    assert_equal "bccc", "abbcccddddeeeee"[/bc+/]
  end

  def test_asterisk_means_zero_or_more
    assert_equal "abb", "abbcccddddeeeee"[/ab*/]
    assert_equal "a", "abbcccddddeeeee"[/az*/]
    assert_equal "", "abbcccddddeeeee"[/z*/]

    # THINK ABOUT IT:
    #
    # When would * fail to match?
    # Never.
  end

  # THINK ABOUT IT:
  #
  # We say that the repetition operators above are "greedy."
  #
  # Why?

  # ------------------------------------------------------------------

  def test_the_left_most_match_wins
    assert_equal "a", "abbccc az"[/az*/]
  end

  # ------------------------------------------------------------------

  def test_character_classes_give_options_for_a_character
    animals = ["cat", "bat", "rat", "zat"]
    assert_equal ["cat", "bat", "rat"], animals.select { |a| a[/[cbr]at/] }
  end

  def test_slash_d_is_a_shortcut_for_a_digit_character_class
    assert_equal "42", "the number is 42"[/[0123456789]+/]
    assert_equal "42", "the number is 42"[/\d+/]
    
    # NOTE:
    # Just because we use \d doesn't mean it turns into a decimal/integer value.
    # The answer is still given in character terms surrounded by "" (quotes).
  end

  def test_character_classes_can_include_ranges
    assert_equal "42", "the number is 42"[/[0-9]+/]
  end

  def test_slash_s_is_a_shortcut_for_a_whitespace_character_class
    assert_equal " \t\n", "space: \t\n"[/\s+/]
  end

  def test_slash_w_is_a_shortcut_for_a_word_character_class
    # NOTE:  This is more like how a programmer might define a word.
    assert_equal "variable_1", "variable_1 = 42"[/[a-zA-Z0-9_]+/]
    assert_equal "variable_1", "variable_1 = 42"[/\w+/]
  end

  def test_period_is_a_shortcut_for_any_non_newline_character
    assert_equal "abc", "abc\n123"[/a.+/]
  end

  def test_a_character_class_can_be_negated
    assert_equal "the number is ", "the number is 42"[/[^0-9]+/]
    
    # NOTE:
    # It finds the match in the string that are number (0-9), one or more (+)
    # And then negates this match out of the result (as denoted by ^)
  end

  def test_shortcut_character_classes_are_negated_with_capitals
    assert_equal "the number is ", "the number is 42"[/\D+/]
    assert_equal "space:", "space: \t\n"[/\S+/]
    # ... a programmer would most likely do
    assert_equal " = ", "variable_1 = 42"[/[^a-zA-Z0-9_]+/] # Negates all letters, numbers, and _ characters
    assert_equal " = ", "variable_1 = 42"[/\W+/] # Negates all words (2 or more letters?)
  end

  def test_slash_a_anchors_to_the_start_of_the_string
    assert_equal "start", "start end"[/\Astart/]
    assert_equal nil, "start end"[/\Aend/] # This is nil because we're at start, but can't get past space (\s), since it's not in Regexp
  end

  def test_slash_z_anchors_to_the_end_of_the_string
    assert_equal "end", "start end"[/end\z/]
    assert_equal nil, "start end"[/start\z/] # start is a match, but we have _end which isn't included in Regexp
  end

  def test_caret_anchors_to_the_start_of_lines
    assert_equal "2", "num 42\n2 lines"[/^\d+/]
    
    # NOTE:
    # Character ^ in Regexp anchors anywhere except beginning, thus
    # after our newline, and grabs our digit character 2
  end

  def test_dollar_sign_anchors_to_the_end_of_lines
    assert_equal "42", "2 lines\nnum 42"[/\d+$/] # Looking for digit, at the end.
  end

  def test_slash_b_anchors_to_a_word_boundary
    assert_equal "vines", "bovine vines"[/\bvine./] # \b denotes boundary, thus nothing before 'vine'
  end

  def test_parentheses_group_contents
    assert_equal "hahaha", "ahahaha"[/(ha)+/]
  end

  def test_parentheses_also_capture_matched_content_by_number
    assert_equal "Gray", "Gray, James"[/(\w+), (\w+)/, 1]  # The first word
    assert_equal "James", "Gray, James"[/(\w+), (\w+)/, 2] # The second word
  end

  def test_variables_can_also_be_used_to_access_captures
    assert_equal "Gray, James", "Name:  Gray, James"[/(\w+), (\w+)/]
    assert_equal "Gray", $1  # The first captured
    assert_equal "James", $2 # The second captured
  end

  def test_a_vertical_pipe_means_or
    grays = /(James|Dana|Summer) Gray/
    assert_equal "James Gray", "James Gray"[grays]
    assert_equal "Summer", "Summer Gray"[grays, 1] # Compare to Regexp grays, match = 'Summer Gray', 1st one = 'Summer'
    assert_equal nil, "Jim Gray"[grays, 1]
  end

  # THINK ABOUT IT:
  #
  # Explain the difference between a character class ([...]) and alternation (|).

  # ANSWER:
  # A character class has to match what is specified, while an alternation can test multiple different matches
  # A character class only tests for one type of match.

  def test_scan_is_like_find_all
    assert_equal ["one", "two", "three"], "one two-three".scan(/\w+/)
    
    # NOTE:
    # The character '-' separates words
  end

  def test_sub_is_like_find_and_replace
    assert_equal "one t-three", "one two-three".sub(/(t\w*)/) { $1[0, 1] }
    
    # NOTE:
    # Match to replace is "two", since it's the first word we come across starting with 't'
    # As denoted by hash, we captured $1 = two. So starting from index 0, take 1 letter [0, 1].
  end

  def test_gsub_is_like_find_and_replace_all # global substitution
    assert_equal "one t-t", "one two-three".gsub(/(t\w*)/) { $1[0, 1] }
    
    # NOTE:
    # Global replacement, so our matches are "two" & "three"
    # Starting at index 0, take the first letter of each [0, 1], captured by $1.
  end
end
