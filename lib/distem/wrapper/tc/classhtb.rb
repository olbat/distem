module TCWrapper # :nodoc: all


  class ClassHTB < Class
    TYPE="htb"

    def initialize(iface,parent,params=Hash.new)
      super(iface,parent,TYPE,params)
    end
  end

end
