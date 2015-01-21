module Rbtwist
  class Opsware
    class Map
      def to_hash
        hash={}
        items.each do |item|
          hash[item.key]=item.value
        end
        hash
      end

      def == o
        return false unless o.class == self.class
        self.to_hash==o.to_hash
      end

    end
  end
end