class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def workflow
    @workflow ||= Scheduler::Workflow.const_get(self.class.name.demodulize).new(self)
  end

end
