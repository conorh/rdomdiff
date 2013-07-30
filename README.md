= Ruby Diff Dom

Simple breadth first search algorithm for diffing HTML dom trees. Requires nokogiri.

This is not meant to be a directly usable library, but a piece of code that you can re-use in your project and modify for your needs.

Notes:
* The order of the DOM nodes is ignored. So two trees with the same nodes under the same children, but re-ordered will not show as different.
* By default will show a maximum of 300 changes (otherwise too slow for my usage)
* Node equality is tested using nodes_equal which currently just compares the text if they are text nodes, otherwise the type of node (a,p,span etc.). This means that all attributes of the node are ignored.
* For my usage I wanted to ignore comment/script/cdata/br and nodes that have display: none; specified as an inline style.

== Example usage:
  require 'open-uri'

  page1 = open("http://somepage").read
  page2 = open("http://somepage").read

  doc1 = Nokogiri::HTML(page1)
  doc2 = Nokogiri::HTML(page2)

  changes = DiffDom.unordered_diff(tree1, tree2)
  changes.each do |change|
     puts change[0] # + or - to denote added or removed
     puts change[1].to_html # The DOM section that was added or removed
  end

== Credits

The basic algorithm and idea came from this library:

https://github.com/postmodern/nokogiri-diff