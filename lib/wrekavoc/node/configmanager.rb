require 'wrekavoc'

module Wrekavoc
  module Node

    class ConfigManager
      PATH_DEFAULT_ROOTFS="/tmp/rootfs/"

      attr_reader :pnode

      def initialize
        @pnode = Wrekavoc::Resource::PNode.new(Admin.get_default_addr())
        @vnodes = {}
        @containers = {}
        #@routes
        #@tc
      end

      def get_vnode(name)
        return (@vnodes.has_key?(name) ? @vnodes[name] : nil)
      end
      
      def get_container(vnode)
        return (@containers.has_key?(vnode) ? @containers[vnode] : nil)
      end

      def include?(name)
        return @vnodes[name]
      end

      # >>> TODO: Add the ability to modify a vnode      
      def vnode_add(vnode)
        raise "VNode already exists" if @vnodes.has_key?(vnode.name)
        # >>> TODO: Check if the file is correct

        rootfsfile = Lib::FileManager.download(vnode.image)
        rootfspath = File.join(PATH_DEFAULT_ROOTFS,vnode.name)

        rootfspath = Lib::FileManager.extract(rootfsfile,rootfspath)

        @vnodes[vnode.name] = vnode
        @containers[vnode] = Node::Container.new(vnode,rootfspath)
      end

      def vnode_configure(vnode)
        raise "VNode '#{vnode.name}' not found" unless @vnodes.has_key?(vnode.name)
        @containers[vnode].configure()
      end

      def vnode_start(vnode)
        raise "VNode '#{vnode.name}' not found" unless @vnodes.has_key?(vnode.name)
        @containers[vnode].start()
      end

      def vnode_stop(vnode)
        raise "VNode '#{vnode.name}' not found" unless @vnodes.has_key?(vnode.name)
        @containers[vnode].stop()
      end

      def vnode_destroy(vnode)
        @vnodes[vnode.name] = nil
        @containers[vnode].destroy if @containers[vnode]
        @containers[vnode] = nil
      end

    end

  end
end
