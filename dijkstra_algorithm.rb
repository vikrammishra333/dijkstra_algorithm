class DijkstraAlgorithm

  #######################################################
  # It accepts the hash parameter which will represent the
  # graph. For example it should be like
  # {
  #   :node1 => {:node2 => distance, :node3 => distance},
  #   :node2 => {:node3 => distance, :node4 => distance, :node5 => distance},
  #    ...
  #    ...
  # }
  ########################################################
  def initialize(graph_hash={})
    @graph = graph_hash
  end

  # It returns a hash with shortest path between 2 given nodes of a graph
  def shortest_paths(src, dest)

    if @graph.empty?
      raise ArgumentError, "Graph hash is empty, it should not. Please pass a graph hash as a parameter to new method"
    else
      @nodes = (@graph.keys + @graph.select{|k,v| v.is_a? Hash}.map{|k,v| v.keys}.flatten).uniq
    end

    unless @nodes.include?(src)
      raise ArgumentError, "No such node in graph: #{src}"
    end

    unless @nodes.include?(dest)
      raise ArgumentError, "No such node in graph: #{dest}"
    end

    dijkstra(src, dest)
  end

  private

    def dijkstra(src, dest)
      distances = {}
      previouses = {}

      @nodes.each do |node|
        distances[node] = nil #Infinity
      end

      distances[src] = 0

      nodes = @nodes.sort

      until nodes.empty?
        nearest_node = nodes.inject do |a, b|
          next b unless distances[a]
          next a if !distances[b] or distances[a] < distances[b]
          b
        end

        if dest and nearest_node == dest
          path = get_path(previouses, src, dest)
          return { path: path, distance: distances[dest] }
        end

        neighbors = @graph[nearest_node].keys unless @graph[nearest_node].nil?

        neighbors.each do |node|

          #check node distance from nearest node if it exists
          node_distance = if @graph[nearest_node].nil?
            distances[nearest_node]
          else
            distances[nearest_node] + @graph[nearest_node][node]
          end

          #update distance of the node and its previous nodes
          if distances[node].nil? or node_distance < distances[node]
            distances[node] = node_distance
            previouses[node] = nearest_node
          end
        end

        #delete already visited nearest node
        nodes.delete nearest_node
      end

    end

    def get_path(previouses, src, dest)
      path = get_path_recursively(previouses, src, dest)
      path.is_a?(Array) ? path.reverse : path
    end

    def get_path_recursively(previouses, src, dest)
      return src if src == dest
      raise ArgumentError, "No path from #{src} to #{dest}" if previouses[dest].nil?
      [dest, get_path_recursively(previouses, src, previouses[dest])].flatten
    end

end
