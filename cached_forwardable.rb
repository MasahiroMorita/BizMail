module CachedForwardable
  def def_delegator(accessor, method, ali = method)
    accessor = accessor.id2name if accessor.kind_of?(Integer)
    method = method.id2name if method.kind_of?(Integer)
    ali = ali.id2name if ali.kind_of?(Integer)

    module_eval(<<-EOS, "(__FORWARDABLE__)", 1)
       def #{ali}(*args, &block)
         return @_#{ali} if @_#{ali} != nil && @_#{ali}_args == args
         begin
           @_#{ali}_args = args
           @_#{ali} = #{accessor}.__send__(:#{method}, *args,&block)
         rescue Exception
           $@.delete_if{|s| /^\\(__FORWARDABLE__\\):/ =~ s} unless Forwardable::debug
           Kernel::raise
         end
       end
    EOS
  end
end