require File.expand_path('../helper', __FILE__)

class CountersTest < Minidoc::TestCase
  class SimpleCounter < Minidoc
    include Minidoc::Counters

    counter :counter
  end

  class AdvancedCounter < Minidoc
    include Minidoc::Counters

    counter :counter, start: 2, step_size: 3
  end

  def test_incrementing
    x = SimpleCounter.create!

    assert_equal 0, x.counter
    assert_equal 1, x.next_counter
    assert_equal 2, x.next_counter
    assert_equal 3, x.next_counter
    assert_equal 3, x.reload.counter
  end

  def test_options
    x = AdvancedCounter.create!

    assert_equal 2, x.counter
    assert_equal 5, x.next_counter
    assert_equal 8, x.next_counter
    assert_equal 11, x.next_counter
    assert_equal 11, x.reload.counter
  end

  def test_threading
    x = SimpleCounter.create!
    counters = []

    [
      Thread.new { 5.times { counters << x.next_counter } },
      Thread.new { 5.times { counters << x.next_counter } },
      Thread.new { 5.times { counters << x.next_counter } },
    ].map(&:join)

    assert_equal 15, counters.uniq.length
  end
end
