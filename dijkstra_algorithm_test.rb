require 'test/unit'
require './dijkstra_algorithm'

class DijkstraAlgorithmTest < Test::Unit::TestCase

  GRAPH_HASH = {
    1 => {2 => 7, 3 => 9, 6 => 14},
    2 => {3 => 10, 4 => 15},
    3 => {4 => 11, 6 => 2},
    4 => {5 => 6},
    6 => {5 => 9}
  }

  def test_shortest_paths_should_thorw_error_for_empty_hash
    g = DijkstraAlgorithm.new
    assert_raise ArgumentError do
      g.shortest_paths(1, 5)
    end
  end

  def test_shortest_paths_should_thorw_error_for_source_node_not_in_graph
    g = DijkstraAlgorithm.new(GRAPH_HASH)
    assert_raise ArgumentError do
      g.shortest_paths(7, 5)
    end
  end

  def test_shortest_paths_should_thorw_error_for_destination_node_not_in_graph
    g = DijkstraAlgorithm.new(GRAPH_HASH)
    assert_raise ArgumentError do
      g.shortest_paths(1, 7)
    end
  end

  def test_shortest_paths_should_return_a_hash_with_path_and_distance
    g = DijkstraAlgorithm.new(GRAPH_HASH)
    assert_equal [1, 3, 6, 5], g.shortest_paths(1, 5)[:path]
    assert_equal 20, g.shortest_paths(1, 5)[:distance]
  end

end
