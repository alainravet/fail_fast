
class ExitTriggered < StandardError ; end

module Kernel
  def exit(param=nil)
    raise ExitTriggered.new('Kernel.exit was called')
  end
end
