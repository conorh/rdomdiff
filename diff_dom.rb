class DiffDom
  IGNORE_NODES = ['comment','script','#cdata-section','br']

  # Some nodes we are not interested in, skip these nodes and do no comparison for them
  def self.display_none?(node)
    IGNORE_NODES.include?(node.name) ||
    node.attribute("style").to_s =~ /display:\s*none/i
  end

  def self.nodes_equal(node1, node2)
    if node1.text? && node2.text?
      node1.text == node2.text
    else
      node1.name == node2.name
    end
  end

  # Breadth first search of the DOM for nodes that differ
  def self.unordered_diff(tree1, tree2, max_changes = 300)
    changes = []
    queue = []
    queue.push([tree1, tree2])

    # NOTE: I limit the number of changes to 300, otherwise the diff can get slow on pages with huge numbers of
    # changes.
    while(queue.length > 0 && changes.length < max_changes)
      node1, node2 = queue.shift

      unchangedTree1 = {}
      unchangedTree2 = {}

      node1_children = node1.children.select {|c| !display_none?(c) }
      node2_children = node2.children.select {|c| !display_none?(c) }

      node1_children.each do |child1|
        node2_children.each do |child2|
          if (!unchangedTree2.has_key?(child2) && nodes_equal(child1, child2))
            unchangedTree1[child1] = child2
            unchangedTree2[child2] = true
            break
          end
        end

        unless unchangedTree1.has_key?(child1)
          changes << ['-', child1]
        end
      end

      node2_children.each do |child2|
        unless unchangedTree2.has_key?(child2)
          changes << ['+', child2]
        end
      end

      unchangedTree1.each do |node1, node2|
        queue.push([node1, node2])
      end
    end

    changes
  end
end