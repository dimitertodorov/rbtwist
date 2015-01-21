module Rbtwist
  class Opsware
    class ModifiableVO
      #Override Default _set_property to take into account dirtyAttributes.
      #the dirtAttributes array defines what fields to update or create when calling create or update methods
      def _set_property sym, val
        if sym!=:dirtyAttributes
          @props[:dirtyAttributes]=Array.new unless @props[:dirtyAttributes]
        end
        self.dirtyAttributes.push(sym.to_s) unless self.dirtyAttributes.include?(sym.to_s)
        super sym,val
      end
    end
  end
end