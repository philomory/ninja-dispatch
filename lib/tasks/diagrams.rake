namespace :doc do
  namespace :diagram do
    namespace :svg do
      task :models do
        sh "railroad -i -l -a -m -M | dot -Tsvg | sed 's/font-size:14.00/font-size:11.00/g' > doc/models.svg"
      end

      task :controllers do
        sh "railroad -i -l -C | neato -Tsvg | sed 's/font-size:14.00/font-size:11.00/g' > doc/controllers.svg"
      end
    end
    namespace :png do
      task :models do
        sh "railroad -i -l -a -m -M | dot -Tpng > doc/models.png"
      end

      task :controllers do
        sh "railroad -i -l -C | neato -Tpng  > doc/controllers.png"
      end
    end
    namespace :dot do
      task :models do
        sh "railroad -i -l -a -m -M > doc/models.dot"
      end

      task :controllers do
        sh "railroad -i -l -C > doc/controllers.dot"
      end
    end
  end
  namespace :diagrams do
    task :png => %w(diagram:png:models diagram:png:controllers)
    task :svg => %w(diagram:svg:models diagram:svg:controllers)
    task :dot => %w(diagram:dot:models diagram:dot:controllers)
    task :all => %w(png svg dot)
  end
  
  task :diagrams => 'diagrams:png'
end